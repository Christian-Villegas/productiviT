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
    
    func gridNumbers() -> [Int]{
        var statement = [Int]()
        for row in (0...3){
            var addition = [Int]()
            for column in (0...1){
                if self.grid[row][column].filled == true{
                    addition.append(self.grid[row][column].number)
                }else if self.grid[row][column].filled == false{
                    addition.append(9)
                }
            }
            statement = addition
        }
        return statement
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
    
    
    let screen = UIView()
    let menu = widgetsMenuPopOverView()
    let menuTable = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), style: .plain)

    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var plusWidgetButton: UIButton!
    
    
    
    
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
        menu.isHidden = true
    }
    
    @objc func addWidget() {
        // the edit button
        if editOn == false {return}
        
        // if there is any space at all
        if self.hasNextSpot() {
            let posX = placeHolders.grid[0][0].posX
            let posY = placeHolders.grid[0][0].posY
            let newWidget = Widget(frame: CGRect(x: posX, y: posY, width: 177, height: 177))
            
           placeNextWidget(PHA: &placeHolders.grid, addedWidget: newWidget)
            placeHolders.gridPrint()
            self.view.insertSubview(newWidget, belowSubview: editButton)
            screenWidgets.append(newWidget)
            emptyMessage.isHidden = true
            self.screen.isHidden = true

        }
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
            self.screen.isHidden = true

        }
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
            self.screen.isHidden = true
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
           plusWidgetButton.isHidden = false
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
            plusWidgetButton.isHidden = true
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
    
    @objc func handleDismiss() {
          // Dismisses the calendar with fade animation
     if(!self.menu.isHidden && !self.menuTable.isHidden){
            UIView.animate(withDuration: 0.3, animations: {
          }) { ( finished ) in
            self.menu.isHidden = true
            self.menuTable.isHidden = true
            self.screen.isHidden = true
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
    
    @IBAction func showWidgetMenu() {
        print("showing widget Menu")
        self.screen.isHidden = false
        self.menuTable.reloadData()
        self.menu.isHidden = false
        self.menuTable.isHidden = false
        print("menu is \(self.menu.isHidden)")
        print("menuTable is \(self.menuTable.isHidden)")
        print("screen is \(self.screen.isHidden)")
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
//    if let petId = petId {
//      coder.encodeInteger(petId, forKey: "petId")
        let placeHolderArray = placeHolders.gridNumbers()
        coder.encode(placeHolderArray, forKey: "PHA")
        for widget in screenWidgets{
            if widget.number == 1{
                let todo = widget as! ToDoWidget
                let todoSize = todo.size
                let todoPlaceHolders = widget.placeHoldersAccessed
                coder.encode(todo.itemArray, forKey: "todos")
                coder.encode(todoSize, forKey: "todoSize")
                coder.encode(todoPlaceHolders, forKey: "todoPHAs")
            }else if widget.number == 2{
//                let appt = widget as! AppointmentsWidget
//                let apptSize = appt.size
//                let apptPlaceHolders = widget.placeHoldersAccessed
//                coder.encode(appt.itemArray)
//                coder.encode(apptSize, forKey: "apptSize")
//                coder.encode(apptPlaceHolders)
                
            }
        }
    }
    
    //WRITE DIFFERENT CONSTRUCTORS FOR EACH WIDGET INCLUDING THEIR PLACEHOLDER POSITIONS
    override func decodeRestorableState(with coder: NSCoder) {
//      petId = coder.decodeIntegerForKey("petId")
//
//      super.decodeRestorableStateWithCoder(coder)
//      todoSize = coder.decodeData()
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        //print(widgetOne.center)
        
        self.restorationIdentifier = "RestoreHomeScreen"
        
        editButton.frame = CGRect(x: 348, y: 44, width: 40, height: 25)
        editButton.setTitle("edit", for: .normal)
        editButton.contentHorizontalAlignment = .right
        editButton.addTarget(self, action: #selector(self.editHome), for: UIControl.Event.touchUpInside)
        editButton.contentHorizontalAlignment = .left
        
        plusWidgetButton.isHidden = true
        menu.isHidden = true
        menu.frame = CGRect(x:110, y: 520, width: 200, height: 200)
        menu.layer.borderWidth = 0.75
        menu.layer.borderColor = UIColor.black.cgColor
        menu.layer.cornerRadius = 15.0
                  
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menuTable.separatorStyle = .singleLine
        menuTable.layer.cornerRadius = 15.0
        
        screen.frame = CGRect(x: 105, y: 300, width: .max, height: .max)
        screen.backgroundColor = .none
        screen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleDismiss)))
        screen.isHidden = true
        
        self.view.addSubview(editButton)
        self.view.addSubview(menu)
        self.view.insertSubview(screen, belowSubview: menu)
        menu.addSubview(menuTable)
        let lmao = ToDoWidget(size: 2, PHAccessed: [placeHolders.grid[1][0], placeHolders.grid[1][1]], items: ["Eat more food", "Get Some Protein"])
        print(lmao.ogCenter)
        print(lmao.ogPosition)
        self.view.insertSubview(lmao, belowSubview: editButton)
    }
    
    

}

//extension UIView {
//    func dropShadow(scale: Bool = true) {
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.2
//        layer.shadowOffset = .zero
//        layer.shadowRadius = 1.5
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//    func fadeIn() {
//        // Move our fade out code from earlier
//        UIView.animate(withDuration: 0.10, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
//            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
//        }, completion: nil)
//    }
//
//    func fadeOut() {
//        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//            self.alpha = 0.0
//        }, completion: nil)
//    }
//
//}
