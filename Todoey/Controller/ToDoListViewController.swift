//
//  ViewController.swift
//  Todoey
//
//  Created by Jésus Husbands on 13/04/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
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
            // New Array Item
            let newItem = Item()
            newItem.title = textField.text!
            
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write (to: self.dataFilePath!)
        } catch {
            print ("Error encoding itemArray, \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            // Decode the data
            let decoder = PropertyListDecoder()
            // Try to decode itemArray else catch error
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding itemArray, \(error)")
            }
        }
    }
}

