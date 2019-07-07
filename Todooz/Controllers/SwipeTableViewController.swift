//
//  SwipeTableViewController.swift
//  Todooz
//
//  Created by adam on 07/07/2019.
//  Copyright © 2019 Adam. All rights reserved.
//

import UIKit
import SwipeCellKit

// **SUPERCLASS** that we implement both inside CategoryViewController and in TodoListViewController
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80

    }
    
    // MARK: - TableView Datasource methods
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // NOTE: When changing type of Cell we need to change it as well in Storyboard!!
        // TableViewCell @ Storyboard needs to have class set up as SwipeTableViewCell and module as SwipeCellKit
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - SwipeCellKit methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "delete") { (action, indexPath) in
            self.updateModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }

}
