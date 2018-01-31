//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bhavna Mohan on 13/01/18.
//  Copyright © 2018 Bhavna Mohan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var CategoryArray : Results<Category>?
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadItems()
       // tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(CategoryArray?.count)
        return CategoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        print("Inside cell for row at")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = CategoryArray?[indexPath.row].name ?? "No categories added yet"
        print(cell.textLabel?.text)
        cell.backgroundColor = UIColor(hexString : CategoryArray?[indexPath.row].color ?? "1D98F6")
        return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
         if let indexPath = tableView.indexPathForSelectedRow
         {
            destinationVC.selectedCategory = CategoryArray?[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("In add")
        var textFiled = UITextField()
        let alert = UIAlertController(title : "Add a new Category",message : "",preferredStyle:.alert)
        let action = UIAlertAction(title : "Add", style : .default) { (action) in
            // print(textFiled.text)
            
      //      let newItem = Category(context: self.context)
            
            let newCategory = Category()
            newCategory.name = textFiled.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.saveItems(with: newCategory)
            
            self.tableView.reloadData()
        }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            
            textFiled = alertTextField
        
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
        func saveItems(with category : Category)
        {
            do{
                try realm.write {
                    realm.add(category)
                }
            }catch{
                print("Error saving data to realm,\(error)")
            }
            tableView.reloadData()
        }
        
        func loadItems()
        {
            CategoryArray = realm.objects(Category.self)
             tableView.reloadData()
        }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.CategoryArray?[indexPath.row]
        {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    }
