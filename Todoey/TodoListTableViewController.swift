//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Michael Flowers on 12/10/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController , UISearchBarDelegate {
    
    var items = [ Item ]()
    var selectedCategory : Category? {
        didSet {
            //is going to happen as soon as selected category is loaded with a value or it is not nil
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //create your own data file path to save locally
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySearchBar.delegate = self
        
        print(dataFilePath)
        
        loadItems()
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button
            print("success")
            print(textField.text!)
            
            guard let text = textField.text, !text.isEmpty else { return }
            
            //CRATE NEW OBJECT
            let newItem = Item(context: self.context)
            newItem.title = text
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.items.append(newItem)
            
            //save updated items to defaults
            //self.defaults.set(self.items, forKey: "ToDoListArray")
           
           self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        //Read function for core data
        //We have to explicitly state what model/object we want to fetch inside the angle brackets
        let CategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, additionalPredicate])
        } else {
            request.predicate = CategoryPredicate
        }
        
        do {
            items = try context.fetch(request)
            
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func saveItems(){
        //new way to save with coredata
        
        do{
           try context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let dataModel = items[indexPath.row]
        cell.textLabel?.text = dataModel.title
        
        
        //        if dataModel.isDone == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        //The above can be refactored into a ternary operator value = condition ? true : false
        cell.accessoryType = dataModel.isDone ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //toggle the checkmark or the isDone
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        
//
//        //delete the nsmanagedObject THIS MUST BE DONE FIRST
//        context.delete(items[indexPath.row])
//
//        //remove/delete object from table NEED TO DO THIS SECOND this removes it from the UI
//        items.remove(at: indexPath.row)
        
        
        saveItems()
        
        //this will make the cell's background color turn back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark: - SEARCH BAR DELEGATE METHODS
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //query our database
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //nspredicate specifies how data should be filtered/searched
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //we can sort the results we get back
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                self.mySearchBar.resignFirstResponder()
            }
            
        }
    }
}

