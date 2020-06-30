//
//  ViewController.swift
//  widgets
//
//  Created by Christopher Cordero on 6/22/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

struct PlaceHolder {
    var width = 207
    var height = 192
    var filled = false
    
}


class ViewController: UIViewController {

    
    var xC = 0
    var yC = 0
    
    @IBAction func addWidget(_ panGesture: UIButton) {
        let newWidget = Widget(frame: CGRect(x: xC, y: yC, width: 177, height: 177))
        self.view.addSubview(newWidget)
        
        xC += 50
        yC += 50
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(widgetOne.center)
        
    }
    
    

}


