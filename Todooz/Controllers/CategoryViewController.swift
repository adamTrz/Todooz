//
//  CategoryTableViewController.swift
//  Todooz
//
//  Created by adam on 05/07/2019.
//  Copyright © 2019 Adam. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Initialise realm
    let realm = try! Realm()
    
    // Results is an auto-updating container type in Realm returned from object queries.
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if let categoriesCount = categories?.count {
            cell.textLabel?.text = categoriesCount > 0 ? categories?[indexPath.row].name : "No Categories added yet"
            cell.accessoryType = categoriesCount > 0 ? .disclosureIndicator : .none
        } else {
            cell.textLabel?.text = "No Categories added yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoriesCount = categories?.count ?? 0
        return categoriesCount == 0 ? 1 : categoriesCount
    }
    
    
    
    //MARK: - Data manipulation methods

    func loadCategories() {
        
        // Fetch all objects of type "category"
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(category). Error: \(error)")
        }
        tableView.reloadData()

    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // Create Category, save, etc
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories!.count > 0 {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        // Get Selected row
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
