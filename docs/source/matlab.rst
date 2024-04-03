
Matlab
======

Using the toolbox
*****************

   * setupDroneEnv
   
In order to use the toolbox, you must first instal it. Then every program must call `setupDroneEnv`.
This script will connect Matlab to the Python virtual environement required by the :mod:`~tello_ctrl.tello_ctrl` module.
As this virtual environement has to be created, note that the first execution requires an internet access and may take some times .


   * getTelloDrone

In order to use the drone, you must use a :class:`~tello_ctrl.tello_ctrl` object. 
There is an heler function to retrive the drone object : `getTelloDrone`
   
   
So your programs should all start like this:

	 .. code-block:: matlab

			clearvars
			close all
			clc
			
			setupDroneEnv;
			drone=getTelloDrone();

Using python code with Matlab
*****************************

The :class:`~tello_ctrl.tello_ctrl` object can be interfaced with Matlab. However, there are a few important points to be noticed 
when exchanging data between Python and Matlab.

Python string list
~~~~~~~~~~~~~~~~~~~
When python expect a string list, Matlab should send a cell array of char or a cell array of string.
Let us consider the following python code:
	 
	 .. code-block:: python
	 
			drone.get_sensor_values_by_name(["posX","posY"])

	With Matlab, you cannot pass an array of string, you must use cell array instead:

	 .. code-block:: matlab
	 
			drone.get_sensor_values_by_name({"posX","posY"})

Retriving data from the drone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Matlab can retrieve automatically variables with a few data type such as `float`, `logical`/`bool`.
All the other needs to be explicitely cased to a valid Matlab type.

   * Retrieving an image with :meth:`~tello_ctrl.tello_ctrl.get_frame`
   
An image obtained with :meth:`~tello_ctrl.tello_ctrl.get_frame` is actualy a numpy array. It has to be cased as `uint8`.
You may use this code.
 
	 .. code-block:: matlab
	 
			img=uint8(drone.get_frame());


   * Retriving the control values with :meth:`~tello_ctrl.tello_ctrl.get_control`

:meth:`~tello_ctrl.tello_ctrl.get_control` provides the control values in a list that contains the 5 control values
(`left_right`,`forward_backward`, `up_down`, `yaw` and the `fast_mode` state).

	 .. code-block:: matlab
	 
			ctrl_val=double(drone.get_control());

The result is a variable `ctrl_val` that contains 5 double values. The boolean `fast_mode` state is thus converted to 0/1 value.





Sample programs
***************

exeDemo1_takeoff_land.m
~~~~~~~~~~~~~~~~~~~~~~~
This is a very simple takeoff & land program.
First, you should power the drone and connect to its WIFI.

The first step is to prepare the environement and get the drone object using `getTelloDrone`
	 .. code-block:: matlab
	 
			clearvars
			close all
			clc

			% Prepare virtual environement
			setupDroneEnv;

			% Get a drone object
			drone=getTelloDrone();

Then we can connect to the drone with the `connect` method. This allows us to access the drone data. 
We can now read the battery state of charge for instance.

	 .. code-block:: matlab
	 
			% Connect the drone object
			drone.connect();

			% Get the battery state as an uint8 variable
			batt=uint8(drone.get_battery());
			fprintf('Battery : %i\n',batt)

Finally, we can takeoff and land the done with the :meth:`~tello_ctrl.tello_ctrl.takeoff` and :meth:`~tello_ctrl.tello_ctrl.land` methods.
We also use the `bip` function to get a sound feedback.

	 .. code-block:: matlab

			% Start the takeoff procedure
			drone.takeoff();

			% Bip when takeoff is done
			bip;
			pause(2);

			% Land
			drone.land()

			% Bip when landing is over
			bip;
	
			% Clean up
			drone.quit()



Now lets put all this together (the program may be downloaded here : |exeDemo1_takeoff_land.m| ):

.. |exeDemo1_takeoff_land.m| replace::
   :download:`exeDemo1_takeoff_land.m </_download/exeDemo1_takeoff_land.m>`

.. code-block:: matlab

	clearvars
	close all
	clc

	% Prepare virtual environement
	setupDroneEnv;

	% Get a drone object
	drone=getTelloDrone();

	% Connect the drone object
	drone.connect();

	% Get the battery state as an uint8 variable
	batt=uint8(drone.get_battery());
	fprintf('Battery : %i\n',batt)

	% Start the takeoff procedure
	drone.takeoff();

	% Bip when takeoff is done
	bip;
	pause(2);

	% Land
	drone.land();

	% Bip when landing is over
	bip;

	% Clean up
	drone.quit();

.. _prog_2:

exeDemo2_manual_control.m
~~~~~~~~~~~~~~~~~~~~~~~~~

This program demonstrate how to get a manual control over the drone while 
controling it programmatically. The manual control is intended, for instance, to correct the drone position
when some drift occurs. It also allows getting the key pressed by the user so we can end the main loop
when the user press `q`.

Limitation : This only work if a figure is active and has the focuss.

We assume that the drone object has been created, that is connected to the drone and the drone is already flying.
Then we create a figure and we add the relevent callback function to capture the keypress event. This is done by the `startManualControl` function.

.. code-block:: matlab

	figure;
	startManualControl;
	
So now, a structure `manu` is created in the base workspace. It contains fields `LR`, `FB`, `UD`, `Yaw`. 
When pressing the keys, these values are incremented or decremented by 5:

   * `4`-`6` : left-right
   * `8`-`2` : forward-backward
   * `9`-`3` : up-down
   * `1`-`7` : clockwise-counter clockwise
   * `5` : remove any manual control
   
Also, a `globalKeypressed` variable is created in the base workspace and it contains the last key pressed.

When executing the code in function, you can retrieve the value of `manu` and `globalKeypressed` using:

.. code-block:: matlab

	keypressed=evalin('base','globalKeypressed');
	manu=evalin('base','manu');

Most of the time, automatic control loops needs to be exectued with fixed sampling time. One way to use this is to :

   * use a variable `i` to count the number of steps
   * use a loop to wait until the actual time reaches `i*Ts` with `Ts` the sampling time.
   
So the main control loop looks like the following code. Note that for this example, there is no automatic control applied, 
so it is explicitely left as 0. In practice, your code should provide a different control, depending on the task you want
to perform. Here we decided to stop the loop when the user press the key `q`.


.. code-block:: matlab

	% Main control loop
	tStartGlobal=tic; % Start time
	Ts=0.1; % Sampling period (second)
	ended=false;
	while  ~ended
		% Synchronization of the control loop
		while toc(tStartGlobal)<Ts*i
		   pause(0.001);
		end
		% Get user command
		keypressed=evalin('base','globalKeypressed');
		manu=evalin('base','manu');

		% Control the drone 
		drone.send_rc_control(int8(0+manu.LR), int8(0+manu.FB), int8(0+manu.UD),int8(0+manu.Yaw));

		% Stop ?
		ended= keypressed=="q";
		drawnow;
		i=i+1;
	end
   
Once we do not need to capture key press event, we can remove them using `stopManualControl`.

Now lets put all this together (the program may be downloaded here : |exeDemo2_manual_control.m| ):

.. |exeDemo2_manual_control.m| replace::
   :download:`exeDemo2_manual_control.m </_download/exeDemo2_manual_control.m>`

.. code-block:: matlab

	clearvars
	close all
	clc


	% Setup the drone programming environement
	setupDroneEnv;

	% Get a drone object
	drone=getTelloDrone();

	% Connect to the drone through WIFI
	drone.connect();

	% Get battery state
	batt=uint8(drone.get_battery());
	fprintf('Battery : %i\n',batt)

	% Try to take off
	drone.takeoff();
	
	% Bip when take off is done
	bip;


	% Create a figure to catch key pressed events
	figure;
	startManualControl; % Set the keypress callback

	% Main control loop
	tStartGlobal=tic; % Start time
	Ts=0.1; % Sampling period (second)
	ended=false;
	while  ~ended
		% Synchronization of the control loop
		while toc(tStartGlobal)<Ts*i
		   pause(0.001);
		end
		% Get user command
		keypressed=evalin('base','globalKeypressed');
		manu=evalin('base','manu');

		% Control the drone 
		drone.send_rc_control0+manu.LR, 0+manu.FB, 0+manu.UD, 0+manu.Yaw);

		% Stop ?
		ended= keypressed=="q";
		drawnow;
		i=i+1;
	end
	
	% Stop receiving key press events
	stopManualControl()

	bip;
	% Land the drone
	drone.land();
	
	% Clean up
	drone.quit()





exeDemo3_get_sensor_data.m
~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example demonstrate how to get the drone data.
We assume that a drone object has been created, the the drone is connected and that the drone is flying.

We can get drone data using the :class:`~tello_ctrl.tello_ctrl`'s methods that start with `get`:
:meth:`~tello_ctrl.tello_ctrl.get_position`, :meth:`~tello_ctrl.tello_ctrl.get_gyros`,
:meth:`~tello_ctrl.tello_ctrl.get_accelerometer`, :meth:`~tello_ctrl.tello_ctrl.get_drone_velocity`,
:meth:`~tello_ctrl.tello_ctrl.get_battery`, :meth:`~tello_ctrl.tello_ctrl.get_euler_angle`.

.. code-block:: matlab

	data1=double(drone.get_position());
	data2=double(drone.get_gyros());
	data3=double(drone.get_accelerometer());
	data4=double(drone.get_drone_velocity());
	data5=double(drone.get_battery);
	data6=double(drone.get_euler_angle());


You can also retrieve the list of all the data available using :meth:`~tello_ctrl.tello_ctrl.get_sensor_list` methods.
We can also get all the corresponding values using the `~tello_ctrl.tello_ctrl.get_sensor_values_by_name` method without any arguments.

.. code-block:: matlab

	% Get the list of all available data
	list=string(drone.get_sensor_list());

	% Get all the values, in the order indicated by get_sensor_list
	data7 = double(drone.get_sensor_values_by_name());
	

Most of the time, only a subset of the data is needed. So you can simply specify the list of data of interest as a cell array. 
Be carefull, the sensor name must mach the name provided by :meth:`~tello_ctrl.tello_ctrl.get_sensor_list`.

.. code-block:: matlab

	% Get a specified list of sensor values
	data8 = double(drone.get_sensor_values_by_name({'posX','velY','fly_mode'}));
	

Now lets put all this together (the program may be downloaded here : |exeDemo3_get_sensor_data.m| ):

.. |exeDemo3_get_sensor_data.m| replace::
   :download:`exeDemo3_get_sensor_data.m </_download/exeDemo3_get_sensor_data.m>`


.. code-block:: matlab

	clearvars
	close all
	clc


	% Basic program to demonstrate how to access drone data
	% Author: S. Delprat - INSA Hauts de France

	% Setup the drone programming environement
	setupDroneEnv;

	% Get a drone object
	drone=getTelloDrone();

	% Connect to the drone through WIFI
	drone.connect();

	% Try to takeoff
	drone.takeoff()

	% Get one sample of data
	data1=double(drone.get_position());
	data2=double(drone.get_gyros());
	data3=double(drone.get_accelerometer());
	data4=double(drone.get_drone_velocity());
	data5=double(drone.get_battery);
	data6=double(drone.get_euler_angle());

	% Get the list of all available data
	list=string(drone.get_sensor_list());

	% Get all the values, in the order indicated by get_sensor_list
	data7 = double(drone.get_sensor_values_by_name());

	% Get a specified list of sensor values
	data8 = double(drone.get_sensor_values_by_name({'posX','velY','fly_mode'}));

	% atterissage
	drone.land()


	% Clean up
	drone.quit()
	
	

exeDemo4_timed_sensor_loop.m
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A very comon task is to record sensors value with a fixed sampling period.

We assume that a drone object has been created, the the drone is connected and that the drone is flying.

First, we need to preallocate memory. This is a mandatory steps, as increasing an array size within a loop is time consumming
and a very bad programming habbit.

The following code allows getting the number of sensors by counting the number of elements provided by the :meth:`~tello_ctrl.tello_ctrl.get_sensor_list` method.
Knowing the sampling period `Ts` and the requested duration, we compute the number of sample `n`. 
Finally, we  preallocatea matrix of NaN with the proper size

.. code-block:: matlab

	% Get the number of available sensors
	List=string(drone.get_sensor_list());
	nSensor=length(List);

	% Number of samples
	duration=5;Ts=0.1;
	n=ceil(duration/Ts);


	% Préallocation
	data=NaN(nSensor,n);


Then we use a timed loop similar to the one used in :ref:`prog_2` program. We use a counter variable `i`. 
At the begining of each iteration of the main loop, we wait until the ellapsed time reaches `i*Ts`. 
Then we store the sensors values in the preallocated matrix.

.. code-block:: matlab

	t=NaN(1,60);
	i=1;tStart=tic;
	while i<n 
		% Attend fin de la période d'éch
		while toc(tStart)<i*Ts
			pause(0.001);
		end
		t(i)=toc(tStart);
		data(:,i)=double(drone.get_sensor_values_by_name());
		i=i+1;
	end
	

In order to use the recorded data, we need to guess which data is stored in which position.
This is achieved using the :meth:`~tello_ctrl.tello_ctrl.get_sensors_idx` methods that provides the index given the sensor name.

.. code-block:: matlab

	% Retrieve some signal index
	iPosX=double(drone.get_sensors_idx('posX'));
	iPosY=double(drone.get_sensors_idx('posY'));
	iPosZ=double(drone.get_sensors_idx('posZ'));

Finaly, we can display the flight data.

.. code-block:: matlab

	% Display curves
	figure;
	plot3(data(iPosX,:),data(iPosY,:),data(iPosZ,:));
	grid on
	xlabel('X');ylabel('Y');zlabel('Z')
	axis equal

Now lets put all this together (the program may be downloaded here : |exeDemo4_timed_sensor_loop.m| ):

.. |exeDemo4_timed_sensor_loop.m| replace::
   :download:`exeDemo4_timed_sensor_loop.m </_download/exeDemo4_timed_sensor_loop.m>`


.. code-block:: matlab

	clearvars
	close all
	clc


	% Sample program to record data with a fixed sampling time
	% Auteur : S. Delprat - INSA Hauts de France


	% Setup the drone programming environement
	setupDroneEnv;

	% Get a drone object
	drone=getTelloDrone();

	% Connect to the drone through WIFI
	drone.connect();

	% Try to takeoff
	drone.takeoff()

	% Get the number of available sensors
	List=string(drone.get_sensor_list());
	nSensor=length(List);


	% Number of samples
	duration=5;Ts=0.1;
	n=ceil(duration/Ts);


	% Préallocation
	data=NaN(nSensor,n);

	t=NaN(1,60);
	i=1;tStart=tic;
	while i<n 
		% Attend fin de la période d'éch
		while toc(tStart)<i*Ts
		pause(0.001);
		end
		t(i)=toc(tStart);
		data(:,i)=double(drone.get_sensor_values_by_name());
		i=i+1;
	end
	drone.land()

	% Retrieve some signal index
	iPosX=double(drone.get_sensors_idx('posX'));
	iPosY=double(drone.get_sensors_idx('posY'));
	iPosZ=double(drone.get_sensors_idx('posZ'));

	% Display curves
	figure;
	plot3(data(iPosX,:),data(iPosY,:),data(iPosZ,:));
	grid on
	xlabel('X');ylabel('Y');zlabel('Z')
	axis equal



exeDemo5_image_video.m
~~~~~~~~~~~~~~~~~~~~~~

We assume that a drone object has been created and that the the drone is connected.

In order to be able to get camera image or record videos, we first need to ask the drone to send the video stream.
This is achieved by the :meth:`~tello_ctrl.tello_ctrl.start_receiving_video`. 
Note that this function may take some time to execute (~10 seconds) as we need to wait for a valid frame sent by the drone.

Then we can get a frame using the :meth:`~tello_ctrl.tello_ctrl.get_frame` method. The frame is a HxWx3 RGB image. Each pixel is a `uint8` value.

.. code-block:: matlab

	% Request video stream from the drone
	drone.start_receiving_video()

	% Récupère 2 images
	img1=uint8(drone.get_frame());
	pause(0.1);
	img2=uint8(drone.get_frame());
	pause(0.1);

	% Display 
	figure;imshow(imtile({img1,img2}));


We can also record MKV video files in background using the :meth:`~tello_ctrl.tello_ctrl.start_recording_video_to_file` method. 
It has an optional `frame_skip`. One frame is recorded and then the specified number of frames are skipped. If we skip 2 frames, then the resulting fps is 
:math:`\frac{30}{1+2}=10 fps`.

Once the recording can be terminated by calling the :meth:`~tello_ctrl.tello_ctrl.stop_recording_video_to_file`.

.. code-block:: matlab

	% Record a video file at 10 Hz (we record one frame, then skip 2 frames, from the 30Hz stream)
	drone.start_recording_video_to_file('demoVideo.mkv',frame_skip=int8(2));

	pause(1);

	% Stoppe la video
	drone.stop_recording_video_to_file();
	

Finally, we can stop the video reception using :meth:`~tello_ctrl.tello_ctrl.stop_receiving_video`.


.. code-block:: matlab

	% Stop decoding the video stream
	drone.stop_receiving_video();

Now lets put all this together (the program may be downloaded here : |exeDemo5_image_video.m| ):

.. |exeDemo5_image_video.m| replace::
   :download:`exeDemo5_image_video.m </_download/exeDemo5_image_video.m>`


.. code-block:: matlab

	clearvars
	close all
	clc


	% Prepare virtual environement
	setupDroneEnv;

	% Get a drone object
	drone=getTelloDrone();

	% Connect the drone object
	drone.connect();

	% Request video stream from the drone
	drone.start_receiving_video()

	% Récupère 2 images
	img1=uint8(drone.get_frame());
	pause(0.1);
	img2=uint8(drone.get_frame());
	pause(0.1);

	% Display
	figure;imshow(imtile({img1,img2}));

	% Record a video file at 10 Hz (we record one frame, then skip 2 frames, from the 30Hz stream)
	drone.start_recording_video_to_file('demoVideo.mkv',frame_skip=int8(2));

	pause(1);

	% Stop recording to file
	drone.stop_recording_video_to_file();

	% Stop decoding the video stream
	drone.stop_receiving_video();

