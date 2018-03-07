//
//  CategoryViewController.swift
//  Todooey
//
//  Created by Andy Harris on 06/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    //Need an array to hold the categories
    var categoryArray =  [Category]()
    
    
    //put in some dummy data
    
    //UIApplication.shared is a "singleton" for the shared application
    //.delegate is it's delegate as an appdelegate (using as! AppDelegate)
    // get a reference to the persistentContainer lazy variable in CoreData
    //viewcontext attribute
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

/*        //new Category object
        var newCategory = Category()
        //append it to the array
        categoryArray.append(newCategory)
        //"Home"
        let newCategory2 = Category()
        newCategory2.name = "Office"
        let newCategory3 = Category()
        newCategory3.name = "XCode"
*/
        
        //load catgories from context into local categoryArray
        loadCategories()
 
    }

    // MARK: - Table view data source

   

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //set up a text field variable which will capture the text from the action pop up
        var textField = UITextField()
        //need brackets to initialse the variable
        
        //pop up an UIAlert style dialogue box when the Add button is pressed
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        //Define the action button title in the popup, and refer to the action to take place when "Add Category"
        //is pressed
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //create a new item based on the Item entity which is an NSManagedObject
            //This item is created in the Context area
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
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
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeue what's in the table view already
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //get the category for that row out of the category array
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //run when user clicks on one of the categories
        //trigger a segue to go to itemsviewcontroller "GoToItems"
        //there is only one segue
        performSegue(withIdentifier: "GoToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //called just before segue
        //get a reference to the segue destination (down casted as a todolistVC)
        let destinationVC = segue.destination as! TodDoListViewController
        //use this to access a variable inside the todolistVC code
        //pass this variable the category object selected
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]

        }
    }
    
    
    //MARK - Data Manipulation Methods
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        
        //Item.fetchRequest() is the default request, if no data is passed in
        //"with" is external variable, "response" is internal param
        //must specify data type of output of this method
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from persistent data")
        }
        tableView.reloadData()
        
    }

    
    func saveCategories() {
        //save categories into Core Data into categoryArray
        //context is set up when the CategoryViewController is initialised
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
    
    //MARK - Add New Categories
    
    

    
}
