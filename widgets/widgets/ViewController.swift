//
//  ViewController.swift
//  widgets
//
//  Created by Christopher Cordero on 6/22/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var widgetOne: UIView!

    
    @IBAction func panView(_ sender: UIPanGestureRecognizer) {
            //
            let translation = sender.translation(in: self.view)

            if let viewToDrag = sender.view {
                viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x,
                    y: viewToDrag.center.y + translation.y)
                sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                
            }
            //
            
            //print("x \(translation.x)")
            //print("y \(translation.y)")
            
            
            if (abs(108.5 - sender.view!.center.x) <= 98.5 && abs(132.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 108.5, y: 132.5)
            }
            else if (abs(305.5 - sender.view!.center.x) <= 98.5 && abs(132.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 305.5, y: 132.5)
            }
            else if (abs(108.5 - sender.view!.center.x) <= 98.5 && abs(317.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 108.5, y: 317.5)
            }
            else if (abs(305.5 - sender.view!.center.x) <= 98.5 && abs(317.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 305.5, y: 317.5)
            }
            else if (abs(108.5 - sender.view!.center.x) <= 98.5 && abs(502.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 108.5, y: 502.5)
            }
            else if (abs(305.5 - sender.view!.center.x) <= 98.5 && abs(502.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 305.5, y: 502.5)
            }
            else if (abs(108.5 - sender.view!.center.x) <= 98.5 && abs(687.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 108.5, y: 687.5)
            }
            else if (abs(305.5 - sender.view!.center.x) <= 98.5 && abs(687.5 - sender.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                sender.view?.center = CGPoint(x: 305.5, y: 687.5)
            }
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(widgetOne.center)
        widgetOne.layer.cornerRadius = 20
        widgetOne.layer.masksToBounds = true
    }
    
    

}
