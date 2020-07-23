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



struct Player : Codable {
    
    var name: String
    var highScore: Int
}


class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var centerX = 0
    var centerY = 0
    
    let defaults = UserDefaults.standard
    
    let editButton = UIButton(type: .system) // let preferred over var here
    
    let plusWidget = UIButton(frame: CGRect(x: 165.0 , y: 700.0, width: 90.0, height: 90.0))
    let image = UIImage(named: "SquareAdd50")

    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var parentButton: UIButton!
    @IBOutlet weak var toDoButton: UIButton!
    @IBOutlet weak var apptButton: UIButton!
    @IBOutlet weak var plusWidgetButton: UIButton!
    
    
    func saveUserDefaults(_ sender: Any) {
        let player = Player(name: "Axel", highScore: 42)
        let defaults = UserDefaults.standard
        
        // Use PropertyListEncoder to convert Player into Data / NSData
        defaults.set(try? PropertyListEncoder().encode(player), forKey: "player")
    }
    
    func loadUserDefaults(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let playerData = defaults.object(forKey: "player") as? Data else {
            return
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let player = try? PropertyListDecoder().decode(Player.self, from: playerData) else {
            return
        }
            
        print("player name is \(player.name)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopOver"{
            let popMenu = segue.destination
            popMenu.popoverPresentationController?.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        print("this thing worked")
        return UIModalPresentationStyle.none
    }
    
    @IBAction func addWidget(_ sender: UIButton) {
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
            self.view.addSubview(newWidget)
            screenWidgets.append(newWidget)
            emptyMessage.isHidden = true
        }
        //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
    }
    
    @IBAction func addToDo(_ sender: UIButton) {
        if editOn == false{return}
         if self.hasNextSpot() {
            let toDoWidget = ToDoWidget(frame: CGRect(x: 0.0, y: 0.0, width: 177, height: 177))
            self.view.addSubview(toDoWidget)
            screenWidgets.append(toDoWidget)
            taskW = toDoWidget
            placeNextWidget(PHA: &placeHolders.grid, addedWidget: toDoWidget)
            emptyMessage.isHidden = true
            
        }
        //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
    }
    
    @IBAction func addAppt(_ sender: UIButton) {
        if editOn == false{return}
         if self.hasNextSpot() {
            let apptWidget = AppointmentsWidget(frame: CGRect(x: 0.0, y: 0.0, width: 177, height: 177))
            self.view.addSubview(apptWidget)
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
            parentButton.isHidden = false
            toDoButton.isHidden = false
            apptButton.isHidden = false
            plusWidget.isHidden = false
            if screenWidgets.count > 0{
                for i in 0...(screenWidgets.count-1) {
                    screenWidgets[i].delButton.isHidden = false
                    screenWidgets[i].sizeButton.isHidden = false
                    screenWidgets[i].shield.isHidden = false
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
            parentButton.isHidden = true
            toDoButton.isHidden = true
            apptButton.isHidden = true
            plusWidget.isHidden = true
            if screenWidgets.count > 0{
                for i in 0...(screenWidgets.count-1) {
                    screenWidgets[i].delButton.isHidden = true
                    screenWidgets[i].sizeButton.isHidden = true
                    screenWidgets[i].shield.isHidden = true
                    
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
            
            //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
            
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(widgetOne.center)
        editButton.frame = CGRect(x: 348, y: 44, width: 40, height: 25)
        editButton.setTitle("edit", for: .normal)
        editButton.contentHorizontalAlignment = .right
        editButton.addTarget(self, action: #selector(self.editHome), for: UIControl.Event.touchUpInside)
        self.view.addSubview(editButton)
        editButton.contentHorizontalAlignment = .left
        parentButton.isHidden = true
        toDoButton.isHidden = true
        apptButton.isHidden = true
        plusWidget.setImage(image?.withTintColor(.black), for: .normal)
        plusWidget.addTarget(self, action: #selector(self.addToDo(_:)), for: UIControl.Event.touchUpInside)
        plusWidget.contentHorizontalAlignment = .center
        plusWidget.isHidden = true
        self.view.addSubview(plusWidget)
        
        
        // let layout = NSKeyedArchiver.archivedData(withRootObject: placeHolders.grid)
        //self.defaults.set(layout, forKey: "layoutState")
        
        //self.defaults.set(NSKeyedArchiver.archivedData (withRootObject: screenWidgets), forKey: "widgetArray")
        
    }
    
    

}
