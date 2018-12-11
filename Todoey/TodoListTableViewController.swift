//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Michael Flowers on 12/10/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var items = [ Item ]()
    
    //create your own data file path to save locally
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
//        let newItem = Item(title: "Find Mike", isDone: false)
//        items.append(newItem)
//        let newItem1 = Item(title: "Find Heather", isDone: false)
//        items.append(newItem1)
//        let newItem2 = Item(title: "Find Paul", isDone: false)
//        items.append(newItem2)
//        let newItem3 = Item(title: "Find Samantha", isDone: false)
//        items.append(newItem3)
        
        loadItems()
        
//        if let itemsArray = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            items = itemsArray
//        }
    }
    
    func loadItems(){
        //decode our data
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            items = try decoder.decode([Item].self, from: data)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button
            print("success")
            print(textField.text)
            
            guard let text = textField.text, !text.isEmpty else { return }
            let newItem = Item(title: text)
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
    
    func saveItems(){
        //new way to save without using userdefaults
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(items)
            try data.write(to:dataFilePath!)
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
        //        print(items[indexPath.row])
        //toggle the checkmark or the isDone
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        saveItems()
        
        //        //we want to add a checkmark to the row that was selected and when it is selected twice to remove said checkmark
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        //once pressed we have to reload the tableview in order to see the checkmark
//        tableView.reloadData()
        
        //this will make the cell's background color turn back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
