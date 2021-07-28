# MatLab_3D_Tracking
Script for 3D particle tracking in generic field map

* MAIN_Tracking.m               --> MAIN tracking file: read field map, read input particle file, do the tracking, post processing
* Read_Magnetic_Field.m         --> read CVS file of the field map and save in a .mat file to be used in MAIN_Tracking
* Tracking_3D_From_File.m       --> where the differential equation of motion is solved
* PostProcessing_Tracking_3D.m  --> a set of post processing procedure to generate various plots
  
