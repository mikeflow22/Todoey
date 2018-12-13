//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Michael Flowers on 12/11/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm() //initalized new access point to our database
    var categories : Results<Category>? //collection of "Results"
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() //retrieve all pevious saved objects
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //add Category to tableView
    let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        var myTextField = UITextField()
    
        let addAction = UIAlertAction(title: "Enter Category", style: .default) { (_) in
            guard let text = myTextField.text, !text.isEmpty else { return }
            
            //Create Category Object
            let newCategory = Category()
            newCategory.name = text
            self.save(category: newCategory)
        }
        
        //add textfield
        alert.addTextField { (textField) in
            textField.placeholder = "Category goes here."
            myTextField = textField
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet."
        return cell
    }
    
    
    //MARK: - C.R.U.D. Functions
    
    func save(category: Category){
        //Try to save it to the persistent storage
        do {
            try realm.write { //commit changes to database
               realm.add(category) // add changes to database
            }
        } catch  {
            print("Error saving to persistent storage: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
       categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue to items list
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        
        //grab the cateogry model object information
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
