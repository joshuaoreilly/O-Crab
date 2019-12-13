# O-Crab

Parametrization Code for our [Senior Design Project](https://joshuaoreilly.com/pages/ocrab.html)

## Requirements

- SolidWorks 2019 or later
- MATLAB R2018b or later
- SolidWorks Parametrized Model (download from [GrabCAD](https://grabcad.com/library/o-crab-1))

## File Structure

We used the following file structure:

```
/Programming
	/functions
		main.m
		...A bunch of other files...
	CAD.fig
	CAD.m
/SolidWorks
	/Equations
	/Parts
		/Non-Parametrized
		/Parametrized
			O-Crab.SLDASM
			...A bunch of other parts...
```

You can't modify this without significant effort, as the path to `/SolidWorks/Equations/SpecificEquation.txt` is found in the `.m` file of that specific part.

## How to Run

To run the parametrization software, execute `CAD.m` to open the user interface. You can then choose the desired values of litter size, weight, and leg reach horizontally and vertically. When you open `SolidWorks/Parts/Parametrized/O-Crab.SLDASM`, the robot should have resized properly. Rebuilding the assembly a couple times may be necessary for SolidWorks to figure out the bellows. You can rerun the parametrization software again with new values and see the robot resize!