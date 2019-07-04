//
//  ViewController.swift
//  Todooz
//
//  Created by adam on 02/07/2019.
//  Copyright © 2019 Adam. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [TodoItem]()
    
    // Set up standard UserDefaults persistence method
    // defaults is a SINGLETON!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get items from UserDefaults
        if let todos = defaults.array(forKey: "Todooz") as? [TodoItem ] {
            items = todos
        }
    }
    
    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell, popuklate it and return
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    //MARK: TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle a done property of TodoItem
        items[indexPath.row].done.toggle()
        // Deselect row (remove background)
        tableView.deselectRow(at: indexPath, animated: true)
        // Reload TableView
        tableView.reloadData()
    }
    
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: Any) {
        // textField var created to grab a reference for the alertTextField created in closure below
        var textField = UITextField()
        // Create an alert
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        // Create an action
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            // upon completion
            // create a TodoItem
            let newItem = TodoItem()
            newItem.title = textField.text!
            //add an item to our items
            self.items.append(newItem)
            // set the item into UserDefaults
            self.defaults.set(self.items, forKey: "Todooz")
            // and reload data source of tableView to render all items
            self.tableView.reloadData()
        }
        // Add a TextField to an alert body
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        // Add an action to the alert
        alert.addAction(action)
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
}

