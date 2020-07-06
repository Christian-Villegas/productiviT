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
        self.ogPosition = CGPoint(x: 0, y: 0)
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.alpha = 0.5
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panView))
        self.addGestureRecognizer(panGesture)
        
        sizeButton.setTitle("change size", for: .normal)
        sizeButton.addTarget(self, action: #selector(changeSize), for: .touchUpInside)
        self.addSubview(sizeButton)
        
        
        delButton.setTitle("x", for: .normal)
        delButton.addTarget(self, action: #selector(deleteWidget), for: .touchUpInside)
        self.addSubview(delButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteWidget(sender: UIButton) {
        if editOn == false {return}//returns if not in edit mode
        
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting this widget will also delete all of its data.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            
            let wCenter = self.center
            
            outerLoop: for row in (0...7){
                for column in (0...1){
                    let phCenter = CGPoint(x: placeHolders.grid[row][column].centerX, y: placeHolders.grid[row][column].centerY)
                    
                    if wCenter == phCenter{
                        placeHolders.grid[row][column].filled = false //update filled property
                        break outerLoop
                    }
                }
            }
            
            for i in (0...(screenWidgets.count-1)){
                if screenWidgets[i] == self{ screenWidgets.remove(at: i) //remove from widget array
                    break
                }
            }
            
            self.removeFromSuperview()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    
    }
    
    
    func updateFilled(){//should go in view controller
        outerLoop: for row in (0...7){
            for column in (0...1){
                for i in (0...(screenWidgets.count-1)){
                    let phCenter = CGPoint(x: placeHolders.grid[row][column].centerX, y: placeHolders.grid[row][column].centerY)
                    
                    if screenWidgets[i].center == phCenter{
                        placeHolders.grid[row][column].filled = true
                        break
                    }
                    placeHolders.grid[row][column].filled = false
                }
            }
        }
    }
    
    @objc func changeSize(sender: UIButton) {
        if editOn == false {return}//returns if not in edit mode
        
        if(self.frame.width == 177.0) {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: 374.0, height: 177.0)
        } else if(self.frame.width == 374.0 && self.frame.height == 177.0) {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: 374.0, height: 362.0)
        } else {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: 177.0, height: 177.0)
        }
        
    }
    
    @objc func panView(_ panGesture: UIPanGestureRecognizer) {
        //fix this, turn into a switch statement and consider placeholders
        //replace numbers with placeholder variables (x and y) !!!!!!!!!!!!!!!!!
        
            //
        
        if editOn == false {return}//returns if not in edit mode
        
            let translation = panGesture.translation(in: self)

        if let viewToDrag = panGesture.view {
                viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x,
                    y: viewToDrag.center.y + translation.y)
                panGesture.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                
            }
            //
            
            
        if (abs(placeHolders.grid[0][0].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[0][0].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if placeHolders.grid[0][0].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[0][0].centerX, y: placeHolders.grid[0][0].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
        }
        else if (abs(placeHolders.grid[0][1].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[0][1].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
            
                if placeHolders.grid[0][1].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[0][1].centerX, y: placeHolders.grid[0][1].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
            }
        else if (abs(placeHolders.grid[1][0].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[1][0].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if placeHolders.grid[1][0].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[1][0].centerX, y: placeHolders.grid[1][0].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
            }
        else if (abs(placeHolders.grid[1][1].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[1][1].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if placeHolders.grid[1][1].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[1][1].centerX, y: placeHolders.grid[1][1].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
            }
        else if (abs(placeHolders.grid[2][0].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[2][0].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if placeHolders.grid[2][0].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[2][0].centerX, y: placeHolders.grid[2][0].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
            }
        else if (abs(placeHolders.grid[2][1].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[2][1].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if placeHolders.grid[2][1].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[2][1].centerX, y: placeHolders.grid[2][1].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
            }
        else if (abs(placeHolders.grid[3][0].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[3][0].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                if placeHolders.grid[3][0].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[3][0].centerX, y: placeHolders.grid[3][0].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
            }
        else if (abs(placeHolders.grid[3][1].centerX - Double(panGesture.view!.center.x)) <= 98.5 && abs(placeHolders.grid[3][1].centerY - Double(panGesture.view!.center.y)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if placeHolders.grid[3][1].filled == true{
                    panGesture.view?.center = self.ogPosition
                }
                else{
                    panGesture.view?.center = CGPoint(x: placeHolders.grid[3][1].centerX, y: placeHolders.grid[3][1].centerY)
                    self.ogPosition = self.center
                    self.updateFilled()
                }
            }
        
        
    }
    
    
    //Data Members://
    var title: String
    let delButton = UIButton(frame: CGRect(x: 135, y: 4, width: 40.0, height: 40.0))
    let sizeButton = UIButton(frame: CGRect(x: 20.0, y: 20.0, width: 100.0, height: 40.0))
    var ogPosition: CGPoint
    
    
    //Height var (From UIView Class)
    //Width var (From UIView Class)
    //Center Position (CGPOINT) variable (From UIView Class)
    //color property (From UIView Class)
    

}
