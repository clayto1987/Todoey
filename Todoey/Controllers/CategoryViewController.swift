//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Clayton Wallace on 2018-06-10.
//  Copyright © 2018 Clayton Wallace. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    let colorsToExclude = [UIColor.flatGrayDark, UIColor.flatGray, UIColor.flatWhite, UIColor.flatWhiteDark, UIColor.flatBlack, UIColor.flatBlackDark, UIColor.flatSand, UIColor.flatSandDark]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if categories is not nil return count but if it is nil return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
        
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        } else {
            cell.textLabel?.text = "No Categories Added Yet"
        }

        return cell
    }
    
    //MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let textEntry = textField.text {
                let newCategory = Category()
                newCategory.name = textEntry
                newCategory.color = UIColor.randomFlat.hexValue()
                self.save(category: newCategory)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Error deleting the category, \(error)")
            }
        }
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
