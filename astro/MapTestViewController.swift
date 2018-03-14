import UIKit
import Foundation

class MapTestViewController: UIViewController {
    
    weak var parentVC: UIViewController?
    var is3D = true
    
    var adSumMapViewController: ADSumMapViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let btm = UIBarButtonItem.init(title: "2D Mode", style: .plain, target: self, action: #selector(Modehandler));
        self.navigationItem.rightBarButtonItem = btm;
        
        self.adSumMapViewController = ADSumMapViewController(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        let refreshData = false;
        
        // if withExData = false
        // sdk does not download supplementary data
        // mobile adsum maps does not need supplementary data to function.
//        if self.adSumMapViewController.isMapDataAvailable() {
//            //if yes, start the map loading directly
//            debugPrint("yes, it is available")
//            self.adSumMapViewController.start()
//        } else {
//            //if no, download the map data first
////            self.adSumMapViewController.update()
//        self.adSumMapViewController.forceUpdate(withExData: refreshData);
//        }
        self.adSumMapViewController.forceUpdate(withExData: refreshData);

        self.adSumMapViewController.delegate = self
        self.adSumMapViewController.view.backgroundColor = .white
        self.view.backgroundColor = .white
        self.view.addSubview(self.adSumMapViewController.view)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //resumeRenderer will skip if the map has not been initialised.
        self.adSumMapViewController.resumeRenderer();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //pause when the view leaves the screen.
        self.adSumMapViewController.pauseRenderer();
    }
    
    func getlogos() {
        for each in self.adSumMapViewController.getPOIs() {
            if let id = each as? Int {
                //                let logos = self.adSumMapViewController.getADSLogo(fromPoi: id)
                let logoArray:NSArray = self.adSumMapViewController.getADSLogo(fromPoi: id) as! NSArray;
                debugPrint("=========")
                debugPrint(id)
                debugPrint(logoArray)
            }
        }
    }
    
    @objc func Modehandler() {
        //        removeIcons()
        getlogos()
                return
        
        if is3D {
            is3D = false
            let btm = UIBarButtonItem.init(title: "3D Mode", style: .plain, target: self, action: #selector(Modehandler))
            self.navigationItem.rightBarButtonItem = btm
            self.adSumMapViewController.setCameraMode(ObjectiveBridge().get_CameraMode_ORTHO())
            
        } else {
            is3D = true
            let btm = UIBarButtonItem.init(title: "2D Mode", style: .plain, target: self, action: #selector(Modehandler))
            self.navigationItem.rightBarButtonItem = btm
            self.adSumMapViewController.setCameraMode(ObjectiveBridge().get_CameraMode_FULL())
            
        }
    }
    
    func reloadIcons() {
        //                return
        for each in self.adSumMapViewController.getPOIs() {
            if let id = each as? Int {
                var path = ""
                if let resourcePath = Bundle.main.resourcePath {
                    let imgName = "Orange-Pin.png"
                    path = resourcePath + "/" + imgName
                }
                let logo = ADSLogo(pathToImage: path)
                logo?.setSize(70, height: 140)
                logo?.setAlwaysOnTop(true)
                logo?.setKeepAspectRatio(true)
                logo?.setAutoScale(true)
                self.adSumMapViewController.add(logo, toPoi: id)
                
            }
        }
        return
    }
    
    func drawPath(id: Int) {
        let path = self.adSumMapViewController.getPathObject()
        path?.setMotion(false)
        self.adSumMapViewController.setCurrentPosition(103.788627, lat: 1.299806, floor: 2)
        self.adSumMapViewController.drawPath(toPoi: id)
    }
}

//MAKR: - ADSumMap
extension MapTestViewController: ADSumMapViewControllerDelegate {
    
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
    
    func onPOIClicked(_ poiIds: [Any]!, placeId: Int, adSumViewController: Any!) {
        
//        let poiId = poiIds[0]
//        var logoArray:NSArray = self.adSumMapViewController.getADSLogo(fromPoi: poiId as! Int) as! NSArray;
//        for logo in logoArray{
//            let message = "Logo: \(logo as! ADSLogo)";
//            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { (action) -> Void in
//            }))
//            self.present(alert, animated: true);
//        }
        if let poiId = poiIds[0] as? Int {
            
            
            var logoArray:NSArray = self.adSumMapViewController.getADSLogo(fromPoi: poiId) as! NSArray;
            
            var logo = logoArray[0] as! ADSLogo;
            print("Logo Path: \(logo.getImagePath())")
            
            drawPath(id: poiId)
        }
        
    }
    
    func dataDidFinishUpdating(_ adSumViewController: Any!) {
        debugPrint("dataDidFinishUpdating")
        self.adSumMapViewController.start()
    }
    
    func mapDidStartLoading(_ adSumViewController: Any!) {
        debugPrint("mapDidStartLoading")
    }
    func mapDidFinishLoading(_ adSumViewController: Any!) {
        debugPrint("mapDidFinishLoading")
        self.adSumMapViewController.setCameraMode(ObjectiveBridge().get_CameraMode_FULL());
        self.adSumMapViewController.setCurrentFloor(2);
        if let logos = self.adSumMapViewController.getAllADSLogo() as? [ADSLogo] {
            for each in logos {
                //                each.poi
                //                self.adSumMapViewController.removefrom
                //                each.id
                self.adSumMapViewController.remove(each)
            }
        }
        
        reloadIcons()
    }

}

