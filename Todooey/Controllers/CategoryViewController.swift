//
//  CategoryViewController.swift
//  Todooey
//
//  Created by Andy Harris on 06/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //create a new Realm instance
    let realm = try! Realm()
    // Realm could fail the first time you do it, hence the try
    
    //Need an container to hold the categories. The container will be a Realm type called Results
    //Results is an **auto-updating** container type,
    //and will be holding objects of type Category
    
    var categories:  Results<Category>!
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load catgories from context into local container "categories"
        loadCategories()
        
    }
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //categories container may be empty (nil), so we need to write code around it to stop it crashing
        //if categories is not nil, it returns the count, else it returns 1
        //?? is called the nil coalescing operator
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeue what's in the table view already
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //get the category for that row out of the category array
        //use nil coalescing operator, so if there are no categories we display the text as below
        cell.textLabel?.text = categories?[indexPath.row].name  ?? "No categories added yet"
        
        return cell
    }
    
    // MARK: - "Add" button pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //set up a text field variable which will capture the text from the action pop up
        var textField = UITextField()
        //need brackets to initialse the variable
        
        //pop up an UIAlert style dialogue box when the Add button is pressed
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        //Define the action button title in the popup, and refer to the action to take place when "Add Category"
        //is pressed
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //create a new category object and load the name from the text field
            let newCategory = Category()
            newCategory.name = textField.text!
            //save it in Realm
            self.save(category: newCategory)
            
        }
        // add the action "action" to happen when the button is pressed in the UIalert dialogue box
        alert.addAction(action)

        //Add a text field in the popup to capture the todo
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //Point "trextField" at alertTextField. This sets up a REFERENCE to the alertTextField.
            //textField has got scope across the whole function
            textField = alertTextField
            
        }
        //Finally, you actually have to show the dialogue box
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //run when user clicks on one of the categories
        //trigger a segue to go to itemsviewcontroller "GoToItems"
        //there is only one segue
        performSegue(withIdentifier: "GoToItems", sender: self)
        
    }
    
    //MARK - segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //called just before segue
        //get a reference to the segue destination (down casted as a todolistVC)
        let destinationVC = segue.destination as! TodDoListViewController
        //use this to access a variable inside the todolistVC code
        //pass this variable the category object selected
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //categories is an optional, hence selectedcategory in ToDoListViewController must also be an optional
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    
    //MARK - Data Manipulation Methods
    
    func loadCategories() {
        
        //update the categories Results container with realm Category objects
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {

        //save the new category in persistent data
        do {
            //save in Realm instance
            try realm.write {
                //commit the changes, these changes are to add the category
                realm.add(category)
            }
            
            //update tableview from the itemArray
            self.tableView.reloadData()
        }
        catch {
            print("Error saving context,  \(error)")
        }
        
    }
    
}
