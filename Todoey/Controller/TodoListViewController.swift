//
//  ViewController.swift
//  Todoey
//
//  Created by Bhavna Mohan on 24/12/17.
//  Copyright © 2017 Bhavna Mohan. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController{

    var toDoItems : Results<Item>?
    
  //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 //   let predicate = NSPredicate(format : "title CONTAINS[cd] %@",searchBar.text!)
    let realm = try! Realm()
    var selectedCategory : Category?
    {
        didSet
        {
            loadItems()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //  loadItems()
    }

    //MARK :- Methods for Table View DataSource
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for :indexPath)
       if let item = toDoItems?[indexPath.row]
       {
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none

        }
        else
       {
        cell.textLabel?.text = "No item added yet"
        }
       
        return cell
    }
    
    //MARK :- Table View delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]
        {
            do{
            try realm.write {
                item.done = !item.done
                }
            }catch{
                print("Error in saving status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK :- Add new To Do List
    @IBAction func addNewToDoListPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title : "Add a new Todoey item",message : "",preferredStyle:.alert)
        let action = UIAlertAction(title : "Add Item", style : .default) { (action) in
           // print(textFiled.text)
           
            if let currentCategory = self.selectedCategory
            {
                
                
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textFiled.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                       // self.realm.add(newItem)
                    }
                }
                catch{
                    print("Error saving data to realm,\(error)")
                }
            }
            self.tableView.reloadData()
            
//            let newItem = Item(context: self.context)
//            newItem.title = textFiled.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//            self.saveItems()
//            self.tableView.reloadData()
        }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()
    {
       
        do
        {
          //  try context.save()
        }
        catch
        {
            print("Error saving context,\(error)")
        }
    }
    
    func loadItems()
    {
        toDoItems = selectedCategory?.items.sorted(byKeyPath : "title",ascending : true )
        tableView.reloadData()
    }
    
}
    extension TodoListViewController : UISearchBarDelegate
    {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated",ascending : true)
            tableView.reloadData()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0
            {
                loadItems()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }

            }
        }
        
    }











    
