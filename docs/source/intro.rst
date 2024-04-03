Introduction
============
:mod:`~tello_ctrl.tello_ctrl` is a package that allows controlling a Tello drone from Python. It provides access to many of the drone 
senors and estimations (position, velocity, acceleration, angle, battery percentage, etc) and access to the video.

As soon as the drone is connected, this library allows to automatically log the measurement and control to a csv file and record the video.

Acknowlegement
**************

Most of the low level communication code is copied from the ``TelloPy`` library. All the credits goes to its author Hanyazou.

Installation
************

You can install the ``tello-ctrl`` package using pip:

.. code-block:: 

	$ pip install tello-drone

Limitations
***********

It is very usual that the library used to decode the video (``pyav``) struggle to decode the stream sent by the drone during the first 5 seconds or so.
This occurs because it seems that the drone does not set properly some information in the H.264 video stream.
As a result, the connection to the video stream sent by the drone takes some time.


Video processing is CPU intensive. Parallelism helps, but recoring the video to a file may lead to high CPU load depending on your computer configuration.
In case of any CPU issue, it is suggested to use the ``downsample_factor`` of :meth:`~tello_ctrl.tello_ctrl.start_receiving_video` to reduce the CPU load.