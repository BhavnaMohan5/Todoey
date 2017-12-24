//
//  ViewController.swift
//  Todoey
//
//  Created by Bhavna Mohan on 24/12/17.
//  Copyright © 2017 Bhavna Mohan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike","Get Eggs","Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK :- Methods for Table View DataSource
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for :indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK :- Table View delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
       
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK :- Add new To Do List
    @IBAction func addNewToDoListPressed(_ sender: UIBarButtonItem) {
       // var newItem = ""
        var textFiled = UITextField()
        let alert = UIAlertController(title : "Add a new Todoey item",message : "",preferredStyle:.alert)
        let action = UIAlertAction(title : "Add Item", style : .default) { (action) in
           // print(textFiled.text)
            self.itemArray.append(textFiled.text!)
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

    
