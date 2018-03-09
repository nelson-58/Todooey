//
//  SwipeTableViewController.swift
//  Todooey
//
//  Created by Andy Harris on 08/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import Foundation
import SwipeCellKit

//MARK - SwipeCellDelegate methods
class SwipeTableViewController: UITableViewController,  SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set row height for superclass, which will effect ToDoListVC and CategoryVC
        tableView.rowHeight = 80
        
    }
    
    //TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //change the identifier to "cell" and change the storyboard prototype cell names to cell for
        //both todolistVC and categoryVC
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

        //cell.textLabel?.text = categories?[indexPath.row].name  ?? "No categories added yet"
        
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // code copied from https://github.com/SwipeCellKit/SwipeCellKit
        guard orientation == .right else {return nil}
        //When you swipe from right it will trigger the enclosure
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)

            //take this out after doing the delete
            //tableView.reloadData()
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        //need to put an image called "delete" in the support files
        //you can download this image from
        //https://github.com/SwipeCellKit/SwipeCellKit/blob/develop/Example/MailExample/Assets.xcassets/Trash.imageset/Trash%20Icon.png
        //downloaded to desktop and renamed delete-icon.png
        //then dragged across to Assets.xcassets folder in xcode and put into 2x
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    func updateModel(at indexPath: IndexPath) {
        print ("item deleted")
    }
    
    
}

