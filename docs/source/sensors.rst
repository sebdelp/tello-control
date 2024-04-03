.. _available_sensor_and_controls:



Available sensors and controls
==============================

For the sake of convenience, control values are also included in the sensor list.
This list includes most of the signals available in the communication protocol. This protocol being 
common to several DJI drones, some signals does not makes sense for the Tello (e.g. longitude & latitude
that are only available for drones equipped with a GPS).

NB: With a small abuse of language, all the data sent by the drone are denoted as "sensor measurement" or "sensor values" even
if some of them are computed signals or drone status.


Sending controls
****************

Takeoff and landing are achived using :meth:`~tello_control.tello_control.takeoff` and :meth:`~tello_control.tello_control.land`.
They both accept an optional `bool` parameter `blocking`. The default value blocks the program execution until the end of the takeoff 
or landing phase. Note that the takeoff phase can be quite long as it includes internal initialization (Inertial Measurement Unit (IMU), etc).
An optional `timeout` parameter can also be passed.


The drone is control by the four stick positions: left_right, forward_backward, up_down and yaw.
There also exist a fast_mode switch.

The stick positions can be set four at a time using :meth:`~tello_control.tello_control.send_rc_control`.
The fast_mode can be set using :meth:`~tello_control.tello_control.set_fast_mode`.

Individual axis movements can be set using the following methods (they all start with `move_`). 
They all requires parameter in the 0-100 value range.

   * Longitudinal axis: :meth:`~tello_control.tello_control.move_backward`, :meth:`~tello_control.tello_control.move_forward`
   * Vertical axis: :meth:`~tello_control.tello_control.move_up`, :meth:`~tello_control.tello_control.move_down`
   * Lateral axis: :meth:`~tello_control.tello_control.move_right`, :meth:`~tello_control.tello_control.move_left`
   * Rotation around vertical axis : :meth:`~tello_control.tello_control.move_clockwise` :meth:`~tello_control.tello_control.move_counter_clockwise`
   
Alternatively, the individual stick position can be set in the -100/100 range using:
:meth:`~tello_control.tello_control.set_forward_backward`,
:meth:`~tello_control.tello_control.set_left_right`,
:meth:`~tello_control.tello_control.set_up_down`,
:meth:`~tello_control.tello_control.set_yaw`


You may also perform accrobatic flips (they all start with `flip_`) using:
:meth:`~tello_control.tello_control.flip_back`,
:meth:`~tello_control.tello_control.flip_backleft`,
:meth:`~tello_control.tello_control.flip_backright`,
:meth:`~tello_control.tello_control.flip_forward`,
:meth:`~tello_control.tello_control.flip_forwardleft`,
:meth:`~tello_control.tello_control.flip_forwardright`,
:meth:`~tello_control.tello_control.flip_left`,
:meth:`~tello_control.tello_control.flip_right`,





Reading sensor values
*********************

There exists a few different ways to get the sensors values. All the related methods of the :class:`~tello_control.tello_control` 
object start with `get_`.

First, it is possible to get the list of all the available sensors using :meth:`~tello_control.tello_control.get_sensor_list`.

You may them get some (or all) the values using their names with :meth:`~tello_control.tello_control.get_sensor_values_by_name`.
Alternatively, you may retrieve the values using their index with :meth:`~tello_control.tello_control.get_sensor_values_by_index`. 
You may use :meth:`~tello_control.tello_control.get_sensors_idx` to retrieve a sensor index using its name.

:meth:`~tello_control.tello_control.get_sensor_values_by_name` should be prefered method as it is robust to future code change. 
*There is no garanty that in the future release of the `tello_control` package, the sensor list remains in the same order.*

Here are the methods available to retrieve data:

   * Sensor by name or index 
   
       :meth:`~tello_control.tello_control.get_sensor_list`,
       :meth:`~tello_control.tello_control.get_sensor_values_by_index`,
       :meth:`~tello_control.tello_control.get_sensor_values_by_name`,
       :meth:`~tello_control.tello_control.get_sensors_idx`


   * Drone state
   
	   :meth:`~tello_control.tello_control.get_accelerometer`, 
	   :meth:`~tello_control.tello_control.get_drone_velocity`, 
	   :meth:`~tello_control.tello_control.get_euler_angle`, 
	   :meth:`~tello_control.tello_control.get_ground_velocity`, 
	   :meth:`~tello_control.tello_control.get_gyros`, 
	   :meth:`~tello_control.tello_control.get_position`, 
	   :meth:`~tello_control.tello_control.get_position`, 
	   :meth:`~tello_control.tello_control.get_position`, 
	   :meth:`~tello_control.tello_control.get_position`, 
   
   * Drone status

	   :meth:`~tello_control.tello_control.get_fly_mode`, 
	   :meth:`~tello_control.tello_control.get_mvo_pos_valid`, 
	   :meth:`~tello_control.tello_control.get_mvo_vel_valid`, 

   * Miscellaneous

	   :meth:`~tello_control.tello_control.get_battery`, 
   
   * Controls

	   :meth:`~tello_control.tello_control.get_fast_mode`, 
	   :meth:`~tello_control.tello_control.get_control`, 
   


Sensors
*******

The name of the available sensor measurements are given on the following tables. Each table corresponds to one message send by the drone.
Note that the given explanation on each individual signal can be quite approximative.

Flight data
-----------
	
	.. table:: Flight data
	
	   +--------------------------------+-------------+---------------------------------------------+
	   | sensor name                    | type        | explanation                                 |
	   +================================+=============+=============================================+
	   | battery_low                    | bool        | True when the battery percentage is         |
	   |                                |             | lower that the low battery threshold.       |
	   +--------------------------------+-------------+---------------------------------------------+
	   | battery_lower                  + bool        +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + battery_percentage             + byte        + battery state of charge (0-100)             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + camera_state                   + bool        +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + down_visual_state              + bool        +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + drone_battery_left             + byte        +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + drone_fly_time_left            + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + drone_hover                    + bool        + True when the drone is flying standstill    +
	   +--------------------------------+-------------+---------------------------------------------+
	   + em_open                        + bool        +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + em_sky                         + bool        + True when the drone is flying               +
	   +--------------------------------+-------------+---------------------------------------------+
	   + em_ground                      + bool        + True when the drone is on the ground        +
	   +--------------------------------+-------------+---------------------------------------------+
	   + east_speed                     + byte        +    a                                        +
	   +--------------------------------+-------------+---------------------------------------------+
	   + electrical_machinery_state     + bool        +   a                                         +
	   +--------------------------------+-------------+---------------------------------------------+
	   + factory_mode                   + bool        +   a                                         +
	   +--------------------------------+-------------+---------------------------------------------+
	   + fly_mode                       + byte        +   * ''1'' stands for flying.                +
	   +                                +             +   * ''6'' stands for hoovering or grouned   + 
	   +                                +             +   * ''11'' stands for taking off            +
	   +                                +             +   * ''12'' stands for landing.              +
	   +--------------------------------+-------------+---------------------------------------------+
	   + fly_speed                      + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + fly_time                       + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + front_in                       + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + front_lsc                      + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + front_out                      + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + gravity_state                  + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + ground_speed                   + float       +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + height                         + int         + Low resolution altitude                     +
	   +--------------------------------+-------------+---------------------------------------------+
	   + imu_calibration_state          + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + imu_state                      + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + light_strength                 + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + north_speed                    + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + outage_recording               + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + power_state                    + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + pressure_state                 + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + smart_video_exit_mode          + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + temperature_height             + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + throw_fly_timer                + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + wifi_disturb                   + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + wifi_strength                  + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
	   + wind_state                     + int byte    +                                             +
	   +--------------------------------+-------------+---------------------------------------------+
 
 
 
MVO (Monocular Vision Odometry)
-------------------------------
      
	  The Tello Drone uses a low resolution near infra-red downward facing camera to film the ground.
	  This camera allows to estimate the drone position using some how the same principle as computer mouse do.
	  Basically, by measuring two frames, one can estimate the displacement.
	  However, this estimation is not error free. The actual position being obtained by accumulation 
	  of this displacement, it is therefore subject to a possible drift (accumulation of small error 
	  over time).
	  
	.. table:: MVO data
	
	   +--------------------------------+-------------+---------------------------------------------+
	   | sensor name                    | type        | explanation                                 |
	   +================================+=============+=============================================+
	   | velX, velY, velZ               | float       | Velocity in th drone frame                  |
	   +--------------------------------+-------------+---------------------------------------------+
	   | posX, posY, posZ               | float       | Velocity in th drone frame                  |
	   +--------------------------------+-------------+---------------------------------------------+
	   | velX                           | float       | Velocity in th drone frame                  |
	   +--------------------------------+-------------+---------------------------------------------+
	   | posCov1, posCov2, ..., posCov6 | float       | Some element of the Kalman filter           |
	   |                                |             | covariance matrix                           |
	   +--------------------------------+-------------+---------------------------------------------+
	   | velCov1, velCov2, ..., velCov6 | float       | Some element of the Kalman filter           |
	   |                                |             | covariance matrix                           |
	   +--------------------------------+-------------+---------------------------------------------+
	   | tof                            | float       | Time of fligh sensor (ultrasonic?)          |
	   +--------------------------------+-------------+---------------------------------------------+
	   | tofUncertainty                 | float       | Uncertainty on the tof measurement          |
	   +--------------------------------+-------------+---------------------------------------------+
	   | mov_valid_velX, mov_valid_velY | bool        | Indicate if the velocity are valid          |
	   | mov_valid_velZ                 |             |                                             |
	   +--------------------------------+-------------+---------------------------------------------+
	   | mov_valid_posX, mov_valid_posY | bool        | Indicate if the velocity are valid          |
	   | mov_valid_posZ                 |             |                                             |
	   +--------------------------------+-------------+---------------------------------------------+
	   

IMU (Inertial Measurement Unit)
-------------------------------

The Inertial Measurement Unit consists in 3 gyroscopes and three accelerometers. Using a Kalman filter, it
is possible to estimate the drone X,Y, Z acceleration and velocity as well as angles and angular speed.
When a GPS is available, if is also possible to estimate the drone position with a high frequency and accuracy.
Unfortunately, the Tello drone is *not* equipped with a GPS. The position information is likely to be 0.

	.. table:: MVO data
	
	   +--------------------------------+-------------+---------------------------------------------+
	   | sensor name                    | type        | explanation                                 |
	   +================================+=============+=============================================+
	   | longitude, latitude            | double      | Drone position. N/A                         |
	   +--------------------------------+-------------+---------------------------------------------+
	   | baro, baro_smooth              | float       | barometer pressure. Helps estimating the    |
	   |                                |             | altitude                                    |
	   +--------------------------------+-------------+---------------------------------------------+
	   | accX, accY, accZ               | float       | Acceleration in the drone frame             |
	   +--------------------------------+-------------+---------------------------------------------+
	   | gyroX, gyroY, gyroZ            | float       | Angular rotation speed  in the drone frame  |
	   +--------------------------------+-------------+---------------------------------------------+
	   | qW,qX,qY,qZ                    | float       | Quaternion                                  |
	   +--------------------------------+-------------+---------------------------------------------+
	   | velX, velY, velZ               | float       | Velocity in the drone frame                 |
	   +--------------------------------+-------------+---------------------------------------------+
	   | yaw, pitch, roll               | float       | Euler's angles                              |
	   +--------------------------------+-------------+---------------------------------------------+
       
	   
exIMU (Extended Inertial Measurement Unit)
------------------------------------------

By combining the Inertial Measurement Unit and the Monocular Vision Odometry, it is possible to get a 
better estimation of the position and angles. All the corresponding sensor name ends with ``_VO``.

	.. table:: exIMU data

	   +--------------------------------+-------------+---------------------------------------------+
	   | sensor name                    | type        | explanation                                 |
	   +================================+=============+=============================================+
	   | velX_VO, velY_VO, velZ_VO      | float       | Velocity in the drone frame                 |
	   +--------------------------------+-------------+---------------------------------------------+
	   | posX_VO, posY_VO, posZ_VO      | float       | Position in the drone frame                 |
	   +--------------------------------+-------------+---------------------------------------------+
	   | dist_VO                        | float       | tof sensor                                  |
	   +--------------------------------+-------------+---------------------------------------------+
	   | vel_VO                         | float       | Velocity from the tof sensor                |
	   +--------------------------------+-------------+---------------------------------------------+
	   | rtkLat_VO, rtkAlt_VO           | float       | RTK position (N/A)                          |
	   +--------------------------------+-------------+---------------------------------------------+
	   | error_flag_VO                  | int         | Error flag                                  |
	   +--------------------------------+-------------+---------------------------------------------+



Controls
********

The :class:`~tello_control.tello_control` object allows sending control to the drone. 
The actual control values can be retrieved along the sensor measurements using :meth:`~tello_control.tello_control:get_sensor_values_by_index` 
or :meth:`~tello_control.tello_control:get_sensor_values_by_name`.

The controls corresponds to the stick four position and a ``fast_mode`` command.

	.. table:: controls

	   +--------------------------------+-------------+---------------------------------------------+
	   | sensor name                    | type        | explanation                                 |
	   +================================+=============+=============================================+
	   | left_right                     | float       | value in the -100/100 range                 |
	   +--------------------------------+-------------+---------------------------------------------+
	   | forward_backward               | float       | value in the -100/100 range                 |
	   +--------------------------------+-------------+---------------------------------------------+
	   | up_down                        | float       | value in the -100/100 range                 |
	   +--------------------------------+-------------+---------------------------------------------+
	   | yaw                            | float       | value in the -100/100 range                 |
	   +--------------------------------+-------------+---------------------------------------------+
	   | fast_mode                      | bool        | True to activate the fast_mode              |
	   +--------------------------------+-------------+---------------------------------------------+

