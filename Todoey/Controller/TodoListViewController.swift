//
//  ViewController.swift
//  Todoey
//
//  Created by Bhavna Mohan on 24/12/17.
//  Copyright © 2017 Bhavna Mohan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Item"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Item 1"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Item 2"
        itemArray.append(newItem2)
        
        if let items = defaults.array(forKey : "ToDoListArray") as? [Item]
        {
            itemArray = items
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK :- Methods for Table View DataSource
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for :indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if item.done == true
//        {
//            cell.accessoryType = .checkmark
//        }
//        else
//        {
//             cell.accessoryType = .none
//        }
        return cell
    }
    
    //MARK :- Table View delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//       if itemArray[indexPath.row].done == false
//        {
//            itemArray[indexPath.row].done = true
//        }
//        else
//       {
//        itemArray[indexPath.row].done = false
//        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else
//        {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK :- Add new To Do List
    @IBAction func addNewToDoListPressed(_ sender: UIBarButtonItem) {
       // var newItem = ""
        var textFiled = UITextField()
        let alert = UIAlertController(title : "Add a new Todoey item",message : "",preferredStyle:.alert)
        let action = UIAlertAction(title : "Add Item", style : .default) { (action) in
           // print(textFiled.text)
            let newItem = Item()
            newItem.title = textFiled.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
          //  newItem = alertTextField.text!
            textFiled = alertTextField
           // print(alertTextField.text)
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

    
