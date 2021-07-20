//
//  RoutineListViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/12/21.
//

import UIKit

class RoutineListTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var routinesCreated = [OneRoutine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationController?.title = "My Routines"
    }
    
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routinesCreated.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routineCreated = routinesCreated[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = routineCreated.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRoutine = routinesCreated[sourceIndexPath.row]
        routinesCreated.remove(at: sourceIndexPath.row)
        routinesCreated.insert(movedRoutine, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = routinesCreated[indexPath.row]
        if (editingStyle == .delete) {
            routinesCreated.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteRoutine(item: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = routinesCreated[indexPath.row]
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(identifier: "RoutineViewController") as! RoutineViewController
        let vc = RoutineTableViewController()
        vc.routine = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAllItems() {
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
    
    func createRoutine(name: String) {
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
    
    func deleteRoutine(item: OneRoutine) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        }
        catch let err {
            print(err)
        }
    }
    
    func updateRoutine(item: OneRoutine, newName: String) {
        item.name = newName
        do {
            try context.save()
            getAllItems()
        }
        catch let err {
            print(err)
        }
    }

}
