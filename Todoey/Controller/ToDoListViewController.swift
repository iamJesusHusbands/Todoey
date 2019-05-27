//
//  ViewController.swift
//  Todoey
//
//  Created by Jésus Husbands on 13/04/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // loadItems()
        
//        // Load up user defaults
//        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    // MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell creation
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            // Set text label to be the items in the itemArray
            cell.textLabel?.text = item.title
            // Ternary Operator to add or remove checkmark from a cell when selected and deselected
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    // MARKS - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
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
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
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
    
//    func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print ("Error encoding itemArray, \(error)")
//        }
//    }
    
    // Create loadItems function which takes in 2 input parameter and sets a default in case no input is given
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

// MARKS : Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    // This holds the functionality of the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Sort using realm
        todoItems = todoItems?.filter("title CONTAINS [cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
//        // Set up fetch request
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // Create a predicate which will filter search based on text
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // Sort the data
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
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

