import UIKit
import Foundation

class MapTestViewController: UIViewController {
    
    weak var parentVC: UIViewController?
    var is3D = true
    
    var adSumMapViewController: ADSumMapViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btm = UIBarButtonItem.init(title: "2D Mode", style: .plain, target: self, action: #selector(Modehandler))
        self.navigationItem.rightBarButtonItem = btm
        
        
        // Set up adSumMapViewController
//        debugPrint("the version is \(ADSumMapViewController.sha)")

        self.adSumMapViewController = ADSumMapViewController(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.adSumMapViewController.forceUpdate(withExData: true);
        self.adSumMapViewController.delegate = self
        self.adSumMapViewController.view.backgroundColor = .white
        //        self.adSumMapViewController.set
        self.view.backgroundColor = .white
        self.view.addSubview(self.adSumMapViewController.view)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //deinit adSumMapViewController
        self.adSumMapViewController = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func Modehandler() {
        //        removeIcons()
        //        return
        
        if is3D {
            is3D = false
            let btm = UIBarButtonItem.init(title: "3D Mode", style: .plain, target: self, action: #selector(Modehandler))
            self.navigationItem.rightBarButtonItem = btm
            //            let a = ADSPoi.co
            self.adSumMapViewController.setCameraMode(ObjectiveBridge().get_CameraMode_ORTHO())
            
        } else {
            is3D = true
            let btm = UIBarButtonItem.init(title: "2D Mode", style: .plain, target: self, action: #selector(Modehandler))
            self.navigationItem.rightBarButtonItem = btm
            self.adSumMapViewController.setCameraMode(ObjectiveBridge().get_CameraMode_FULL())
            
        }
    }
    
    //MAKR: - setConstraints
    
    //MAKR: - General
    
}

//MAKR: - ADSumMap
extension MapTestViewController: ADSumMapViewControllerDelegate {
    
    //    func setcen
    
    func dataDidFinishUpdating(_ adSumViewController: Any!, withError error: Error!) {
        debugPrint("dataDidFinishUpdating with error")
        if(self.adSumMapViewController.isMapDataAvailable()) {
            self.adSumMapViewController.start()
            
        } else {
            let alert = UIAlertController(title: "Update finished with errors", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let yesButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(yesButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //    func dataDidFinishUpdating(adSumViewController: AnyObject!) {
    //        debugPrint("dataDidFinishUpdating")
    //        self.adSumMapViewController.start()
    //    }
    
    func dataDidFinishUpdating(_ adSumViewController: Any!) {
        debugPrint("dataDidFinishUpdating")
        self.adSumMapViewController.start()
    }
    
    func mapDidStartLoading(_ adSumViewController: Any!) {
        debugPrint("mapDidStartLoading")
    }
    func mapDidFinishLoading(_ adSumViewController: Any!) {
        debugPrint("mapDidFinishLoading")
        //        Async.background {
        //        }
        //self.adSumMapViewController.customizeInactivePlaces(UIColor.redColor())
        self.adSumMapViewController.setCameraMode(ObjectiveBridge().get_CameraMode_FULL());
        //        self.adSumMapViewController.setCameraMode(ObjectiveBridge().get_CameraMode_ORTHO());
        self.adSumMapViewController.setCurrentFloor(2);
    }
}

