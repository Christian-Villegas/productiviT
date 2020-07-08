//
//  ViewController.swift
//  widgets
//
//  Created by Christopher Cordero on 6/22/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

//PlaceHolder Struct
struct PlaceHolder {
    var filled: Bool
    var centerX, centerY: Double
    var frame: CGRect
    
    init(row: Int, column: Int){
        self.filled = false
        if (column % 2) == 0 {
            self.centerX = 108.5
        } else {
            self.centerX = 305.5
        }
        self.centerY = 132.5 + Double(row * 185)
        
        self.frame = CGRect(x: self.centerX, y: self.centerY, width: 177, height: 177)
    }
}

//Double Array of All the PlaceHolders that will be on screen
struct placeHolderArray {
    var grid = [[PlaceHolder]]()
    
    init(){
        for row in (0...7){
            var newPHA = Array<PlaceHolder>()
            for column in (0...1){
                newPHA.append(PlaceHolder(row:row, column:column))
            }
            grid.append(newPHA)
        }
    }
}


//Global variables//
public var editOn = false
var screenWidgets: [Widget] = []
var placeHolders = placeHolderArray()
///


class ViewController: UIViewController {

    
    
    
    var xC = 0
    var yC = 0
    
    let editButton = UIButton(type: .system) // let preferred over var here
    let addWidgetButton = UIButton(type: .system)
    
    
    
    
    @IBOutlet weak var widgetMenu: UITableView!
    
    @IBAction func addWidget(_ sender: UIButton) {
        
        if editOn == false{return}
        
        let xC = placeHolders.grid[0][0].centerX
        let yC = placeHolders.grid[0][0].centerY
        let newWidget = Widget(frame: CGRect(x: xC, y: yC, width: 177, height: 177))
        
        
        placeNextWidget(PHA: &placeHolders.grid, addedWidget: newWidget)
        //self.view.addSubview(newWidget)
        
        self.view.insertSubview(newWidget, belowSubview: widgetMenu)
        
        screenWidgets.append(newWidget)
        
    }
    
    func placeNextWidget(PHA: inout [[PlaceHolder]], addedWidget:Widget){
        for row in (0...7){
            for column in (0...1){
                //print("\(row) and \(column)")
                //var slot = PHA[row][column]
                //print("Checking slot \(PHA[row][column]) which is \(PHA[row][column].filled)")
                if (PHA[row][column].filled == false){
                        addedWidget.center = CGPoint(x: PHA[row][column].centerX, y: PHA[row][column].centerY)
                    addedWidget.ogPosition = CGPoint(x: PHA[row][column].centerX, y: PHA[row][column].centerY)
                        //print(slot.centerX)
                        //print(slot.centerY)
                        PHA[row][column].filled = true
                        //print(PHA[row][column].filled)
                        return
                }
            }
        }
    }
    
    @IBAction func addToDo(_ sender: UIButton) {
        if editOn == false{return}
        
        let toDoWidget = ToDoWidget(frame: CGRect(x: xC, y: yC, width: 177, height: 177))
        self.view.insertSubview(toDoWidget, belowSubview: widgetMenu)
        screenWidgets.append(toDoWidget)
        
        placeNextWidget(PHA: &placeHolders.grid, addedWidget: toDoWidget)
        //self.view.addSubview(newWidget)
        
        self.view.insertSubview(toDoWidget, belowSubview: widgetMenu)
        
        screenWidgets.append(toDoWidget)
        
    }
    
    @objc func editHome(sender: UIButton!) {
        if editOn == false {editOn = true}
        else {editOn = false}
        if editOn == true {
            editButton.setTitle("done", for: .normal)
            addWidgetButton.isHidden = false
            
            if screenWidgets.count > 0{
                for i in 0...(screenWidgets.count-1) {
                    screenWidgets[i].delButton.isHidden = false
                    screenWidgets[i].sizeButton.isHidden = false
                }
            }
        }
        else {
            editButton.setTitle("edit", for: .normal)
            addWidgetButton.isHidden = true
            widgetMenu.isHidden = true
            addWidgetButton.isHidden = true
            addWidgetButton.setTitle("+", for: .normal)
            addWidgetButton.frame = CGRect(x: 20, y: 44, width: 40, height: 25)
            if screenWidgets.count > 0{
                for i in 0...(screenWidgets.count-1) {
                    screenWidgets[i].delButton.isHidden = true
                    screenWidgets[i].sizeButton.isHidden = true
                }
            }
        }
    }
    
    @objc func plusButton(sender: UIButton!) {
        if widgetMenu.isHidden == true {
            widgetMenu.isHidden = false
            addWidgetButton.setTitle("close", for: .normal)
            addWidgetButton.frame = CGRect(x: 263, y: 44, width: 40, height: 25)
        }
        else{
            widgetMenu.isHidden = true
            addWidgetButton.setTitle("+", for: .normal)
            addWidgetButton.frame = CGRect(x: 20, y: 44, width: 40, height: 25)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(widgetOne.center)
        editButton.frame = CGRect(x: 348, y: 44, width: 40, height: 25)
        editButton.setTitle("edit", for: .normal)
        editButton.contentHorizontalAlignment = .right
        editButton.addTarget(self, action: #selector(self.editHome), for: UIControl.Event.touchUpInside)
        self.view.addSubview(editButton)
        widgetMenu.frame = CGRect(x: 0, y: 44, width: 259, height: 769)
        widgetMenu.isHidden = true
        addWidgetButton.setTitle("+", for: .normal)
        addWidgetButton.frame = CGRect(x: 20, y: 44, width: 40, height: 25)
        editButton.contentHorizontalAlignment = .left
        addWidgetButton.addTarget(self, action: #selector(self.plusButton), for: UIControl.Event.touchUpInside)
        addWidgetButton.isHidden = true
        self.view.addSubview(addWidgetButton)
    }
    
    

}


