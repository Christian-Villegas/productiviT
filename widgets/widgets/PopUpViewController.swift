//
//  PopUpViewController.swift
//  widgets
//
//  Created by Christian Villegas on 7/23/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit


class PopUpViewController: UIViewController {
//
//
//
//    //global variable
//    var ButtonArray = [UIButton]()
//    let numberOfTypes = 2
//
//
//
//
//
//    func addButtons(){
//
//
//        var widgetsOnScreen = [Int]()
//        for row in (0...3){
//            for column in (0...1){
//                if((placeHolders.grid[row][column].widget) != nil){
//                    widgetsOnScreen.append(placeHolders.grid[row][column].widget!.number)
//                }
//            }
//        }
//        var x = 5
//        var y = 20
//        for i in (0...numberOfTypes){
//            if(!widgetsOnScreen.contains(i)){
//                print("This function is being used")
//                if i == 1{
//                    print("new button for todo at \(x) \(y)")
//                    let button = UIButton()
//                    button.frame = CGRect(x: x, y: y, width: 200, height: 20)
//                    button.addTarget(self, action: #selector(mainController.addToDo), for: UIControl.Event.touchUpInside)
//                    button.backgroundColor = .black
//                    button.setTitle("ADD TODO", for: .normal)
//                    y += 50
//                    self.view.addSubview(button)
//                }else if i == 2{
//                    print("new button for appointment at \(x) \(y)")
//                    let button = UIButton()
//                    button.frame = CGRect(x: x, y: y, width: 200, height: 20)
//                    button.addTarget(self, action:  #selector(mainController.addAppt(_:)), for: UIControl.Event.touchUpInside)
//                    button.backgroundColor = .black
//                    button.setTitle("ADD APPOINTMENT", for: .normal)
//                    self.view.addSubview(button)
//                    y += 50
//                }else if i == 0{
//                    print("new button for parent widget at \(x) \(y)")
//                    let button = UIButton()
//                    button.frame = CGRect(x: x, y: y, width: 200, height: 20)
//                    button.addTarget(self, action:  #selector(mainController.addWidget(_:)), for: UIControl.Event.touchUpInside)
//                    button.backgroundColor = .black
//                    button.setTitle("ADD WIDGET", for: .normal)
//                    self.view.addSubview(button)
//                    y += 50
//                }
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        addButtons()
    }
    
}
