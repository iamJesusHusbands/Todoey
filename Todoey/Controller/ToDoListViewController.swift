//
//  ViewController.swift
//  Todoey
//
//  Created by Jésus Husbands on 13/04/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //Tap into the AppDelegate Object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems()
        
//        // Load up user defaults
//        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    // MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell creation
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Set text label to be the items in the itemArray
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        // Ternary Operator to add or remove checkmark from a cell when selected and deselected
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    // MARKS - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Print the cell number of the clicked cell
        //print(indexPath.row)
        // Print the content of the cell clicked
        //print(itemArray[indexPath.row])
        
//        // Delete data from context
//        context.delete(itemArray[indexPath.row])
//        // Remove item from itemArray
//        itemArray.remove(at: indexPath.row)
        
        // Set done to the opposite of current state when row is selected.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.reloadData()
        
        // When a cell is selected it flashes gray then appears white when deselected
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARKS - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Local variable to add text to the item
        var textField = UITextField()
        
        // Add pop up when button is pressed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // Button in alert to add a new item
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens when add button is pressed
            
            // Create a new Array Item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            // Set done property for a new item to be false
            newItem.done = false
            // Specify the category for a new item
            newItem.parentCategory = self.selectedCategory
            
            // Adds String from text field into the array
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            // Reloads the tableview to show the new item in the array
            self.tableView.reloadData()
            
        }
            
        // Adds the String from the alertTextfield to the local variable
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create Item"
            textField = alertTextField
        }
            
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
            
    }
    
    // MARKS - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print ("Error encoding itemArray, \(error)")
        }
    }
    
    // Create loadItems function which takes in 2 input parameter and sets a default in case no input is given
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // New predicate to query and filter the search items
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

// MARKS : Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    // This holds the functionality of the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Set up fetch request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Create a predicate which will filter search based on text
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Sort the data
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // If the searchBar text count == 0 call load itsmes method
        if searchBar.text?.count == 0 {
            loadItems()
            
            // In the foreground remove the keyboard and cursor from the screen
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

