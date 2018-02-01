# How to fix the crash

- In Copy Bundle Ressources add :
path.png (the pattern use to display the path on the floor)
marker.png (the image used to display the start point (usually the user position))

- add 

override func viewWillDisappear(_ animated: Bool) {
    //deinit
    self.adSumMapViewController = nil
        
} 


- App will not crash.