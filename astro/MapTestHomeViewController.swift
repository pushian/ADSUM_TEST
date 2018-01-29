//
//  MapTestHomeViewController.swift
//  astro
//
//  Created by Yangfan Liu on 29/1/18.
//  Copyright © 2018 Fooyo. All rights reserved.
//

import UIKit

class MapTestHomeViewController: UIViewController {

    fileprivate var loadMapBtn: UIButton! = {
        let t = UIButton.init(frame: CGRect.init(x: (UIScreen.main.bounds.width - 100)/2.0, y: (UIScreen.main.bounds.height - 40)/2.0, width: 100, height: 40))
        t.setTitle("Load Map", for: .normal)
        t.backgroundColor = .black
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .green
        view.addSubview(loadMapBtn)
        loadMapBtn.addTarget(self, action: #selector(loadMapHandler), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func loadMapHandler() {
        let vc = MapTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
