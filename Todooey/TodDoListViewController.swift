//
//  ViewController.swift
//  Todooey
//
//  Created by Andy Harris on 04/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit

class TodDoListViewController : UITableViewController {

    var itemArray = ["Find Mike", "Buy eggs", "blaa bla"]
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Retreive data from userdefaults memory
        //Data is saved in a dictionary collection using Key "TodoListArray". The data itself of string type
        //and will be extracted into an array
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            //copy into the itemArray which is used by the app to display stuff to the tableview
            itemArray = items
        }
    }

    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (itemArray[indexPath.row])
        // add check mark if there isn't one, else get rid
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // turn off highlighting of selected cell ... looks nicer
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - add new items
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        //need brackets to initialse the variable
        
        //pop up an UIAlert style dialogue box when the Add button is pressed
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        //Define the action button ("Add Item") in the popup, and refer to the action to take place when "Add Item"
        //is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item on our UI alert ....
            //Add new item to the itemArray
            //textField is a reference to the popup textfield
            self.itemArray.append(textField.text!)
            //update tableview from the itemArray
            self.tableView.reloadData()
            //save in user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")

        }
        //Add a text field in the popup to capture the todo
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //Point "trextField" at alertTextField. This sets up a REFERENCE to the alertTextField.
            //textField has got scope across the whole function
            textField = alertTextField
            
        }
        // add the action "action" to happen when the button is pressed in the UIalert dialogue box
        alert.addAction(action)
        //Finally, you actually have to show the dialogue box
        present(alert, animated: true, completion: nil)
        
    }
    
    
    

}

