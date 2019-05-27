//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Jésus Husbands on 30/04/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    // Declare new realm
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell creation
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Set text label to be the items in the categoryArray
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
        
    }
    
    // MARKS: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Trigger Segue
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // Method prepares destination for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set segue destination
        let destinationVC = segue.destination as! TodoListViewController
        
        // Go to selected indexPaths ViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving cateory, \(error)")
        }
        
        tableView.reloadData()
    }
    
    // Create loadItems function which takes in one input parameter and sets a default in case no input is given
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Local variable to add text to the category
        var textField = UITextField()
        
        // Add pop up when button is pressed
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        // Button in alert to add a new category
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What happens when add button is pressed
            
            // Create a new Array category
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
            // Reloads the tableview to show the new item in the array
            self.tableView.reloadData()
            
        }
        
        // Adds the String from the alertTextfield to the local variable
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create Category"
            textField = alertTextField
        }
        
        // Adds the action which was created
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
