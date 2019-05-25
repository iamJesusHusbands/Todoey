//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Jésus Husbands on 30/04/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    //Tap into the AppDelegate Object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell creation
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Set text label to be the items in the categoryArray
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print ("Error saving cateory, \(error)")
        }
        
        tableView.reloadData()
    }
    
    // Create loadItems function which takes in one input parameter and sets a default in case no input is given
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        // Fetch request for core data
        //let request : NSFetchRequest<Category> = categoryArray.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            // Adds String from text field into the array
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
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
