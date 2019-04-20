//
//  ViewController.swift
//  Todoey
//
//  Created by Jésus Husbands on 13/04/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Files"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell creation
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Set text label to be the items in the itemArray
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    // MARKS - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Print the cell number of the clicked cell
        //print(indexPath.row)
        // Print the content of the cell clicked
        //print(itemArray[indexPath.row])
        
        // When a cell is selected it flashes gray then appears white when deselected
        tableView.deselectRow(at: indexPath, animated: true)
        
        // IF statement to add or remove checkmark from a cell when selected and deselected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
            // Adds String from text field into the array
            self.itemArray.append(textField.text!)
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
    
}

