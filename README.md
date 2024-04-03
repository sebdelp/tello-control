# tello-ctrl a python package to control your Tello drone

This is a package to control your Tello Drone. A significant part of the code is from the TelloPy package 
from Hanyazou and the original GOBOT project (https://gobot.io/blog/2018/04/20/hello-tello-hacking-drones-with-go)

<p align="center">
<img src="/images/telloDrone.jpg" width="25%">
</p>

Compared with the existing package, tello-ctrl:

+ has a nice documentation
+ allows logging data in background
+ allows recording video files (mkv) in background
+ allows reading all the drone sensors using the so-called "low level protocol"
+ can be used with Matlab thanks to the companion Matlab toolbox

## Installation
You can clone the github repo or use the code or you can install the package using pip.

```
$ pip install tello-ctrl
```

## Documentation
You can find the doc on the [readthedocs website](https://tello-ctrl.readthedocs.io/en/latest/).

## Examples
The documentation includes various examples in the ["Getting started"](https://tello-ctrl.readthedocs.io/en/latest/getting_started.html) examples.

```
from tello_ctrl import *
import time

drone = tello_ctrl()
drone.connect()

# request video stream and record a video file
drone.start_receiving_video(video_format='bgr24')
drone.start_recording_video_to_file('demo.mkv')

# log all the data into a csv file
drone.start_data_logging('demo.csv',sampling_time=0.5)

# let's fly
drone.takeoff()
drone.move_forward(15)
time.sleep(0.5)
drone.move_counter_clockwise(15)
time.sleep(0.5)

drone.land()

# stop recording to file and close video
drone.start_recording_video_to_file()
drone.start_receiving_video()

# stop data logging
drone.stop__data_logging()

# clean up
drone.quit()
```
