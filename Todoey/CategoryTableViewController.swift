//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Michael Flowers on 12/11/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categories = [ Category ]()
    
    //get the context singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //add Category to tableView
    let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        var myTextField = UITextField()
    
        let addAction = UIAlertAction(title: "Enter Category", style: .default) { (_) in
            guard let text = myTextField.text, !text.isEmpty else { return }
            
            //Create Category Object
            let newCategory = Category(context: self.context)
            newCategory.name = text
            self.categories.append(newCategory)
            self.saveCategories()
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
        return categories.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    
    //MARK: - C.R.U.D. Functions
    
    func saveCategories(){
        //Try to save it to the persistent storage
        do {
            try context.save()
        } catch  {
            print("Error saving to persistent storage: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        //Read data from context
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            //put the fetched results in the array
           categories = try context.fetch(request)
        } catch  {
            print("Error fetching categories: \(error.localizedDescription)")
        }
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
}
