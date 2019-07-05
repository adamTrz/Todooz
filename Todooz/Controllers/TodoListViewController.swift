//
//  ViewController.swift
//  Todooz
//
//  Created by adam on 02/07/2019.
//  Copyright © 2019 Adam. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UISearchBarDelegate {
    
    var items = [Item]()
    // 3. Use SharedData
    // Grab context:
    // Find reference to AppDelegate, grab persistentContainer and then grab its context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell, populate it and return
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
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
        
//        // Delete data:
//        // First delete it from context, then from local state!
//        // After that we need to "commit" our changes to DB by doing context.save() as well...
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
        
        // Save data
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
            // 3. Use CoreData to store items
            // Create new Item as a CoreData entity
            let newItem = Item(context: self.context)
            newItem.name = textField.text!
            newItem.done = false
            
            self.items.append(newItem)
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
    
    //MARK: - Model Manipulation Methods:
    
    func saveItems() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving contect \(error)")
            }
        }
    }
    func loadItems() {
        // Create a request that will fetch Items
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let items = try context.fetch(request)
            self.items = items
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
}

