Video
=====

The :class:`~tello_control.tello_control` object allows receiving and decoding the video stream
sent by the drone. The obtained frames can be used as an image with any framework. It can also be 
recorded, in background, as a video file.

.. _video_request:

Video request
*************

After startup, the drone doesn't send the H.264 video stream. 
Once the :class:`~tello_control.tello_control` object has been connected to the drone using :meth:`~tello_control.tello_control.connect`, 
the video stream has to be requested using  :meth:`~tello_control.tello_control.start_receiving_video`. 
Please note that this instruction takes a lot of time to execute as it as to wait for the reception of a valid frame.
Once a valid frame is received, the video stream as to be decoeded by the `pyav` library.
Please allows up to 10 seconds.

The image resolution is either 960x720 (zoom=False) or 1280x720 (zoom=True). The zoom state can be modifed using :meth:`~tello_control.tello_control.set_zoom_state`.
You may decide to reduce the image size using the `down_sample_factor'. For instance, when using `down_sample_factor=2` and zoom=False (420x360).

The images are received as a HxWx3 numpy array. The order of the video R, G, B planes can be set using the `video_format` parameter of the
:meth:`~tello_control.tello_control.start_receiving_video` method to either `rgb24` or `bgr24`.

Once the video stream is not needed, you may call :meth:`~tello_control.tello_control.stop_receiving_video` to stop receiving the video (thereby saving CPU ressources). 


Acessing video frames
*********************
To read the current video frame, you should call the :meth:`~tello_control.tello_control.get_frame` method. 
This method sends the latest received frame a HxWx3 numpy array of byte.

If you want to check wether or not the frame has been updated since the previous call, you can use :meth:`~tello_control.tello_control.get_frame_with_no` 
that returuns a `img,no` tuple containing the image and the image number.

An example is provided in the Getting Started guide : :ref:`display_video_stream`.


Recording video in background
*****************************

Once the drone is connected and the video stream is sent by the drone (by calling the :meth:`~tello_control.tello_control.start_receiving_video` method), 
it is possible to record the  video in background with the :meth:`~tello_control.tello_controlstart_recording_video_to_file` methods. 
You must pass a file name with the mkv extention (or any other container format supported by the `pyav` package).

The optional `frame_skip` parameter allows skipping some frames to refuce the video frame per seconds (fps). The drone send the stream at 30 fps.
Setting `frame_skip=1` lead to a 15 fps. The formula to get the video file fps is :math:`\frac{30}{1+frame_skip}`.


The following code snippet allows recording a video file.

.. code-block:: python

	from tello_control import *
	import time
	
	# create a tello_control object
	drone = tello_control()
	
	# Connect to the drone (assuming the base station is connected to the drone's WIFI)
	drone.connect()
	
	# Request the video stream
	drone.start_receiving_video(video_format='bgr24')
	
	# Start recording video at 15 fps
	drone.start_recording_video_to_file('demo.mkv',frame_skip=1)

	# wait
	time.sleep(5)
	
	# Stop receiving the video stream
	drone.stop_recording_video_to_file()

	# stop receiving video
	drone.stop_receiving_video()
	
	# clean up
	drone.quit()
	

Another example is provided in the Getting Started guide : :ref:`record_video_log_data`.