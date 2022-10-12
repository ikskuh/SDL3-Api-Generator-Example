local function render_C_code(stream, data)

  local function write(...)
    for _, string in ipairs({ ... }) do
      stream:write(assert(tostring(string)))
    end
  end
  local function renderMultiline(input, prefix, postfix)
    for line in input:gmatch("[^\n\r]+") do
      stream:write(prefix or "", line, postfix or "", "\n")
    end
  end

  local named_types = {
    char = "char",
    int = "int",
    float = "float",
    Uint64 = "uint64_t",
    float32 = "float",
    float64 = "double",
  }

  local function renderType(def)
    assert(def)

    if type(def) == "string" then
      local item = assert(named_types[def], "unknown type " .. def)
      if type(item) == "string" then
        write(item)
      elseif item.export == false then
        renderType(item)
      else
        write(item.name)
      end
      return
    end

    local t = assert(tostring(def.type))
    if t == "Sint32" then
      write("int32_t")
    elseif t == "enum" then
      write("enum {\n")
      for _, item in ipairs(def.items) do
        write("    ", item.name, " = ", tostring(item.value), ", /**< ", item.description, "*/\n")
      end
      write("}")

    elseif t == "float32" then
      write("float")
    elseif t == "opaque" then
      write("struct ", def.name)
    elseif t == "pointer" then
      renderType(def.child_type)
      if def.const then
        write(" const")
      end
      write(" *")
    else
      error("unknown type: " .. t)
    end
  end

  write("/*\n")
  renderMultiline(data.licence, " * ")
  write("*/\n\n")

  write("#include <stdint.h>\n\n")

  local function renderTypes(list)
    for _, tdef in ipairs(list) do
      named_types[tdef.name] = tdef

      if tdef.export ~= false then
        if tdef.description then
          write("/*\n")
          renderMultiline(tdef.description, " * ")
          write(" */\n")
        end

        write("typedef ")
        renderType(tdef)
        write(" ", tdef.name, ";\n\n")
      end
    end
  end

  renderTypes(data.types)

  for module_name, module in pairs(data.modules) do
    write("/*\n * \\brief SDL_", module_name, ".h\n *\n")
    renderMultiline(module.description, " * ")
    write("*/\n\n")

    renderTypes(module.types)

    for _, const in ipairs(module.constants) do
      if const.description then
        write("/*\n")
        renderMultiline(const.description, " * ")
        write(" */\n")
      end
      write("#define ", const.name, " ((")
      renderType(const.type)
      write(")", const.value, ")\n\n")

    end

    for _, func in ipairs(module.functions) do
      if func.description then
        write("/*\n")
        renderMultiline(func.description, " * ")
        write(" */\n")
      end
      write("extern DECLSPEC ")
      if func.return_type then
        renderType(func.return_type)
      else
        write("void")
      end
      write(" SDLCALL ", func.name, "(")
      local params = func.parameters or {}
      if #params > 0 then
        for i = 1, #params do
          local p = params[i]
          if i > 1 then
            write(", ")
          end
          renderType(p.parameter_type)
          write(" ", p.name)
        end
      else
        write("void")
      end
      write(");\n\n")
    end
  end
end

local function render_Zig_code(stream, data)

  local function write(...)
    for _, string in ipairs({ ... }) do
      stream:write(assert(tostring(string)))
    end
  end
  local function renderMultiline(input, prefix, postfix)
    for line in input:gmatch("[^\n\r]+") do
      stream:write(prefix or "", line, postfix or "", "\n")
    end
  end

  local named_types = { char = "u8", int = "c_int", float = "f32", Uint64 = "u64", float32 = "f32", float64 = "f64" }

  local function renderType(def)
    assert(def)

    if type(def) == "string" then
      local item = assert(named_types[def], "unknown type " .. def)
      if type(item) == "string" then
        write(item)
      elseif item.export == false then
        renderType(item)
      else
        write(item.name)
      end
      return
    end

    local t = assert(tostring(def.type))
    if t == "Sint32" then
      write("i32")
    elseif t == "enum" then
      write("enum(c_int) {\n")
      for _, item in ipairs(def.items) do
        write("    /// ", item.description, "\n")
        write("    ", item.name, " = ", tostring(item.value), ",\n")
      end
      write("}")

    elseif t == "float32" then
      write("f32")
    elseif t == "opaque" then
      write("opaque{}")
    elseif t == "pointer" then
      if def.optional then
        write("?")
      end
      if def.kind == "many" then
        write("[*")
        if def.sentinel then
          write(":", def.sentinel)
        end
        write("]")

      elseif def.kind == "single" or def.kind == nil then
        assert(def.sentinel == nil)
        write("*")
      else
        error("invalid pointer type: " .. def.kind)
      end
      if def.const then
        write("const ")
      end
      renderType(def.child_type)
    else
      error("unknown type: " .. t)
    end
  end

  renderMultiline(data.licence, "//! ")

  write('const std = @import("std");\n\n')

  local function renderTypes(list)
    for _, tdef in ipairs(list) do
      named_types[tdef.name] = tdef

      if tdef.export ~= false then
        if tdef.description then
          renderMultiline(tdef.description, "/// ")
        end

        write("pub const ", tdef.name, " = ")
        renderType(tdef)
        write(";\n\n")
      end
    end
  end

  renderTypes(data.types)

  for module_name, module in pairs(data.modules) do
    renderMultiline(module.description, "/// ")
    write("pub const ", module_name, " = struct {\n")

    renderTypes(module.types)

    for _, const in ipairs(module.constants) do
      if const.description then
        renderMultiline(const.description, "/// ")
      end
      write("pub const ", const.name, ": ")
      renderType(const.type)
      write(" = ")
      write(const.value, ";\n\n")

    end

    for _, func in ipairs(module.functions) do
      if func.description then
        renderMultiline(func.description, "/// ")
      end
      write("pub extern fn ", func.name, "(")
      local params = func.parameters or {}
      if #params > 0 then
        for i = 1, #params do
          local p = params[i]
          if i > 1 then
            write(", ")
          end
          write(p.name, ": ")
          renderType(p.parameter_type)
        end
      end
      write(") ")
      if func.return_type then
        renderType(func.return_type)
      else
        write("void")
      end
      write(";\n\n")
    end

    write("};\n")
  end
end

do
  local luajson = require "json"

  local function slurp(name)
    local f = assert(io.open(name, "rb"))
    local text = f:read("*all")
    f:close()
    return assert(text)
  end

  local json_string = slurp("data.json")

  local data = assert(luajson.decode(json_string))

  do
    local f = assert(io.open("render/api.h", "wb"))
    render_C_code(f, data)
    f:close()
  end
  do
    local f = assert(io.open("render/api.zig", "wb"))
    render_Zig_code(f, data)
    f:close()
  end
end
