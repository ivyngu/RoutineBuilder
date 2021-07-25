//
//  RoutineListViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/12/21.
//
//  Description: View Controller for assembling list of routines created of type OneRoutine.

import UIKit
import CoreData

class RoutineListTableViewController: UITableViewController {
    
    // Attain context from CoreData and grab all OneRoutine items created.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var routinesCreated = [OneRoutine]()
    
    // Load initial view after launching.
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationController?.title = "My Routines"
    }
    
    // For adding a new routine to the list of OneRoutines.
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Create New Routine", message: "Enter routine name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createRoutine(name: text)
        }))
        present(alert, animated: true)
    }

    // Set number of items in table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routinesCreated.count
    }
    
    // Assign each cell to a OneRoutine item.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routineCreated = routinesCreated[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = routineCreated.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // For reordering OneRoutine items in editing mode.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRoutine = routinesCreated[sourceIndexPath.row]
        routinesCreated.remove(at: sourceIndexPath.row)
        routinesCreated.insert(movedRoutine, at: destinationIndexPath.row)
        updateIndex()
    }
    
    // For deleting OneRoutine items in editing mode.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = routinesCreated[indexPath.row]
        if (editingStyle == .delete) {
            routinesCreated.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteRoutine(item: item)
        }
    }
    
    // When selecting a OneRoutine item, show options of deleting it and changing its info.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = routinesCreated[indexPath.row]
        let vc = RoutineTableViewController()
        vc.routine = item
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Get all OneRoutine items created from CoreData context.
    private func getAllItems() {
        do {
            routinesCreated = try context.fetch(OneRoutine.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch let err {
            print(err)
        }
    }
    
    // Create a OneRoutine in CoreData.
    private func createRoutine(name: String) {
        let newRoutine = OneRoutine(context: context)
        newRoutine.name = name
        do {
            try context.save()
            getAllItems()
        }
        catch let err {
            print(err)
        }
    }
    
    // Delete a OneRoutine in CoreData.
    private func deleteRoutine(item: OneRoutine) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        }
        catch let err {
            print(err)
        }
    }
    
    // Update a OneRoutine in CoreData.
    private func updateRoutine(item: OneRoutine, newName: String) {
        item.name = newName
        do {
            try context.save()
            getAllItems()
        }
        catch let err {
            print(err)
        }
    }
    
    // Update index of OneRoutine in CoreData by looping through all items & reassigning.
    private func updateIndex() {
        for (i, item) in zip(0..., routinesCreated) {
            item.index = Int16(i)
        }
        do {
            try context.save()
        }
        catch let err {
            print(err)
        }
    }
}
