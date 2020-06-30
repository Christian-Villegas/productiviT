//
//  Widget.swift
//  widgets
//
//  Created by Christopher Cordero on 6/29/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class Widget: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        self.title = ""
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.alpha = 0.5
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panView))
        self.addGestureRecognizer(panGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panView(_ panGesture: UIPanGestureRecognizer) {
            //
        
        print("x")
            let translation = panGesture.translation(in: self)

        if let viewToDrag = panGesture.view {
                viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x,
                    y: viewToDrag.center.y + translation.y)
                panGesture.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                
            }
            //
            
            print("x \(translation.x)")
            print("y \(translation.y)")
            
            
            if (abs(108.5 - panGesture.view!.center.x) <= 98.5 && abs(132.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 108.5, y: 132.5)
            }
            else if (abs(305.5 - panGesture.view!.center.x) <= 98.5 && abs(132.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 305.5, y: 132.5)
            }
            else if (abs(108.5 - panGesture.view!.center.x) <= 98.5 && abs(317.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 108.5, y: 317.5)
            }
            else if (abs(305.5 - panGesture.view!.center.x) <= 98.5 && abs(317.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 305.5, y: 317.5)
            }
            else if (abs(108.5 - panGesture.view!.center.x) <= 98.5 && abs(502.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 108.5, y: 502.5)
            }
            else if (abs(305.5 - panGesture.view!.center.x) <= 98.5 && abs(502.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 305.5, y: 502.5)
            }
            else if (abs(108.5 - panGesture.view!.center.x) <= 98.5 && abs(687.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 108.5, y: 687.5)
            }
            else if (abs(305.5 - panGesture.view!.center.x) <= 98.5 && abs(687.5 - panGesture.view!.center.y) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                panGesture.view?.center = CGPoint(x: 305.5, y: 687.5)
            }
        
        
    }
    
    
    //Data Members://
    var title: String
    
    
    //Height var (From UIView Class)
    //Width var (From UIView Class)
    //Center Position (CGPOINT) variable (From UIView Class)
    //color property (From UIView Class)
    

}
