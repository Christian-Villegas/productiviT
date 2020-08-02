//
//  AppointmentsWidget.swift
//  widgets
//
//  Created by Christopher Cordero on 7/20/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class AppointmentsWidget: Widget, UITableViewDelegate, UITableViewDataSource {
    
    struct appointment {
        var title = UILabel()
        var date = Date()
        var time: String = ""
    }

    //custom constructor
    override init(frame: CGRect) {
        taskList = UITableView(frame: CGRect(x: 0, y: 0, width: 414, height: 800), style: .plain)
        miniTable = UITableView(frame: CGRect(x: 0, y:0, width: 177, height: 140), style: .plain)
         
        super.init(frame: frame)
        self.number = 2//number assigned to ToDo widgets, for checking which widget to display when full view is requested
        self.label.text = "Appointments"//widget will display this when first added
        self.title = "Appointments Widget"
        
        //initializations for datepicker module
        datePicker.frame = CGRect(x: 10, y: 50, width: self.frame.width, height: 200)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        //Initializations for taskList tableView button
        taskList.backgroundColor = .white
        taskList.separatorStyle = UITableViewCell.SeparatorStyle.none
        taskList.delegate = self
        taskList.dataSource = self
        taskList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.fullView.insertSubview(taskList, belowSubview: fullViewAddTask)
     
        //initializations for mini table
        miniTable.backgroundColor = .white
        miniTable.alpha = 0.7
        miniTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        miniTable.delegate = self
        miniTable.dataSource = self
        miniTable.estimatedRowHeight = 100
        miniTable.rowHeight = UITableView.automaticDimension
        miniTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.insertSubview(miniTable, belowSubview: self.shield)
    }
    
    //Default constructor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //custom Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .none
        cell.textLabel?.text = itemArray[indexPath.row].title.text
        cell.detailTextLabel?.text = itemArray[indexPath.row].time
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size:20)
        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.numberOfLines=0
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.minimumScaleFactor = 0.2
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
        let timeInterval = self.itemArray[indexPath.row].date.timeIntervalSinceNow
        let timeRemaining = stringFromTimeInterval(interval: timeInterval)
        let alert = UIAlertController(title: "Time Remaining", message: timeRemaining, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (self.itemArray.count - 1) > 0
            {
                self.itemArray.remove(at: indexPath.row)
                self.titleLabel.text  = self.itemArray[self.itemArray.count - 1].title.text
                self.timeLeftLabel.text  = self.itemArray[self.itemArray.count - 1].time
                //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            }
            else{
                self.titleLabel.text  = "Add an Appointment"
                self.timeLeftLabel.text = ""
                if itemArray.count > 0 {self.itemArray.remove(at:indexPath.row)}
                //self.defaults.set(self.itemArray, forKey: "ToDoListArray")

            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.taskList.reloadData()
            self.miniTable.reloadData()
            
        }
    }
    //
    
    
    //Method for adding appointment
    @objc override func addButton(_ sender: UIButton!) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Appointment", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .default)
        {
            (action)in

            var newAppt = appointment()
            if textField.text != "" && self.dateTextField.text != ""{
                newAppt.date = self.dateBuffer
            }
            if textField.text != "" && self.dateTextField.text == ""{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                self.dateTextField.text = dateFormatter.string(from: Date())
                self.dateDisplayBuffer = self.dateTextField.text
                newAppt.date = Date()
            }
            newAppt.title.text = textField.text!
            newAppt.time = self.dateDisplayBuffer ?? ""
            self.endEditing(true)
            
            self.itemArray.append(newAppt)
            
            self.arraySort(apptArray: &self.itemArray, start: 0, end: self.itemArray.count-1)

            for i in 0...self.itemArray.count-1{
                print(self.itemArray[i].date)
            }
            
            let labelSize = self.rectForText(text: self.itemArray[0].title.text!, font: UIFont(name: "HelveticaNeue-Thin", size:25)!, maxSize: CGSize(width: 160,height: 999))
            let labelHeight = labelSize.height //here it is!
            print(labelHeight)
            self.titleLabel.frame = CGRect(x: 8.5, y: 2, width: 160, height: labelHeight)
            self.titleLabel.text = self.itemArray[0].title.text
            self.timeLeftLabel.text = self.dateDisplayBuffer
           
            self.taskList.reloadData()
            self.miniTable.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Event Title"
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
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
            return size
    }
    
    
    //NEEDS TO BE UPDATED WITH AUTOLAYOUT
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
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let time = NSInteger(interval)

        let days = (time / 86400)
        let hours = ((time%86400) / 3600)
        let minutes = (((time%86400) % 3600))/60
        
        if days == 0 && hours == 0 && minutes == 0 {
            let message = "Event has passed"
            return message
        }

        return String(format: "%0.2d Days %0.2d Hours %0.2d Minutes",days,hours,minutes)
    }
    
    //Data Members
    var itemArray: [appointment] = [] //array for user's appointments
    let datePicker: UIDatePicker = UIDatePicker()
    var dateBuffer = Date()
    var dateDisplayBuffer: String?
    var dateTextField = UITextField()
    var titleLabel = UILabel()
    var timeLeftLabel = UILabel(frame: CGRect(x: 8.5, y: 70, width: 160, height: 45))
    var taskList: UITableView //shows table view on the full view
    var miniTable: UITableView //table view for widget mode
}
