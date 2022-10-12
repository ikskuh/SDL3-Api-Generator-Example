/*
 * Simple DirectMedia Layer
 * Copyright (C) 1997-2022 Sam Lantinga <slouken@libsdl.org>
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
*/

#include <stdint.h>

/*
 * \brief SDL_sensor.h
 *
 * SDL sensor event handling
 * In order to use these functions, SDL_Init() must have been called
 * with the ::SDL_INIT_SENSOR flag.  This causes SDL to scan the system
 * for sensors, and load appropriate drivers. { rest left out for brevity }
*/

typedef struct SDL_Sensor SDL_Sensor;

/*
 * This is a unique ID for a sensor for the time it is connected to the system, and is never reused for the lifetime of the application.
 * The ID value starts at 0 and increments from there. The value -1 is an invalid ID.
 */
typedef int32_t SDL_SensorID;

/*
 * The different sensors defined by SDL
 * Additional sensors may be available, using platform dependent semantics.
 * Hare are the additional Android sensors:
 * https://developer.android.com/reference/android/hardware/SensorEvent.html#values
 */
typedef enum {
    SDL_SENSOR_INVALID = -1, /**< Returned for an invalid sensor*/
    SDL_SENSOR_UNKNOWN = 0, /**< Unknown sensor type*/
    SDL_SENSOR_ACCEL = 1, /**< Accelerometer*/
    SDL_SENSOR_GYRO = 2, /**< Gyroscope*/
    SDL_SENSOR_ACCEL_L = 3, /**< Accelerometer for left Joy-Con controller and Wii nunchuk*/
    SDL_SENSOR_GYRO_L = 4, /**< Gyroscope for left Joy-Con controller*/
    SDL_SENSOR_ACCEL_R = 5, /**< Accelerometer for right Joy-Con controller*/
    SDL_SENSOR_GYRO_R = 6, /**< Gyroscope for right Joy-Con controller*/
} SDL_SensorType;

/*
 * Accelerometer sensor
 * The accelerometer returns the current acceleration in SI meters per
 * second squared. This measurement includes the force of gravity, so
 * a device at rest will have an value of SDL_STANDARD_GRAVITY away
 * from the center of the earth.
 * values[0]: Acceleration on the x axis
 * values[1]: Acceleration on the y axis
 * values[2]: Acceleration on the z axis
 * For phones held in portrait mode and game controllers held in front of you,
 * the axes are defined as follows:
 * -X ... +X : left ... right
 * -Y ... +Y : bottom ... top
 * -Z ... +Z : farther ... closer
 * The axis data is not changed when the phone is rotated.
 * \sa SDL_GetDisplayOrientation()
 */
#define SDL_STANDARD_GRAVITY ((float)9.80665)

/*
 * Locking for multi-threaded access to the sensor API....
 */
extern DECLSPEC void SDLCALL SDL_LockSensors(void);

extern DECLSPEC void SDLCALL SDL_UnlockSensors(void);

/*
 * ...
 */
extern DECLSPEC int SDLCALL SDL_NumSensors(void);

/*
 * ...
 */
extern DECLSPEC char const * SDLCALL SDL_SensorGetDeviceName(int device_index);

/*
 * ...
 */
extern DECLSPEC SDL_SensorType SDLCALL SDL_SensorGetDeviceType(int device_index);

/*
 * ...
 */
extern DECLSPEC int SDLCALL SDL_SensorGetDeviceNonPortableType(int device_index);

/*
 * ...
 */
extern DECLSPEC SDL_SensorID SDLCALL SDL_SensorGetDeviceInstanceID(int device_index);

/*
 * ...
 */
extern DECLSPEC SDL_Sensor * SDLCALL SDL_SensorOpen(int device_index);

/*
 * ...
 */
extern DECLSPEC SDL_Sensor * SDLCALL SDL_SensorFromInstanceID(SDL_SensorID instance_id);

/*
 * ...
 */
extern DECLSPEC char const * SDLCALL SDL_SensorGetName(SDL_Sensor * sensor);

/*
 * ...
 */
extern DECLSPEC SDL_SensorType SDLCALL SDL_SensorGetType(SDL_Sensor * sensor);

/*
 * ...
 */
extern DECLSPEC int SDLCALL SDL_SensorGetNonPortableType(SDL_Sensor * sensor);

/*
 * ...
 */
extern DECLSPEC SDL_SensorID SDLCALL SDL_SensorGetInstanceID(SDL_Sensor * sensor);

/*
 * ...
 */
extern DECLSPEC int SDLCALL SDL_SensorGetData(SDL_Sensor * sensor, float * data, int num_values);

/*
 * ...
 */
extern DECLSPEC int SDLCALL SDL_SensorGetDataWithTimestamp(SDL_Sensor * sensor, uint64_t * timestamp, float * data, int num_values);

/*
 * ...
 */
extern DECLSPEC void SDLCALL SDL_SensorClose(SDL_Sensor * sensor);

/*
 * ...
 */
extern DECLSPEC void SDLCALL SDL_SensorUpdate(void);

