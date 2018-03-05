//
//  ViewController.swift
//  Todooey
//
//  Created by Andy Harris on 04/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit

class TodDoListViewController : UITableViewController {

    //var itemArray = ["Find Mike", "Buy eggs", "blaa bla"]
    //Now it becomes an array of objects of class Item and are initialsied
    //***
    var itemArray = [Item]()
    
    // Set up a new plist in the same directory allocated to the app
    //this is currently in the file system on the laptop
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        loadItems()
        /*
         let newTodo = Item()
        newTodo.title = "first todo"
        itemArray.append(newTodo)
         */

        //Retreive data from User Defaults memory
        //to do items are saved as an array of items of class Item in User Defaults under the Key "TodoListArray".
        //***
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            //copy into the itemArray which is used by the app to display stuff to the tableview
//            itemArray = items
//        }
    }

    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //***
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        /* same as saying
        cell.accessoryType = item.done == true ? .checkmark : .none
        */
        saveItems()

        return cell
 
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //***
        //    print (itemArray[indexPath.row].title)
        //***
        //toggle the "done" setting in the item
        //
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        self.tableView.reloadData()
        
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
            //*** self.itemArray.append(textField.text!)
            // New version: create a new object
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //Was failing here, trying to save in user defaults. iOS doesn't like using USerDefaults for saving an array
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // User alternative method, encoding data into the file system
            self.saveItems()
            //update tableview from the itemArray
            self.tableView.reloadData()

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
    
    func saveItems() {
        // get a encoder object of type plist ("Property List")
        let encoder = PropertyListEncoder()
        do {
            //encode the itemArray objects
            let data = try encoder.encode(itemArray)
            // drite them to the folder specified by dataFilePath (set when the TableViewController is initialised)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array,  \(error)")
        }
       
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            // get a decoder object of type plist ("Property List")
            let decoder = PropertyListDecoder()
            do {
                //decode the contents of "data" (from Data() above)
                //and put it into itemArray
                itemArray = try decoder.decode([Item].self, from:data)
            }
            catch {
                print("Error decoding item array \(error)")
            }
        }
    }

}

