How To Get Others Builds:
1. From Lazarus IDE:
   .Open the "*.lpi" project file
       -Replace the line <Libraries ..... /> in the "*.lpi" by line from "build_*.txt"
       -Replace the line <TargetCPU ..... /> in the "*.lpi" by line from "build_*.txt"
       -Replace the line <CustomOptions ..... /> in the "*.lpi" by line from "build_*.txt"
   .Save the "*.lpi" project file 
   .Run -> Build
2. Repeat for others "build_*.txt" if needed...
3. Execute [double click] the "build.bat" file to get the Apk !
