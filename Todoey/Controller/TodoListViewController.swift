//
//  ViewController.swift
//  Todoey
//
//  Created by Bhavna Mohan on 24/12/17.
//  Copyright © 2017 Bhavna Mohan. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//     let predicate = NSPredicate(format : "title CONTAINS[cd] %@",searchBar.text!)
    var selectedCategory : Category?
    {
        didSet
        {
            loadItems()
        }
        
    }
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
  //  let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
     //   print(dataFilePath!)
        
       loadItems()
        
//        if let items = defaults.array(forKey : "ToDoListArray") as? [Item]
//        {
//            itemArray = items
//        }
        
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

        return cell
    }
    
    //MARK :- Table View delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
           saveItems()

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK :- Add new To Do List
    @IBAction func addNewToDoListPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title : "Add a new Todoey item",message : "",preferredStyle:.alert)
        let action = UIAlertAction(title : "Add Item", style : .default) { (action) in
           // print(textFiled.text)
           
            let newItem = Item(context: self.context)
            newItem.title = textFiled.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.saveItems()
            
            
            self.tableView.reloadData()
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
            try context.save()
        }
        catch
        {
            print("Error saving context,\(error)")
        }
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil)
    {
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
     if let additionalPredicate = predicate
     {
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
     else{
        request.predicate = categoryPredicate
        }
        
//        request.predicate = compoundPredicate
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Unable to fetch data \(error)")
        }
    }
    
}
    extension TodoListViewController : UISearchBarDelegate
    {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format : "title CONTAINS[cd] %@",searchBar.text!)
            request.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            loadItems(with : request)
            tableView.reloadData()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           // print("Inside text did change")
            if searchBar.text?.count == 0
            {
                 //  print("Inside text did change count 0")
                let request : NSFetchRequest<Item> = Item.fetchRequest()
                loadItems(with : request)
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
                
            }
        }
        
    }











    
