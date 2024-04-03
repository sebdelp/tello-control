Logging
=======

Data logging in background
**************************

Once the drone is connected, it is possible ot automatically record some or all the data (sensor & control values) using the :meth:`~tello_control.tello_control.start_data_logging` method.
The file name is a manadatory parameter. Additionnaly, you may specify the sampling tile using the `sampling_time` parameter. The list of sensor to be recorded using 
the `sensor_list` parameter and must contains a list of sensor name. You can get the list of available sensor with the meth:`~tello_control.tello_control.get_sensor_list`
method. The list of available data is discussed here : :ref:`available_sensor_and_controls`. The optional `mode` parameter allows to specify wether data should be added to an existing file (`mode="a"`)
or the file shoule be be over written (`mode="w"`).

The data are logged in a CSV file where each column is separated using the `";"` character.

You must stop the recording using the :meth:`~tello_control.tello_control.stop_data_logging` method.

The following code illustrate how to record the data at 10Hz.

.. code-block:: python

	from tello_control import *
	import time
	
	drone = tello_control()
	drone.connect()
	
	# Start logging all the data at 10Hz
	drone.start_data_logging('test1.log', sampling_time=0.1)
	
	# Do whatever is needed with the drone
	drone.takeoff()
	time.sleep(0)
	drone.land()
	
	# Stop data logging
	drone.stop_data_logging()
	
	# Clean up
	drone.quit()
	

Alternatively, you may want to only record a subset of the data. Here is how to record only the position data at 3Hz.

.. code-block:: python

	from tello_control import *
	import time
	
	drone = tello_control()
	drone.connect()
	
	# Start logging all the data at 3Hz
	drone.start_data_logging('test1.log', sensor_list=['posX','posY','posZ'], sampling_time=1/3)
	
	# Do whatever is needed with the drone
	drone.takeoff()
	time.sleep(0)
	drone.land()
	
	# Stop data logging
	drone.stop_data_logging()
	
	# Clean up
	drone.quit()


Logging :class:`~tello_control.tello_control` messages in background
**********************************************************************

Levels
~~~~~~

For debugging purpose, you may want to log the internal messages send by the :class:`~tello_control.tello_control` object.
There are four main levels of messages :

   * "ERROR" : messages indicating that something went bad
   * "WARNING" : messages indicating something unexpected, but not an error, occured
   * "INFO"  : messages indicating that a method has been exectuted as expected
   * "DEBUG" : messages that allows tracing the internal behavior of the code. There may be a lot of these messages, especially when 
     datalogging or video recording is ongoing


Console logger
~~~~~~~~~~~~~~

When creating a :class:`~tello_control.tello_control` object, a console logger is automatically created to log the error. 
You do not have to create it yourself. You may then change its level using the following code:

.. code-block:: python

	drone.set_log_level("console","INFO")

If you want you can remove the console logger with the :meth:`~tello_control.tello_control.remove_console_logger` method.
You can then later add a new console logger with :meth:`~tello_control.tello_control.add_console_logger`.
Note that you can only have a single console logger, but it can work concurently with a file logger.

File logger
~~~~~~~~~~~

The file logger works similarly to the console logger, execept that the messages are logged into the specified file.
You can add a file logger using the :meth:`~tello_control.tello_control.add_file_logger` method. 
It expect the file name as a mandatory parameter.
It has optional parameters : `level` and `mode`. When using `mode="w"`, if the file exists, it is overwritten, when using `mode="a"`, data are appended 
to the file (if it already exist).

You can change the file logger level with   `drone.set_log_level("file", level)`.
You can remove the file logger with the :meth:`~tello_control.tello_control.remove_file_logger` method. 
You are not obliged to remove the logger at the end of the program.
Note that you can only have a single file logger, but it can work concurently with a console logger.


The following code demonstrate how to use the file logger.

.. code-block:: python

	from tello_control import *
	import time
	
	drone = tello_control()
	
	# Add a file logger
	drone.add_file_logger('logfile.txt',mode='w',level="DEBUG")
	
	drone.connect()
	
	# Do whatever is needed with the drone
	drone.takeoff()
	time.sleep(0)
	
	# Change the logger level for the landing
	drone.set_log_level('file',level="ERROR")

	# Land
	drone.land()
	
	# Clean up
	drone.quit()