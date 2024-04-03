Getting started
===============

.. _simple_takeoff_land_example:

Simple takeoff land example
***************************

First the module :mod:`~tello_control.tello_control` needs to be imported. We also import ``time`` as we will need it later.

.. code-block:: python

	from tello_control import *
	import time
	

Now a drone object (:class:`~tello_control.tello_control`) can be created.

.. code-block:: python
	
	drone = tello_control()
	
In order to work properly, the drone need to be switched on, and the computer needs to be connected to the drone's WIFI.
As a result we can connect the base station (i.e. the computer that runs the program) to the drone using the :meth:`~tello_control.tello_control.connect` method.

.. code-block:: python
	
	drone.connect()
	
The drone is now ready to fly!!

We can now use the two methods :meth:`~tello_control.tello_control.takeoff` and :meth:`~tello_control.tello_control.land` to perform the simplest flight.

.. code-block:: python
	
	drone.takeoff()
	time.sleep(2) # Wait 2 seconds
	drone.land()
	
	
Finally, it is always a good idea to clean things when we have finish to use the drone. So we call the :meth:`~tello_control.tello_control.quit` method.

.. code-block:: python
	
	drone.quit()
	

Now lets put all this together (the program may be downloaded here : |python_takeoff_land.py| ):

.. |python_takeoff_land.py| replace::
   :download:`python_takeoff_land.py </_download/python_takeoff_land.py>`

.. code-block:: python
	
	from tello_control import *
	import time
	
	# create a tello_control object
	drone = tello_control()
	
	# Connect to the drone (assuming the base station is connected to the drone's WIFI)
	drone.connect()
	
	# Perform a simple fly
	drone.takeoff()
	time.sleep(2) # Wait 2 seconds
	drone.land()
	
	# finaly, cleanup
	drone.quit()
	


.. _display_video_stream:


Display the video stream
************************

The :class:`~tello_control.tello_control` object allows receive the video stream from the drone camera. 
The drone can automatically decode the received H.264 stream and make the received frame available for your programs.

In this program, we are going to display the video using the `cv2` package.

First, we start by creating a :class:`~tello_control.tello_control`  object and initiate the connection as in the :ref:`simple_takeoff_land_example` example.


.. code-block:: python

	from tello_control import *
	import time
	import cv2
	
	# create a tello_control object
	drone = tello_control()
	
	# Connect to the drone (assuming the base station is connected to the drone's WIFI)
	drone.connect()

Now, we need to request the video stream to the drone. We use :meth:`~tello_control.tello_control.start_receiving_video`.
The stream can be decoded as 'bgr24' or 'rgb24' frames. These format specify the order of the R, G, B planes. As we use `cv2`, 
we need to use `bgr24` which is the standard format for this library.

.. code-block:: python

   drone.start_receiving_video(video_format='bgr24')
   
It should be noticed that :meth:`~tello_control.tello_control.start_receiving_video` can take up to 10 seconds. 
The reason is that the video stream sent by the drone does not fully comply with the H.264 specification.

For this program, we are going to :

   * take off
   * rotate the drone around the vertical axis during 5 seconds
   * land


We first start by performing the takeoff and then we request the rotation of the drone using 
:meth:`~tello_control.tello_control.move_clockwise`


.. code-block:: python

   drone.takeoff()
   drone.move_clockwise(20)
   
Now we can start the main loop that consists in displaying frames every 1/30 of a seconds during 5 seconds.
We therefore needs 1 loop for the main program (to be executed during 5 seconds). 

.. code-block:: python

   duration = 5              # duration of the video
   Ts = 1/30                 # sampling period
   i = 0                     # loop counter
   tStart = time.time()      # current time
   
   # Main loop
   while time.time()-tStart<duration:
   
Now we need to find a way to execute the code to display the image with the desired sampling time. One could use `time.sleep(Ts)` 
but `cv2` take some time for the display. As a result the timing would not be so accurate. Instead, we just wait until the time reaches the value 
`tStart+i*Ts`. This way whatever the innerloop execution duration is, we have an accurate non-drifting timing.
 
.. code-block:: python

       # Wait for next 1/30 of second
	   while time.time()<tStart+i*Ts:
	      time.sleep(0.001)
	  
To get a frame from the video stream, we simply call :meth:`~tello_control.tello_control.get_frame`. 
This methods provide the image as a HxWx3 numpy array. The method :meth:`~tello_control.tello_control.get_frame_with_no`
also returns the current frame number (this way, we may know if the frame has been update not).
We can display the image using `cv2.imshow`.

.. code-block:: python

		 	img =drone.get_frame()
		 	cv2.imshow('Tello drone',img)
		 	cv2.waitKey(1) # force cv2 to display the image now
			# Next iteration
			i=i+1 

Once the 5 seconds are ellapsed, we destroy the cv2 window and stop rotating the drone and perform landing

.. code-block:: python

   cv2.destroyAllWindows()
   drone.move_clockwise(0)
   drone.land()

Finaly, we can stop decoding video using :meth:`~tello_control.tello_control.stop_receiving_video` and perform clean-up

.. code-block:: python
   
   drone.stop_receiving_video()
   drone.quit()

Now lets put all this together (the program may be downloaded here : |python_video.py| ):

.. |python_video.py| replace::
   :download:`python_video.py </_download/python_video.py>`


.. code-block:: python

	from tello_control import *
	import time
	import cv2

	# create a tello_control object
	drone = tello_control()

	# Connect to the drone (assuming the base station is connected to the drone's WIFI)
	drone.connect()

	# request the video stream
	print('Starting video receiption')
	drone.start_receiving_video(video_format='bgr24')

	# Perform takeoff and rotate clockwise
	drone.takeoff()
	drone.move_clockwise(20)

	# Parameters
	duration = 2              # duration of the video
	Ts = 1/30                 # sampling period
	i = 0                     # loop counter
	tStart = time.time()      # current time

	# Main loop
	while time.time()-tStart<duration:
		# Wait for next 1/30 of second
		while time.time()<tStart+i*Ts:
			time.sleep(0.001)
			
		# get a frame from the video
		img=drone.get_frame()
		
		# display the frame
		cv2.imshow('Tello drone',img)
		cv2.waitKey(1) # force cv2 to display the image now

		# Next iteration
		i=i+1 
		
	# Close windows
	cv2.destroyAllWindows()


	# Land the drone
	drone.move_clockwise(0)
	drone.land()

	# stop receiving video
	drone.stop_receiving_video()

	# clean up
	drone.quit()


.. _record_video_log_data:


Recording video and logging data
********************************

The :class:`~tello_control.tello_control` object allows recording the received video and logging all the sensor and control
data in a background task. Note that encoding the video into a file requires some CPU ressources.

* Logging data to a CSV file

Once the drone is connected, we can log all the sensors value periodically to a file using :meth:`~tello_control.tello_control.start_data_logging`.
Once logging is not necessary you can use :meth:`~tello_control.tello_control.stop_data_logging`.

The method :meth:`~tello_control.tello_control.start_data_logging` requires the CSV file name as a parameter and has an optional 
`sampling_time` parameter to specify the duration betwene 2 lines of the CSV files. You may also specify the `mode` parameter as `"w"` or `"a"` for overwrite/append.


Alternatively, you may prefer logging data manually. In that case, simply provide a negative `sampling_time` when calling 
:meth:`~tello_control.tello_control.start_data_logging`. You will then have to call :meth:`~tello_control.tello_control.data_logging_request`
whenever you need to record the data.

The sequence to intiate the data logging is :

:meth:`~tello_control.tello_control.connect` -> :meth:`~tello_control.tello_control.start_data_logging`.

The sequence to stop data logging is :

:meth:`~tello_control.tello_control.stop_data_logging` -> :meth:`~tello_control.tello_control.quit`.



* Recording a video file

To record the video to an `mkv` file, once the video stream is received by the drone, we simply need to call 
:meth:`~tello_control.tello_control.start_recording_video_to_file`. The recording can then later be stopped using 
:meth:`~tello_control.tello_control.stop_recording_video_to_file` .

The :meth:`~tello_control.tello_control.start_recording_video_to_file` method requires a file name as a parameter and has an optional
`frame_skip` that allows skipping some frame to reduce the CPU load.


The sequence to intiate video recording is :

:meth:`~tello_control.tello_control.connect` -> :meth:`~tello_control.tello_control.start_receiving_video` 
-> :meth:`~tello_control.tello_control.start_recording_video_to_file` 

The sequence to video recording is :

:meth:`~tello_control.tello_control.stop_recording_video_to_file` -> :meth:`~tello_control.tello_control.stop_receiving_video`.
-> :meth:`~tello_control.tello_control.quit`.



* Example Program

By adding a few lines to the :ref:`display_video_stream` example we can log data in a CSV file and record the video.

The program may be downloaded here : |python_record_video_log_data.py| :

.. |python_record_video_log_data.py| replace::
   :download:`python_record_video_log_data.py </_download/python_record_video_log_data.py>`



.. code-block:: python

	from tello_control import *
	import time
	import cv2

	# create a tello_control object
	drone = tello_control()
	drone.add_file_logger('drone.log',mode='w',level='DEBUG')

	# Connect to the drone (assuming the base station is connected to the drone's WIFI)
	drone.connect()

	# request the video stream
	print('Starting video receiption')
	drone.start_receiving_video(video_format='bgr24')

	# start recording the video at 15fps (skip 1 frame on a 30fps stream)
	print('Starting video recording')
	drone.start_recording_video_to_file('demo.mkv',frame_skip=1)

	# start data logging every half seconds
	print('Starting data logging')
	drone.start_data_logging('demo.csv',sampling_time=0.5)

	# Perform takeoff and rotate clockwise
	drone.takeoff()
	drone.move_clockwise(20)

	# Parameters
	duration = 5              # duration of the video
	Ts = 1/30                 # sampling period
	i = 0                     # loop counter
	tStart = time.time()      # current time

	# main loop
	while time.time()-tStart<duration:
		# Wait for next 1/30 of second
		while time.time()<tStart+i*Ts:
			time.sleep(0.001)
		
		# get a frame from the video
		img = drone.get_frame()
		
		# display the frame
		cv2.imshow('Tello drone',img)
		cv2.waitKey(1) # force cv2 to display the image now
		
		i=i+1

	# Close windows
	cv2.destroyAllWindows()


	# Land the drone
	drone.move_clockwise(0)
	drone.land()

	# stop recording video
	drone.stop_recording_video_to_file()

	# stop receiving video
	drone.stop_receiving_video()

	# stop data logging
	drone.stop_data_logging()

	# clean up
	drone.quit()