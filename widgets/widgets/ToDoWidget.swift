//
//  ToDoWidget.swift
//  widgets
//
//  Created by Christopher Cordero on 7/8/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class ToDoWidget: Widget, UITableViewDelegate, UITableViewDataSource  {

    //custom constructor
   override init(frame: CGRect) {
        taskList = UITableView(frame: CGRect(x: 0, y: 0, width: 414, height: 800), style: .plain)
        miniTable = UITableView(frame: CGRect(x: 0, y: 0, width: 177, height: 140), style: .plain)
        
        super.init(frame: frame)
       
       
        self.title = "To Do Widget"
    
        self.number = 1//number assigned to ToDo widgets, for checking which widget to display when full view is requested
        self.label.text = "To Do List"//widget will display this when first added
        //Initializations for taskList tableView button
        taskList.backgroundColor = .white
        taskList.separatorStyle = UITableViewCell.SeparatorStyle.none
        taskList.delegate = self
        taskList.dataSource = self
        taskList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        //initializations for mini table
        miniTable.backgroundColor = .white
        miniTable.alpha = 0.7
        miniTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        miniTable.delegate = self
        miniTable.dataSource = self
        miniTable.estimatedRowHeight = 100
        //miniTable.rowHeight = UITableView.automaticDimension
        miniTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        //constraining Label
        self.label.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
    
    
        
       
        //adding to UIView displayed on the slide up full view mode
        fullView.addSubview(taskList)
        fullView.addSubview(fullViewAddTask)
    
       
        //add components to subview
        self.addSubview(label)
        self.insertSubview(miniTable, belowSubview: self.shield)
        //self.addSubview(remove)
        //self.addSubview(addTask)
        

   }
    
    init(size: Int, PHAccessed:Array<PlaceHolder>, items: [String]) {
        
        self.placeHoldersAccessed = PHAccessed
        
        
        
        taskList = UITableView(frame: CGRect(x: 0, y: 0, width: 414, height: 800), style: .plain)
        miniTable = UITableView(frame: CGRect(x: 0, y: 0, width: 177, height: 140), style: .plain)
        var height = 0
        var width = 0
        switch size {
        case 1:
            height = 177
            width = 177
        case 2:
            height = 177
            width = 374
        default:
            height = 362
            width = 374
        }
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        self.title = "To Do Widget"
        self.itemArray = items
        
        self.number = 1//number assigned to ToDo widgets, for checking which widget to display when full view is requested
        self.label.text = "To Do List"//widget will display this when first added
            //Initializations for taskList tableView button
        taskList.backgroundColor = .white
            taskList.separatorStyle = UITableViewCell.SeparatorStyle.none
        taskList.delegate = self
        taskList.dataSource = self
        taskList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        //initializations for mini table
        miniTable.backgroundColor = .white
        miniTable.alpha = 0.7
        miniTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        miniTable.delegate = self
        miniTable.dataSource = self
        miniTable.estimatedRowHeight = 100
        //miniTable.rowHeight = UITableView.automaticDimension
        miniTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        //constraining Label
        self.label.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
    
    
        
       
        //adding to UIView displayed on the slide up full view mode
        fullView.addSubview(taskList)
        fullView.addSubview(fullViewAddTask)
    
       
        //add components to subview
        self.addSubview(label)
        self.insertSubview(miniTable, belowSubview:
            self.shield)
        //self.addSubview(remove)
        //self.addSubview(addTask)
        
        self.size = size
                
        //fill in the placeholders
        for placeHolder in PHAccessed{
            placeHolders.grid[self.getPlaceHolder(number: placeHolder.number).row][self.getPlaceHolder(number: placeHolder.number).column].filled = true
            placeHolders.grid[self.getPlaceHolder(number: placeHolder.number).row][self.getPlaceHolder(number: placeHolder.number).column].widget = self
        }
        
        
        screenWidgets.append(self)
        self.frame = CGRect(x: self.ogPosition.x, y: self.ogPosition.y, width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//METHODS//
    
    
//custom Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .none
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size:30)
        cell.textLabel?.textColor = .black
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.2
        //cell.textLabel?.adjustsFontForContentSizeCategory = true
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            miniTable.cellForRow(at: indexPath)?.accessoryType = .none
            taskList.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            miniTable.cellForRow(at: indexPath)?.accessoryType = .checkmark
            taskList.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (self.itemArray.count - 1) > 0
            {
                self.itemArray.remove(at: indexPath.row)
                //self.label.text  = self.itemArray[self.itemArray.count - 1]
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            }
            else{
                //self.label.text  = "Add Task"
                if itemArray.count > 0 {self.itemArray.remove(at:indexPath.row)}
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")

            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.taskList.reloadData()
            self.miniTable.reloadData()
            
        }
        //else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        //}
    }
    
//
    //Method for updating view to size
     override func updateView() {
           switch self.size {
           case 1:
               miniTable.frame = CGRect(x: 0, y: 0, width: 177, height: 140)
               shield.frame = CGRect(x: 0, y: 0, width: 177, height: 177)
           case 2:
               miniTable.frame = CGRect(x: 0, y: 0, width: 374, height: 140)
               shield.frame = CGRect(x: 0, y: 0, width: 374, height: 177)
           case 3:
               miniTable.frame = CGRect(x: 0, y: 0, width: 374, height: 325)
               shield.frame = CGRect(x: 0, y: 0, width: 374, height: 362)
           default:
               miniTable.frame = CGRect(x: 0, y: 0, width: 177, height: 140)
               
               shield.frame = CGRect(x: 0, y: 0, width: 177, height: 177)
           }
       }
    
    //Method for adding a task
    @objc override func addButton(_ sender: UIButton!) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default)
        {
            (action)in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            //self.label.text  = self.itemArray[self.itemArray.count - 1]
            self.taskList.reloadData()
            self.miniTable.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    //method for removign a task
    @objc func removeTask(_ sender: UIButton!)
    {
        if (self.itemArray.count - 1) > 0
        {
            self.itemArray.remove(at: itemArray.count - 1)
            //self.label.text  = self.itemArray[self.itemArray.count - 1]
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
        }
        else{
            //self.label.text  = "Add Task"
            if itemArray.count > 0 {self.itemArray.remove(at: itemArray.count - 1)}
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")

        }
        self.taskList.reloadData()
        self.miniTable.reloadData()
    }
    
//Data Members
    var itemArray: [String] = [] //array for user's tasks
    //var label = UILabel(frame: CGRect(x: 20, y: 141, width: 200, height: 21)) //label to display title on widget
    let defaults = UserDefaults.standard //to store user data locally
    //let addTask = UIButton(type: .system) //button to add to todo list
    //let remove = UIButton(type: .system) //removes a task from list
    //let fullViewAddTask = UIButton(type: .system) //button on full view that adds a task
    var taskList: UITableView //shows table view on the full view
    var miniTable: UITableView //table view for widget mode
    
}
