//
//  ViewController.swift
//  Todooey
//
//  Created by Andy Harris on 04/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit
import RealmSwift

class TodDoListViewController : SwipeTableViewController {

    //todoItems is an auto-updating container of type Realm Results, which in this case
    //holds objects of type Item
    var todoItems : Results<Item>?
    
    //create a new instance of Realm in this VC (theres also one in the CategoryVC
    let realm = try! Realm()
    
    //define a variable which we will use from CategoryViewController to pass the category details
    // it is optional, hence "?", because a category may not have been selected /entered
    //Once a cetegory has been set, we can load up the items for that category
    //didSet determines what to do when a variable gets set to a new value
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        //Fetch all the data out of persistent data
        //loadItems()
    }
    
    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //todoItems container may be empty (nil), so we need to write code around it to stop it crashing
        //if todoItems is not nil, it returns the count, else it returns 1
        //?? is called the nil coalescing operator a.k.a. optional chaining
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        //THIS IS THE NEW CODE FOR USE WITH THE SUPERCLASS SWIPETABLEVIEWCONTROLLER
        //dequeue what's in the table view already
        //let cell = super.tableview(tableView, cellForRowAt: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            //if so ...
            cell.textLabel?.text = item.title
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {

            cell.textLabel?.text = "No item added"
        }

        return cell
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            //if we have a list of todo items ...
            do {
                //and we can write to them
                try realm.write {
                    //toggle the done flag
                    //to change ecisting data, can edit direct. No need for realm.add
                    item.done = !item.done
                    
                    //if we want to delete the selected item, uncomment this line
                    //realm.delete(item)
                    //In actual fact, doing delete via SwipeCellKit and SwipeTableViewController
                }
            }
            catch {
                print ("Error saving done status: \(error)")
            }
        }
        //tableView.reloadData()
        //tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - add new items
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        //need brackets to initialise the variable
        //pop up an UIAlert style dialogue box when the Add button is pressed

        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        //Define the action button ("Add Item") in the popup, and refer to the action to take place when "Add Item"
        //is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //get item from text field and save it in realm instance
            //First check if a category has been selected
            if let currentCategory = self.selectedCategory {
                do {
                    //if there is, save in Realm instance
                    //needs to be saved via a try
                    try self.realm.write {
                        //create a new Item object
                        let newItem = Item()
                        newItem.dateCreated = Date()
                    
                        newItem.title = textField.text!
                        //No need to set the done flag, because the default is "false"
                        //add to the items container, but reference it from the category container,
                        //using the link called items, as defined in Category class property defined thus:
                        //"var items = List<Item>()"
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving context,  \(error)")
                }
                //update tableview from the itemArray
                self.tableView.reloadData()
            }
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
    
    func loadItems() {
        
        //get the items for the selected category
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
 
    //TODO: - modify update model to delete the selected to do ITEM
    //Called from SwipeTableViewController
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemsToDelete = self.todoItems?[indexPath.row] {
            //if we have a list of todos items ...
            do {
                //and we can write to them
                try self.realm.write {
                    self.realm.delete(itemsToDelete)
                }
            }
            catch {
                print ("Error deleting category: \(error)")
            }
        }
    }

}

//MARK - search bar methods
//Separate out specific functionality into a separate extension block for clarity

extension TodDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Filter the items with the title contained in the search bar search field, and sort by title
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted (byKeyPath: "title", ascending: true)
        // see realm database cheat sheet for predicates
        //Option 2: sort by date created
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted (byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //comes here whenever text changes
        
        if searchBar.text!.count == 0 {
            //text has changed to 0 characters, so get all items back
            loadItems()
            
            //this doesn't get rid of keyboard, so have to resign as first responder
            //need to run this methiod on the mmain queue so it doesn't wait for other background resources to finish (i think)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
   
        }
    }
    
    
}

