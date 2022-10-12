//! Simple DirectMedia Layer
//! Copyright (C) 1997-2022 Sam Lantinga <slouken@libsdl.org>
//! This software is provided 'as-is', without any express or implied
//! warranty.  In no event will the authors be held liable for any damages
//! arising from the use of this software.
//! Permission is granted to anyone to use this software for any purpose,
//! including commercial applications, and to alter it and redistribute it
//! freely, subject to the following restrictions:
//! 1. The origin of this software must not be misrepresented; you must not
//! claim that you wrote the original software. If you use this software
//! in a product, an acknowledgment in the product documentation would be
//! appreciated but is not required.
//! 2. Altered source versions must be plainly marked as such, and must not be
//! misrepresented as being the original software.
//! 3. This notice may not be removed or altered from any source distribution.
const std = @import("std");

/// SDL sensor event handling
/// In order to use these functions, SDL_Init() must have been called
/// with the ::SDL_INIT_SENSOR flag.  This causes SDL to scan the system
/// for sensors, and load appropriate drivers. { rest left out for brevity }
pub const sensor = struct {
pub const SDL_Sensor = opaque{};

/// This is a unique ID for a sensor for the time it is connected to the system, and is never reused for the lifetime of the application.
/// The ID value starts at 0 and increments from there. The value -1 is an invalid ID.
pub const SDL_SensorID = i32;

/// The different sensors defined by SDL
/// Additional sensors may be available, using platform dependent semantics.
/// Hare are the additional Android sensors:
/// https://developer.android.com/reference/android/hardware/SensorEvent.html#values
pub const SDL_SensorType = enum(c_int) {
    /// Returned for an invalid sensor
    SDL_SENSOR_INVALID = -1,
    /// Unknown sensor type
    SDL_SENSOR_UNKNOWN = 0,
    /// Accelerometer
    SDL_SENSOR_ACCEL = 1,
    /// Gyroscope
    SDL_SENSOR_GYRO = 2,
    /// Accelerometer for left Joy-Con controller and Wii nunchuk
    SDL_SENSOR_ACCEL_L = 3,
    /// Gyroscope for left Joy-Con controller
    SDL_SENSOR_GYRO_L = 4,
    /// Accelerometer for right Joy-Con controller
    SDL_SENSOR_ACCEL_R = 5,
    /// Gyroscope for right Joy-Con controller
    SDL_SENSOR_GYRO_R = 6,
};

/// Accelerometer sensor
/// The accelerometer returns the current acceleration in SI meters per
/// second squared. This measurement includes the force of gravity, so
/// a device at rest will have an value of SDL_STANDARD_GRAVITY away
/// from the center of the earth.
/// values[0]: Acceleration on the x axis
/// values[1]: Acceleration on the y axis
/// values[2]: Acceleration on the z axis
/// For phones held in portrait mode and game controllers held in front of you,
/// the axes are defined as follows:
/// -X ... +X : left ... right
/// -Y ... +Y : bottom ... top
/// -Z ... +Z : farther ... closer
/// The axis data is not changed when the phone is rotated.
/// \sa SDL_GetDisplayOrientation()
pub const SDL_STANDARD_GRAVITY: f32 = 9.80665;

/// Locking for multi-threaded access to the sensor API....
pub extern fn SDL_LockSensors() void;

pub extern fn SDL_UnlockSensors() void;

/// ...
pub extern fn SDL_NumSensors() c_int;

/// ...
pub extern fn SDL_SensorGetDeviceName(device_index: c_int) ?[*:0]const u8;

/// ...
pub extern fn SDL_SensorGetDeviceType(device_index: c_int) SDL_SensorType;

/// ...
pub extern fn SDL_SensorGetDeviceNonPortableType(device_index: c_int) c_int;

/// ...
pub extern fn SDL_SensorGetDeviceInstanceID(device_index: c_int) SDL_SensorID;

/// ...
pub extern fn SDL_SensorOpen(device_index: c_int) ?*SDL_Sensor;

/// ...
pub extern fn SDL_SensorFromInstanceID(instance_id: SDL_SensorID) ?*SDL_Sensor;

/// ...
pub extern fn SDL_SensorGetName(sensor: *SDL_Sensor) ?[*:0]const u8;

/// ...
pub extern fn SDL_SensorGetType(sensor: *SDL_Sensor) SDL_SensorType;

/// ...
pub extern fn SDL_SensorGetNonPortableType(sensor: *SDL_Sensor) c_int;

/// ...
pub extern fn SDL_SensorGetInstanceID(sensor: *SDL_Sensor) SDL_SensorID;

/// ...
pub extern fn SDL_SensorGetData(sensor: *SDL_Sensor, data: [*]f32, num_values: c_int) c_int;

/// ...
pub extern fn SDL_SensorGetDataWithTimestamp(sensor: *SDL_Sensor, timestamp: [*]u64, data: [*]f32, num_values: c_int) c_int;

/// ...
pub extern fn SDL_SensorClose(sensor: *SDL_Sensor) void;

/// ...
pub extern fn SDL_SensorUpdate() void;

};
