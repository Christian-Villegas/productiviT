
import UIKit

class ToDoWidget: Widget  {
    var itemArray: [String] = []
    var label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 21))
    let defaults = UserDefaults.standard
    let addTask = UIButton(type: .system)
    let remove = UIButton(type: .system)
    
    
   /* override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }*/
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }*/
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }*/
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.title = "To Do List"
        
        //label.center = CGPoint(x: 15, y: 15)
        self.label.textAlignment = .left
        self.label.text = "To Do List"
        self.addSubview(self.label)
        
        addTask.frame = CGRect(x: 55, y: 50, width: 40, height: 25)
        remove.frame = CGRect(x:35, y:50, width: 40, height:25 )
        addTask.setTitle("+", for: .normal)
        remove.setTitle("X", for: .normal)
        addTask.contentHorizontalAlignment = .right
        addTask.addTarget(self, action: #selector(self.addButton), for: UIControl.Event.touchUpInside)
        remove.addTarget(self, action: #selector(self.removeTask), for: UIControl.Event.touchUpInside)
        self.addSubview(addTask)
        self.addSubview(remove)

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addButton(_ sender: UIButton!) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default)
        {
            (action)in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.label.text  = self.itemArray[self.itemArray.count - 1]
            //self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }
    @objc func removeTask(_ sender: UIButton!)
    {
        self.itemArray.remove(at: itemArray.count - 1)
        if self.itemArray.count > 0
        {
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.label.text  = self.itemArray[self.itemArray.count - 1]
        }
        else{
            self.label.text  = "Add Goal"
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")

        }
    }
}


