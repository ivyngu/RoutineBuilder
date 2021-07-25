//
//  RoutineTableViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/17/21.
//

import UIKit
import CoreData
import Foundation

class RoutineTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var routineItems = [RoutineItem]()
    var routine: OneRoutine? {
        didSet {
            self.navigationItem.title = routine?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.navigationItem.rightBarButtonItems = [self.editButtonItem, UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))]
    }
    
    private func setTimerButton() {
        if routineItems.count > 0 {
            let startButton = UIBarButtonItem(title: "Start Timer", style: .plain, target: self, action: #selector(showTimer))
            toolbarItems = [startButton]
            self.navigationController?.isToolbarHidden = false
        }
    }
    
    @objc func showTimer() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TimerViewController") as! TimerViewController
        vc.routine = routine
        present(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routineItem = routineItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(routineItem.name ?? "Item")" + ", " + "\(routineItem.durationMinutes)" + ":" + setSecondsTimerFormat(routineItem: routineItem)
        return cell
    }
    
    private func setSecondsTimerFormat(routineItem: RoutineItem) -> String {
        if routineItem.durationSeconds < 10 {
             return "0" + "\(routineItem.durationSeconds)"
        } else {
            return "\(routineItem.durationSeconds)"
        }
    }
      
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = routineItems[sourceIndexPath.row]
        routineItems.remove(at: sourceIndexPath.row)
        routineItems.insert(movedItem, at: destinationIndexPath.row)
        updateIndex()
    }
      
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = routineItems[indexPath.row]
        if (editingStyle == .delete) {
            routineItems.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteItem(item: item)
        }
    }
      
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = routineItems[indexPath.row]
        let sheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        /*
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let vc = storyboard.instantiateViewController(identifier: "NewRoutineItemAlertViewController") as! NewRoutineItemAlertViewController
            vc.routineItem = item
            self.navigationController?.pushViewController(vc, animated: true)
        }))
 */
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
      
    func createItem(name: String, durationMinutes: Int16, durationSeconds: Int16) {
        let newRoutineItem = RoutineItem(context: context)
        newRoutineItem.name = name
        newRoutineItem.durationMinutes = durationMinutes
        newRoutineItem.durationSeconds = durationSeconds
        routine?.addToHasRoutineItems(newRoutineItem)
        newRoutineItem.index = Int16(routineItems.count)
        do {
            try context.save()
            getAllItems()
        }
        catch let err {
            print(err)
        }
        setTimerButton()
    }
    
    func getAllItems() {
        routineItems = routine?.hasRoutineItems?.allObjects as? [RoutineItem] ?? []
        routineItems.sort {
            $0.index < $1.index
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func deleteItem(item: RoutineItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        }
        catch let err {
            print(err)
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
        catch let err {
            print(err)
        }
    }
    
    func updateIndex() {
        for (i, item) in zip(0..., routineItems) {
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

extension RoutineTableViewController: NewRoutineItemAlertDelegate {
    
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
