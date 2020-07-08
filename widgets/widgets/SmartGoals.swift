//
//  SmartGoal.swift
//  widgets
//
//  Created by Christopher Cordero on 7/1/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit



class SmartGoal: Widget, UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.title = "SMART Goals"
        
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 21))
        //label.center = CGPoint(x: 15, y: 15)
        label.textAlignment = .left
        label.text = "SMART Goals"
        self.addSubview(label)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
