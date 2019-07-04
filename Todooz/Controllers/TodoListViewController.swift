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

    // 1. Set up standard UserDefaults persistence method
    // defaults is a SINGLETON!
    // Also, it's only good for storing standard data types, not for Objects!
//    let defaults = UserDefaults.standard
    
    // 2. Create a data file path to FileManagers document directory
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get items from UserDefaults
//        if let todos = defaults.array(forKey: "Todooz") as? [TodoItem ] {
//            items = todos
//        }
        // 2. load items from FileManager
        loadItems()
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
        // 2. Save data into DataFile
        saveItems()
        // Deselect row (remove background)
        tableView.deselectRow(at: indexPath, animated: true)
        // Reload TableView
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    
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
            
            // 1. set the items into UserDefaults
//            self.defaults.set(self.items, forKey: "Todooz")
            
            // 2. Set items into a FileManager
            self.saveItems()
            
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
    
    //MARK: Model Manipulation Methods:
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding items \(items)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error decoding items \(items)")
            }
        }
        
    }
    
}

