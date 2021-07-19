//
//  RoutineViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/17/21.
//

import UIKit


class RoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var startButton: UIButton!
    
    private var routineItems = [RoutineItem]()
    // private var routine: OneRoutine
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        tableView.register(RoutineItemTableViewCell.nib(), forCellReuseIdentifier: RoutineItemTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItems = [self.editButtonItem, UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))]
        // self.navigationItem.title = routine.name
    }
    
    @IBAction func startRoutineButtonTapped() {
        navigationController?.pushViewController(TimerViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routineItem = routineItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineItemTableViewCell.identifier, for: indexPath) as! RoutineItemTableViewCell
        cell.routineLabel.text = routineItem.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = routineItems[sourceIndexPath.row]
        routineItems.remove(at: sourceIndexPath.row)
        routineItems.insert(movedItem, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = routineItems[indexPath.row]
        if (editingStyle == .delete) {
            routineItems.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteItem(item: item)
        }
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = routineItems[indexPath.row]
        let sheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addTextField(configurationHandler: nil)
            alert.textFields?[1].text = String(item.duration)
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName, newDuration: 4)
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
 */
    
    func createItem(name: String, durationMinutes: Int16, durationSeconds: Int16) {
        let newRoutineItem = RoutineItem(context: context)
        newRoutineItem.name = name
        newRoutineItem.durationMinutes = durationMinutes
        newRoutineItem.durationSeconds = durationSeconds
        //newRoutineItem.belongsToRoutine = routine
        //routine.addToHasRoutineItems(newRoutineItem)
        do {
            try context.save()
            getAllItems()
        }
        catch {
        }
    }
    
    func getAllItems() {
        do {
            routineItems = try context.fetch(RoutineItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
        }
    }
    
    func deleteItem(item: RoutineItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func updateItem(item: RoutineItem, newName: String, newDurationMinutes: Int16, newDurationSeconds: Int16) {
        item.name = newName
        item.durationMinutes = newDurationMinutes
        item.durationSeconds = newDurationSeconds
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
}

extension RoutineViewController: NewRoutineItemAlertDelegate {
    
    @objc func didTapAdd() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alert = storyboard.instantiateViewController(identifier: "NewRoutineItemAlert") as! NewRoutineItemAlertViewController
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.delegate = self
        present(alert, animated: true, completion: nil)
    }
    
    func alertCancel() {
        storyboard?.instantiateInitialViewController()
    }
    
    func itemCreated(name: String, minutes: Int16, seconds: Int16) {
        self.createItem(name: name, durationMinutes: minutes, durationSeconds: seconds)
    }
}
