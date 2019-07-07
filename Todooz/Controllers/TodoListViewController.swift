//
//  ViewController.swift
//  Todooz
//
//  Created by adam on 02/07/2019.
//  Copyright © 2019 Adam. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var items: Results<Item>?
    
    let realm = try! Realm()
    
    // Category set up in prepare(forSegue) at CategoryViewController
    var selectedCategory: Category? {
        // this will happen when selectedCategory is set with some value, (coming from prev screen)
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up view controllers title
        self.title = selectedCategory?.name
        
    }
    
    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell, populate it and return
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items yet, please add some"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.name = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving Item: \(error)")
                }
                self.tableView.reloadData()
                
            }
        }
        // Add a TextField to an alert body
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        // Add actions to the alert
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods:
        
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Couldn't delete item: \(error)")
            }
        }
    }
    
}

//MARK: - SearchBar Methods

// Add a protocol of SearchBar as an extension of controller. So we can handle search bar related methods separately
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // Hide keyboard and un-focus searchBar (on main queue/thread)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }



}
