 # How to reproduce the crash
 
 - run "pod install"
 - open the workspace and run the project
 - Run "pod install"
 - Open the astro.xcworkspace and run the project
 - Click the "Load Map" button
 - Wait until the map is fully loaded
 - Click the "back" button at the top left corner


# How to fix the crash

- In Build Phases - Copy Bundle Resources drag and drop :
path.png (the pattern use to display the path on the floor)
marker.png (the image used to display the start point (usually the user position))

- add this to MapTestViewController.swift

override func viewWillAppear(_ animated: Bool) {
        
    //resumeRenderer will skip if the map has not been initialised.
    self.adSumMapViewController.resumeRenderer();
}


override func viewDidDisappear(_ animated: Bool) {

    //pause when the view leaves the screen.
    self.adSumMapViewController.pauseRenderer();
} 
