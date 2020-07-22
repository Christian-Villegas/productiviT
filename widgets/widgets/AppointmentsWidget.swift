//
//  AppointmentsWidget.swift
//  widgets
//
//  Created by Christopher Cordero on 7/20/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class AppointmentsWidget: Widget {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //array with sorting algorithm
    
    struct appointment {
        var title = UILabel()
        var date = Date()
        var timeLabel: String = ""
    }
    
    
    
    
    //custom constructor
    override init(frame: CGRect) {
         //taskList = UITableView(frame: CGRect(x: 0, y: 0, width: 414, height: 800), style: .plain)
         //miniTable = UITableView(frame: CGRect(x: 0, y: 10, width: 172, height: 130), style: .plain)
         
         super.init(frame: frame)
            datePicker.frame = CGRect(x: 10, y: 50, width: self.frame.width, height: 200)
            datePicker.timeZone = NSTimeZone.local
            datePicker.backgroundColor = UIColor.white
            datePicker.minimumDate = Date()
        
         self.number = 2//number assigned to ToDo widgets, for checking which widget to display when full view is requested
         self.label.text = "Appointments"//widget will display this when first added
        
         //Initializations for addTask button
         addTask.frame = CGRect(x: 135, y: 135, width: 35, height: 35)
        addTask.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
         addTask.layer.cornerRadius = 0.5 * addTask.bounds.size.width
         addTask.clipsToBounds = true
         addTask.backgroundColor = .systemBlue
         addTask.setTitleColor(.white, for: .normal)
         addTask.setTitle("+", for: .normal)
         addTask.contentHorizontalAlignment = .center
         addTask.addTarget(self, action: #selector(self.addButton), for: UIControl.Event.touchUpInside)
         addTask.isHidden = true
        
         //Initializations for addTask button on full view
         /*fullViewAddTask.frame = CGRect(x: 172, y: 670, width: 70, height: 70)
         fullViewAddTask.layer.cornerRadius = 0.5 * fullViewAddTask.bounds.size.width
         fullViewAddTask.clipsToBounds = true
         fullViewAddTask.backgroundColor = .blue
         fullViewAddTask.setTitleColor(.white, for: .normal)
         fullViewAddTask.setTitle("+", for: .normal)
         fullViewAddTask.addTarget(self, action: #selector(self.addButton), for: UIControl.Event.touchUpInside)
        */
         //Initializations for remove button in widget mode
         //remove.frame = CGRect(x:7, y:130, width: 40, height:40 )
         //remove.layer.cornerRadius = 0.5 * addTask.bounds.size.width
         //remove.clipsToBounds = true
         //remove.backgroundColor = .red
         //remove.setTitleColor(.white, for: .normal)
         //remove.setTitle("x", for: .normal)
         //remove.addTarget(self, action: #selector(self.removeTask), for: UIControl.Event.touchUpInside)
        
         //Initializations for taskList tableView button
         /*taskList.backgroundColor = .white
         taskList.separatorStyle = UITableViewCell.SeparatorStyle.none
         taskList.delegate = self
         taskList.dataSource = self
         taskList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
     
         //initializations for mini table
         miniTable.backgroundColor = .none
         miniTable.separatorStyle = UITableViewCell.SeparatorStyle.none
         miniTable.delegate = self
         miniTable.dataSource = self
         miniTable.estimatedRowHeight = 100
         miniTable.rowHeight = UITableView.automaticDimension

         miniTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
         
        
         //adding to UIView displayed on the slide up full view mode
         fullView.addSubview(taskList)
         fullView.addSubview(fullViewAddTask)
     
        */
        
        titleLabel.text = "Add an Appointment"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue", size:20)
        titleLabel.numberOfLines = 4
        titleLabel.lineBreakMode = .byWordWrapping
        //titleLabel.sizeToFit()
        
        timeLeftLabel.textAlignment = .center
        timeLeftLabel.font = UIFont(name: "HelveticaNeue-Thin", size:18)
        timeLeftLabel.numberOfLines = 2
        timeLeftLabel.lineBreakMode = .byWordWrapping
        
        //titleLabel.contentMode = .scaleToFill
        //titleLabel.adjustsFontSizeToFitWidth = true
        //titleLabel.minimumScaleFactor = 0.2
        self.addSubview(titleLabel)
        self.addSubview(timeLeftLabel)
        
        //constraining Label
        self.label.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
         //add components to subview
         self.addSubview(label)
         //self.insertSubview(miniTable, belowSubview: delButton)
         //self.addSubview(remove)
         self.addSubview(addTask)
         

    }
    
    //Default constructor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
            //Method for adding appointment
            @objc func addButton(_ sender: UIButton!) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Appointment", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default)
            {
                (action)in

                if textField.text != "" && self.dateTextField.text != ""{
                    var newAppt = appointment()
                    newAppt.title.text = textField.text!
                    newAppt.date = self.dateBuffer
                    self.endEditing(true)
                    
                    self.itemArray.append(newAppt)
                    
                    self.arraySort(apptArray: &self.itemArray, start: 0, end: self.itemArray.count-1)

                    for i in 0...self.itemArray.count-1{
                        print(self.itemArray[i].date)
                    }
                    
                    self.titleLabel.text = self.itemArray[0].title.text
                    self.timeLeftLabel.text = self.dateDisplayBuffer
                    
                    
                    //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                    //self.label.text  = self.itemArray[self.itemArray.count - 1]
                    //self.taskList.reloadData()
                    //self.miniTable.reloadData()
                }
            }
            alert.addTextField { (alertTextField) in
               alertTextField.placeholder = "Create New Item"
               textField = alertTextField
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Add Date and Time"
                self.dateTextField = alertTextField
                self.dateTextField.inputView = self.datePicker
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
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        dateBuffer = self.datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.dateDisplayBuffer = self.dateTextField.text
    }
    
    func arraySort( apptArray: inout [appointment], start: Int, end: Int){//quicksort for itemArray
        if abs(start - end) == 0 || apptArray.count == 1 {return}//base case does not work
        
        let pI = partition(apptArray: &apptArray, start: start, end: end)
        
        if pI-1 >= start {arraySort(apptArray: &apptArray, start: start, end: pI-1)}
        
        if pI+1 <= end {arraySort(apptArray: &apptArray, start: pI+1, end: end)}
    }
    
    func partition( apptArray: inout [appointment], start: Int, end: Int) ->Int{
        var i = start
        print(start)
        print(end)
        
        for j in start...end{
            if apptArray[j].date < apptArray[end].date{
                let temp = apptArray[j]
                apptArray[j] = apptArray[i]
                apptArray[i] = temp
                i = i+1
            }
        }
        let temp = apptArray[end]
        apptArray[end] = apptArray[i]
        apptArray[i] = temp
        return i
    }
    
    

    
    
    //Data Members
    let addTask = UIButton(type: .system) //button to add to todo list
    var itemArray: [appointment] = [] //array for user's appointments
    let datePicker: UIDatePicker = UIDatePicker()
    var label = UILabel(frame: CGRect(x: 20, y: 141, width: 200, height: 21)) //label to display title on widget
    var dateBuffer = Date()
    var dateDisplayBuffer: String?
    var dateTextField = UITextField()
    var titleLabel = UILabel(frame: CGRect(x: 8.5, y: 2, width: 160, height: 100))
    var timeLeftLabel = UILabel(frame: CGRect(x: 8.5, y: 70, width: 160, height: 50))
   
}
