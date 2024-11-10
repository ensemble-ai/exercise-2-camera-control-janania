# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Noor Ashour
* *email:* nwashour@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The Position Lock camera works as expected. However, a cross isn't drawn even when I turn on "Draw Camera Logic". (this option wasn't originally turned on for the cameras on my end). There's a function call for drawing a cross in an if-statement, but placing a breakpoint shows that the function is never called.

___
### Stage 2 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The draw logic doesn't get called here either, I couldn't see the box frame. Otherwise, it seems to be working as expected, the camera is constantly moving along the x-z plane.

___
### Stage 3 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera follows the vessel and catches up, but if hyperspeed is triggered (ie pressing the space bar), the vessel goes out of frame and the player has to wait for the camera to catch up. I also notice some jittering when the player is moving around, though I also experienced this problem. I found that converting the vessel's `_physics_process` to `_process` reduced jittering. It can also be an issue related to the to leash distance.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
When I first switch to this camera, either the vessel or the camera's location is off-screen at first but the camera eventually catches up. There is more jittering than the previous camera, and the camera's direction doesn't fully follow the vessel when it changes direction. Similar to the last camera, camera doesn't follow the vessel when using hyperspeed, but eventually catches up.
The exported field's values are overwritten in the `_ready` function, which I don't think is ideal for testing because it negates the exported aspect. I had to test them out by changing the values in the code. If I lower the leash distance, I expected it to limit the distance between the vessel and the camera, but instead it increased and the vessel would go out of frame. 

___
### Stage 5 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
It works as expected, the camera doesn't move when the vessel is in the inner box, but starts moving when it's in the speedup zone and increases speed when the vessel touches the pushbox edges. It also works well when using hyperspeed. I'm ranking as Great because, like the rest of the cameras, the drawn borders aren't visible. For this camera, I had to re-order the CameraSelector `cameras` array so that the Stage 5 camera is at index 0, in order to see its box borders.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
- There are several warnings in the Editor about integer division, such as [this float variable](https://github.com/ensemble-ai/exercise-2-camera-control-janania/blob/1d2d947c39aca192ea4f2f0efc9b9a5e092abcc8/Obscura/scripts/camera_controllers/position_lock.gd#L28). When assigning values to floats, they should be in decimal form (such as `var left:float = -5.0 / 2.0`) to avoid the decimal part being discarded.
- Functions should be separated by 2 blank lines instead of 1, and declared variables at the top should be separated by 2 blank lines from the first function.
- [This variable](https://github.com/ensemble-ai/exercise-2-camera-control-janania/blob/1d2d947c39aca192ea4f2f0efc9b9a5e092abcc8/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L116) should have the type included in its declaration. At first glance, it was hard for me to determine its type since its value is several lines long. The same goes for [the variable beneath it](https://github.com/ensemble-ai/exercise-2-camera-control-janania/blob/1d2d947c39aca192ea4f2f0efc9b9a5e092abcc8/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L121).
	- 2 indent levels should be used to distinguish continuation lines from regular code blocks, unless if it's an array, enum, or dictionary.
- Some lines are longer than 100 characters, [like this one](https://github.com/ensemble-ai/exercise-2-camera-control-janania/blob/1d2d947c39aca192ea4f2f0efc9b9a5e092abcc8/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L49) and should be kept under that limit (though ideally under 80 if possible). Godot's editor by default shows 2 column lines to indicate these limits, which can be helpful to keep lines short and more readable
#### Style Guide Exemplars ####
- Variable ordering follows the style guidelines, with export variables being above public ones
- Snake case is followed for variable and function names
- Logic in functions is separated by single blank lines to make the code more readable

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
- There are some comments being used, but I think additional comments can be made
- Class names should be included for the cameras. I did see one for [Stage 1](https://github.com/ensemble-ai/exercise-2-camera-control-janania/blob/1d2d947c39aca192ea4f2f0efc9b9a5e092abcc8/Obscura/scripts/camera_controllers/position_lock.gd#L1) but not the other stages
- I found that the [`draw_cross`](https://github.com/ensemble-ai/exercise-2-camera-control-janania/blob/1d2d947c39aca192ea4f2f0efc9b9a5e092abcc8/Obscura/scripts/camera_controllers/position_lock.gd#L20) function being copy-pasted across cameras, but I think it would be better to have this function in their parent script, `CameraControllerBase`. Any camera with this parent can then call this function
- There seemed to be 1 large Github push, but it's best practice to commit smaller, multiple changes throughout development.
- There were warnings across camera scripts about unused or shadowing variables
- For better node/scene organization, the camera nodes should be housed in a parent node, such as a Node called Cameras

#### Best Practices Exemplars ####
- Functions are created to house larger amounts of code so that it's more readable
- Variable and function names are well-descripted
