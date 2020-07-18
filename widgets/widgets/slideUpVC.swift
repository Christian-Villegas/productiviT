//
//  slideUpVC.swift
//  widgets
//
//  Created by Christopher Cordero on 7/12/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//
import UIKit

var currentWidget = 0

class slideUpVC: UIViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
   
    
    
    @IBOutlet weak var topTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch currentWidget {
        case 1:
            topTitle.text = "Tasks"
            view.addSubview(taskW.fullView)
            
        default:
            topTitle.text = "None"
        }
    
    
    }
    

}
