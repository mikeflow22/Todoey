//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Michael Flowers on 12/10/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController , UISearchBarDelegate {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            //is going to happen as soon as selected category is loaded with a value or it is not nil
            loadItems()
        }
    }
    

    //create your own data file path to save locally
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySearchBar.delegate = self
        
        print(dataFilePath)
        
//        loadItems()
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button
            print("success")
            print(textField.text!)
            
            guard let text = textField.text, !text.isEmpty else { return }
            
            if let currentCategory = self.selectedCategory {
                do {
                    //CRATE NEW OBJECT
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = text
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items: \(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        //Read function for core data
//        //We have to explicitly state what model/object we want to fetch inside the angle brackets
//        let CategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = CategoryPredicate
//        }
//
//        do {
//            items = try context.fetch(request)
//
//        } catch {
//            print("\(error.localizedDescription)")
//        }
        tableView.reloadData()
    }
    
//    func saveItems(){
//        //new way to save with coredata
//
//        do{
//           try context.save()
//        } catch {
//            print("\(error.localizedDescription)")
//        }
//        self.tableView.reloadData()
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let dataModel = todoItems?[indexPath.row] {
            cell.textLabel?.text = dataModel.title
            
            cell.accessoryType = dataModel.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        //        if dataModel.isDone == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        //The above can be refactored into a ternary operator value = condition ? true : false
        
        return cell
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //USING REALM
        //checking to see if toDoItams is not nil
        if let item = todoItems?[indexPath.row] { //
            do {
                try realm.write { //updates our database
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error saving done status: \(error.localizedDescription)")
            }
        }
        tableView.reloadData()
        
        //this will make the cell's background color turn back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    Mark: - SEARCH BAR DELEGATE METHODS
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

