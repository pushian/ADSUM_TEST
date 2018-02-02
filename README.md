# How to fix the crash

- In Build Phases - Copy Bundle Resources drag and drop :
path.png (the pattern use to display the path on the floor)
marker.png (the image used to display the start point (usually the user position))

You'll find these two files attached in the email you'll be receiving. 

- add this to MapTestViewController.swift

override func viewWillDisappear(_ animated: Bool) {

    //deinit
    self.adSumMapViewController = nil
    
        
} 



CREDITS to PUSHIAN 
https://github.com/pushian
