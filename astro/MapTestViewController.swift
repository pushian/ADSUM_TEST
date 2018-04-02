import UIKit
import Foundation

class MapTestViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    weak var parentVC: UIViewController?
    var is3D = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btm = UIBarButtonItem.init(title: "2D Mode", style: .plain, target: self, action: #selector(Modehandler));
        self.navigationItem.rightBarButtonItem = btm;
        
        
        if (app.adSumMapViewController == nil){
            app.adSumMapViewController = ADSumMapViewController(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            let refreshData = false;
            app.adSumMapViewController!.forceUpdate(withExData: refreshData);
           
        }
        
        app.adSumMapViewController!.delegate = self
        app.adSumMapViewController!.view.backgroundColor = .white
        self.view.backgroundColor = .white
        self.view.addSubview(app.adSumMapViewController!.view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //resumeRenderer will skip if the map has not been initialised.
        app.adSumMapViewController!.resumeRenderer();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //pause when the view leaves the screen.
        app.adSumMapViewController!.pauseRenderer()
        app.adSumMapViewController!.resetPath()

    }
    
    
    func getlogos() {
        for each in app.adSumMapViewController!.getPOIs() {
            if let id = each as? Int {
                //                let logos = self.adSumMapViewController.getADSLogo(fromPoi: id)
                let logoArray:NSArray = app.adSumMapViewController!.getADSLogo(fromPoi: id) as! NSArray;
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
            app.adSumMapViewController!.setCameraMode(ObjectiveBridge().get_CameraMode_ORTHO())
            
        } else {
            is3D = true
            let btm = UIBarButtonItem.init(title: "2D Mode", style: .plain, target: self, action: #selector(Modehandler))
            self.navigationItem.rightBarButtonItem = btm
            app.adSumMapViewController!.setCameraMode(ObjectiveBridge().get_CameraMode_FULL())
            
        }
    }
    
    func reloadIcons() {
        for each in app.adSumMapViewController!.getPOIs() {
            if let id = each as? Int {
                var path = ""
                if let resourcePath = Bundle.main.resourcePath {
                    let imgName = "Orange-Pin.png"
                    path = resourcePath + "/" + imgName
                    let logo = ADSLogo(pathToImage: path)
                    logo?.setSize(70, height: 140)
                    logo?.setAlwaysOnTop(true)
                    logo?.setKeepAspectRatio(true)
                    logo?.setAutoScale(true)
                    app.adSumMapViewController!.add(logo, toPoi: id)
                }
            }
        }
        return
    }
    
    func drawPath(id: Int) {
        let path = app.adSumMapViewController!.getPathObject()
        path?.setMotion(false)
        app.adSumMapViewController!.setCurrentPosition(103.788627, lat: 1.299806, floor: 2)
        app.adSumMapViewController!.drawPath(toPoi: id)
    }
}

//MAKR: - ADSumMap
extension MapTestViewController: ADSumMapViewControllerDelegate {
    
    func dataDidFinishUpdating(_ adSumViewController: Any!, withError error: Error!) {
        debugPrint("dataDidFinishUpdating with error")
        if(app.adSumMapViewController!.isMapDataAvailable()) {
            app.adSumMapViewController!.start()
            
        } else {
            let alert = UIAlertController(title: "Update finished with errors", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let yesButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(yesButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func onPOIClicked(_ poiIds: [Any]!, placeId: Int, adSumViewController: Any!) {
        
        if let poiId = poiIds[0] as? Int {
            var logoArray:NSArray = app.adSumMapViewController!.getADSLogo(fromPoi: poiId) as! NSArray;
            print("Logo Array Count: \(logoArray.count)")
            for logo in logoArray{
                var logo = logoArray[0] as! ADSLogo;
                print("Logo Path: \(logo.getImagePath())")
                self.drawPath(id: poiId)
            }
        }
    }
    
    func dataDidFinishUpdating(_ adSumViewController: Any!) {
        debugPrint("dataDidFinishUpdating")
        app.adSumMapViewController!.start()
    }
    
    func mapDidStartLoading(_ adSumViewController: Any!) {
        debugPrint("mapDidStartLoading")
    }
    func mapDidFinishLoading(_ adSumViewController: Any!) {
        debugPrint("mapDidFinishLoading")
        app.adSumMapViewController!.setCameraMode(ObjectiveBridge().get_CameraMode_FULL());
        app.adSumMapViewController!.setCurrentFloor(2);
        if let logos = app.adSumMapViewController!.getAllADSLogo() as? [ADSLogo] {
            for each in logos {
                app.adSumMapViewController!.remove(each)
            }
        }
        
        reloadIcons()
    }

}

