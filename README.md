# AtwoodMachines
This is a 3D visualization written in POV-Ray that compares Atwood machines of various mass distributions and records how long it takes for each mass to hit the ground.

# Rendering
### Windows and Mac
  1. Install the official [POV-Ray editor for Windows](http://www.povray.org/download/) or the unofficial [MacOS Port](http://megapov.inetart.net/povrayunofficial_mac/index.html) (Mac)
  2. Ensure Atwood.ini and Atwood.pov are in the same directory
  3. Open Atwood.ini in the editor and press "Run"
  4. Make yourself a cup of coffee because it may take awhile to render

### Linux
  1. Install POV-Ray using your distro's package manager
     ```bash
     sudo apt -y install povray
     ```
     ```bash
     sudo pacman -S extra/povray
     ```
     ```bash
     sudo emerge media-gfx/povray
     ```
   2. cd into the directory containing Atwood.pov and Atwood.ini
   3. Render the animation
      ```bash
      povray Atwood.ini
      ```
   4. Refer to step 4 for Windows and Mac

# Post-Processing
  - POV-Ray has no support for video codecs, so the output will result in a **VERY** long image sequence that we must convert into video manually.

  - You may use the ffmpeg command in your computer's terminal to seamlessly convert your images into an mp4
    ```bash
    ffmpeg -framerate 30 -i Atwood%03d.png Atwood.mp4
    ```
    - Linux users probably already have it installed; [Mac](https://phoenixnap.com/kb/ffmpeg-mac) and [Windows](https://www.geeksforgeeks.org/installation-guide/how-to-install-ffmpeg-on-windows/) users may need to follow a guide before they can get it up and running
