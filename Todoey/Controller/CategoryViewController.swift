//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bhavna Mohan on 13/01/18.
//  Copyright © 2018 Bhavna Mohan. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var CategoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        //MARK : TableView DataSource Methods
        
        //MARK : Data Manipulation Methods load data n save data
        
        //MARK : Add New Category

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for : indexPath)
        let item = CategoryArray[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
         if let indexPath = tableView.indexPathForSelectedRow
         {
            destinationVC.selectedCategory = CategoryArray[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        let alert = UIAlertController(title : "Add a new Category",message : "",preferredStyle:.alert)
        let action = UIAlertAction(title : "Add", style : .default) { (action) in
            // print(textFiled.text)
            
            let newItem = Category(context: self.context)
            newItem.name = textFiled.text!
            self.CategoryArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.saveItems()
            
            
            self.tableView.reloadData()
        }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            
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
        
        func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest() )
        {
            // let request : NSFetchRequest<Item> = Item.fetchRequest()
            do
            {
                CategoryArray = try context.fetch(request)
            }
            catch
            {
                print("Unable to fetch data \(error)")
            }
             tableView.reloadData()
        }
    }
