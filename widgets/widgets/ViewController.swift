//
//  ViewController.swift
//  widgets
//
//  Created by Christopher Cordero on 6/22/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit


//PlaceHolder Struct
struct PlaceHolder{
    var filled: Bool
    var posX, posY: Double
    var xC, yC: Double
    var frame: CGRect
    var widget: Widget?
    var number: Int
    
    init(row: Int, column: Int) {
        self.filled = false
        self.widget = nil
        self.number = 0
        
        if((column % 2) == 0) {
            self.posX = 20
            self.xC = 108.5
        } else {
            self.posX = 217
            self.xC = 305.5
        }

        self.posY = 44 + Double(row * 185)
        self.yC = 132.5 + Double(row * 185)
        self.frame = CGRect(x: self.posX, y: self.posY, width: 177, height: 177)
    }

    
    mutating func setNumber(number: Int){
        self.number = number
    }
    
    mutating func setEmpty(){
        self.filled = false
    }
    
    mutating func setFilled(){
        self.filled = true
    }
}

//Double Array of All the PlaceHolders that will be on screen
struct placeHolderArray {
    
    // creates an array that can hold more arrays
    var grid = [[PlaceHolder]]()
    
    init(){
        var number = 0
        for row in (0...3){
            // creates an array that will hold the placeholder and their positions
            var newPHA = Array<PlaceHolder>()
            for column in (0...1){
                number += 1
                var newPlaceHolder = PlaceHolder(row: row, column: column)
                newPlaceHolder.setNumber(number: number)
                newPHA.append(newPlaceHolder)
            }
            // adds the new arrays for each column
            grid.append(newPHA)
        }
    }
    
    // make this along with change size. aka make sure that if a widget size 1 is on the right column, it cant change size
    mutating func updateFilled() {
        for row in (0...3){
        //iterate through columns
            for column in (0...1){
                // left column
                if(column == 0) {
                    // if its a size 1 check that box
                    if(self.grid[row][column].widget != nil && self.grid[row][column].widget?.size == 1) {
                        self.grid[row][column].filled = true
                    // if its a size 2 check that box and the one to the right
                    } else if(self.grid[row][column].widget != nil && self.grid[row][column].widget?.size == 2) {
                        self.grid[row][column].filled = true
                        self.grid[row][column+1].filled = true
                    }
                    
                    if(row <= 2) {
                        if(self.grid[row][column].widget != nil && self.grid[row][column].widget?.size == 3) {
                            self.grid[row][column].filled = true
                            self.grid[row][column+1].filled = true
                            self.grid[row+1][column].filled = true
                            self.grid[row+1][column+1].filled = true
                        }
                    }
                // right column
                } else {
                    // the only option if its the right column is if its size 1
                    if(self.grid[row][column].widget != nil && self.grid[row][column].widget?.size == 1) {
                        self.grid[row][column].filled = true
                    }
                }
            }
        }
        gridPrint()
    }
    
    func gridPrint(){
        var statement = ""
        for row in (0...3){
            var addition = ""
            for column in (0...1){
                if self.grid[row][column].filled == true{
                    addition.append("X")
                }else if self.grid[row][column].filled == false{
                    addition.append("0")
                }
            }
            addition.append("\n")
            statement.append(addition)
        }
        print(statement)
    }

}

//Global variables//
public var editOn = false
// holds all widgets
var screenWidgets: [Widget] = []
var placeHolders = placeHolderArray()
var taskW = ToDoWidget()
var apptW = AppointmentsWidget()
var widgetList = ["To Do Widget", "Appointments Widget", "Parent Widget"]
var colors = [Color(red_: 0.789, green_: 0.789, blue_: 0.789, font_: .black),
              Color(red_: 0.475, green_: 0.482, blue_: 1, font_: .white),
              Color(red_: 1, green_: 0.578, blue_: 0.575, font_: .white),
              Color(red_: 0.328, green_: 0.914, blue_: 0.437, font_: .white),
              Color(red_: 0.219, green_: 0.598, blue_: 1, font_: .white),
              Color(red_: 1, green_: 0.767, blue_: 0.281, font_: .white),
              Color(red_: 0.933, green_: 0.861, blue_: 0.126, font_: .white),
              Color(red_: 1, green_: 0.312, blue_: 0.326, font_: .white)]

//Grey, purple, salmon, green, blue, orange, yellow, red


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var centerX = 0
    var centerY = 0

    let editButton = UIButton(type: .system) // let preferred over var here
    
    //let dismissMenu = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
    
    let plusWidget = UIButton(type: .system)
    
    
    let menu = UIView()
    let menuTable = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), style: .plain)

    @IBOutlet weak var emptyMessage: UILabel!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgetList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .none
        cell.textLabel?.text = widgetList[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size:15)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .systemBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buttonName = widgetList[indexPath.row]
        switch buttonName {
        case "To Do Widget":
            self.addToDo()
            widgetList.remove(at: indexPath.row)
        case "Appointments Widget":
            self.addAppt()
            widgetList.remove(at: indexPath.row)
        default:
            self.addWidget()
            widgetList.remove(at: indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        menu.fadeOut()
        let seconds = 0.16
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.menu.isHidden = true
        }
        
    }
    
    @objc func addWidget() {
        // the edit button
        if editOn == false {return}
        
        // if there is any space at all
        if self.hasNextSpot() {
            let posX = placeHolders.grid[0][0].posX
            let posY = placeHolders.grid[0][0].posY
            let newWidget = Widget(frame: CGRect(x: posX, y: posY, width: 177, height: 177))
            
            // will find the next empty space and change the center of the new widget to that one
           placeNextWidget(PHA: &placeHolders.grid, addedWidget: newWidget)
            placeHolders.gridPrint()
            self.view.insertSubview(newWidget, belowSubview: editButton)
            screenWidgets.append(newWidget)
            emptyMessage.isHidden = true
        }
        //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
    }
    
    @objc func addToDo() {
        if editOn == false{return}
         if self.hasNextSpot() {
            let toDoWidget = ToDoWidget(frame: CGRect(x: 0.0, y: 0.0, width: 177, height: 177))
            self.view.insertSubview(toDoWidget, belowSubview: editButton)
            screenWidgets.append(toDoWidget)
            taskW = toDoWidget
            placeNextWidget(PHA: &placeHolders.grid, addedWidget: toDoWidget)
            emptyMessage.isHidden = true
            
        }
        //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
    }
    
    @objc func addAppt() {
        if editOn == false{return}
         if self.hasNextSpot() {
            let apptWidget = AppointmentsWidget(frame: CGRect(x: 0.0, y: 0.0, width: 177, height: 177))
            self.view.insertSubview(apptWidget, belowSubview: editButton)
            screenWidgets.append(apptWidget)
            apptW = apptWidget
            placeNextWidget(PHA: &placeHolders.grid, addedWidget: apptWidget)
            emptyMessage.isHidden = true
            
        }
        //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
    }
    
    func placeNextWidget(PHA: inout [[PlaceHolder]], addedWidget: Widget){
        for row in (0...3){
            for column in (0...1){
                if(PHA[row][column].filled == false) {
                    addedWidget.center = CGPoint(x: PHA[row][column].xC, y: PHA[row][column].yC)
                    addedWidget.ogPosition = CGPoint(x: PHA[row][column].posX, y: PHA[row][column].posY)
                    PHA[row][column].filled = true
                    addedWidget.ogCenter = addedWidget.center
                    // puts the widget to the array of placeHolders it takes
                    addedWidget.placeHoldersAccessed.append(PHA[row][column])
                    PHA[row][column].widget = addedWidget
                    return
                }
            }
        }
    }
    
    
    
    @objc func editHome(sender: UIButton!) {
        if editOn == false {editOn = true}
        else {editOn = false}
        if editOn == true {
            editButton.setTitle("done", for: .normal)
           plusWidget.isHidden = false
            if screenWidgets.count > 0{
                for i in 0...(screenWidgets.count-1) {
                    screenWidgets[i].delButton.isHidden = false
                    screenWidgets[i].sizeButton.isHidden = false
                    screenWidgets[i].shield.isHidden = false
                    screenWidgets[i].editColor.isHidden = false
                    if screenWidgets[i].number == 1 {
                        let tdW = screenWidgets[i] as! ToDoWidget
                        tdW.addTask.isHidden = true
                    }
                    if screenWidgets[i].number == 2 {
                        let apW = screenWidgets[i] as! AppointmentsWidget
                        apW.addTask.isHidden = true
                    }
                }
            }
        }
        else {
            editButton.setTitle("edit", for: .normal)
            menuTable.reloadData()
            plusWidget.isHidden = true
            menu.isHidden = true
            if screenWidgets.count > 0{
                for i in 0...(screenWidgets.count-1) {
                    screenWidgets[i].delButton.isHidden = true
                    screenWidgets[i].sizeButton.isHidden = true
                    screenWidgets[i].shield.isHidden = true
                    screenWidgets[i].editColor.isHidden = true
                    
                    if screenWidgets[i].number == 1 {
                        let tdW = screenWidgets[i] as! ToDoWidget
                        tdW.addTask.isHidden = false
                    }
                    if screenWidgets[i].number == 2 {
                        let apW = screenWidgets[i] as! AppointmentsWidget
                        apW.addTask.isHidden = false
                    }
                }
                
            }
            else{
                emptyMessage.isHidden = false
            }
        }
    }
    
    
    func hasNextSpot() -> Bool{
        for row in (0...3){
            for column in (0...1){
                if(placeHolders.grid[row][column].filled == false){
                    return true
                }
            }
        }
        print("nope! No more space")
        return false
    }
    
    @objc func showWidgetMenu() {
         menuTable.reloadData()
        if menu.isHidden == true {
            menu.isHidden = false
            menu.alpha = 0.0
            menu.fadeIn()
            }
        else{
            menu.fadeOut()
            let seconds = 0.16
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.menu.isHidden = true
            }
        }
        
        
    }
    
    @objc func closeMenu(){
        print("menu is no longer hidden")
        self.menu.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(widgetOne.center)
        editButton.frame = CGRect(x: 9, y: 779, width: 40, height: 25)
        editButton.setTitle("edit", for: .normal)
        editButton.contentHorizontalAlignment = .right
        editButton.addTarget(self, action: #selector(self.editHome), for: UIControl.Event.touchUpInside)
        self.view.addSubview(editButton)
        editButton.contentHorizontalAlignment = .left
       
        
        
        
        menu.isHidden = true
        menu.frame = CGRect(x:105, y: 525, width: 200, height: 200)
        menu.layer.cornerRadius = 15.0
        menu.dropShadow()
        
       
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menuTable.separatorStyle = .singleLine
        
        menuTable.layer.cornerRadius = 15.0
        
        plusWidget.frame = CGRect(x: 182, y: 724, width: 50, height: 50)
        plusWidget.setImage(#imageLiteral(resourceName: "SquareAdd100-1"), for: .normal)
        plusWidget.tintColor = .systemBlue
        plusWidget.addTarget(self, action: #selector(showWidgetMenu), for: .touchUpInside)
        plusWidget.isHidden = true
        
        self.view.addSubview(editButton)
        self.view.addSubview(menu)
        self.view.insertSubview(plusWidget, aboveSubview: editButton)
        menu.addSubview(menuTable)
        
       // dismissMenu.numberOfTapsRequired = 1
        //self.view.addGestureRecognizer(self.dismissMenu)
        
        // let layout = NSKeyedArchiver.archivedData(withRootObject: placeHolders.grid)
        //self.defaults.set(layout, forKey: "layoutState")
        
        //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
        
    }
    
    

}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1.5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.10, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
}
