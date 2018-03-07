//
//  ViewController.swift
//  Todooey
//
//  Created by Andy Harris on 04/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit
import CoreData

class TodDoListViewController : UITableViewController {

    //var itemArray = ["Find Mike", "Buy eggs", "blaa bla"]
    //Now it becomes an array of objects of class Item and are initialsied
    //***
    var itemArray = [Item]()
    
    //define a variable which we will use from CategoryViewController to pass the category details
    // it is optional, hence "?"
    //provided a cetegory has been set, we can load up the items for that category
    //didSet determines what to do when a variable gets set to a new value
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //UIApplication.shared refers to the current app
    //UIApplication.shared.delegate as! AppDelegate gives us access to the app delegate as an object
    //then we can access the context (viewcontext) of the Persistent Store
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        //Fetch all the data out of Core Data context and load up itemArray
        //loadItems()
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
        
        return cell
 
    }
    
    // MARK - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Example of update
        // if we want to update all titles to "completed":
        //itemArray[indexPath.row].setValue("completed", forKey: "title")
        
        //if we want to remove NSmanagedobject from context
        // context.delete(itemArray[indexPath.row])
        //then (and only then) remove current item from data array
        //itemArray.remove(at: indexPath.row)
        
        saveItems()
        
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
           
            //create a new item based on the Item entity which is an NSManagedObject
            //This item is created in the Context area
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()

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
        
        do {
            //save the context in Persistent Data
            try context.save()
            //update tableview from the itemArray
            self.tableView.reloadData()
        }
        catch {
            print("Error saving context,  \(error)")
        }
       
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //load items from context using the request format in "from" and the database predicate "predicate"
        //Item.fetchRequest() is the default request, if no specific request is passed in
        //If no predicate variable passed, then predicate default = nil
        //"with" is external variable, "response" is internal param
        //Note that ":NSFetchRequest" is included because we must specify data type of the request method
        
        //set up the search predicate to filter out the to do items for the category selected in the CategoryViewController
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)

        //Check if another predicate was passed to loadItems e.g. as a result of a search query
        if let additionalPredicate = predicate {
            //if so, combine the 2 predicates
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        //then do the actual fetch from context
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from persistent data")
        }
        
        //and refresh the table
        tableView.reloadData()

    }
    
}

//MARK - search bar methods
//Separate out specific functionality into a separate extension block

extension TodDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // query the core data
        //NSPredicate is a foundation class to query core data
        //A cheat sheet is on NSpredicate is on the Realm blog at
        //https://static.realm.io/downloads/files/NSPredicateCheatsheet.pdf?_ga=2.253802632.1639710766.1520325555-232052067.1520325555
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //[cd] means not case or diacritic sensitive
        //Sort using the key "title" in ascending order
        
        //request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending : true)]
        
        loadItems(with: request, predicate: predicate)
        
        
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
