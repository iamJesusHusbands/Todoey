//
//  ViewController.swift
//  Todoey
//
//  Created by Jésus Husbands on 13/04/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggs", "Destroy Files"]
    
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
}

