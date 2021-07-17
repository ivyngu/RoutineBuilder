//
//  RoutineTableViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/17/21.
//

import UIKit

class RoutineTableViewController: UITableViewController {
    
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      private var routineItems = [RoutineItem]()
      private var routine: OneRoutine
      
      init(routine: OneRoutine) {
          self.routine = routine
          super.init(nibName: nil, bundle: nil)
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      override func viewDidLoad() {
          super.viewDidLoad()
          getAllItems()
          tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
          self.navigationItem.rightBarButtonItems = [self.editButtonItem, UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))]
          self.navigationItem.title = routine.name
          
      }
      
      @objc private func didTapAdd() {
          let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
          alert.addTextField { (textField) in
                      textField.placeholder = "Item Name"
                  }
          alert.addTextField { (textField) in
              textField.placeholder = "Duration"
          }
          let submitAction = UIAlertAction(title: "Submit", style: .cancel, handler: { [weak alert] _ in
              guard let textFields = alert?.textFields else {
                  return
              }
              if let nameText = textFields[0].text,
                 let durationText = textFields[1].text {
                  self.createItem(name: nameText, duration: Int16(durationText)!)
      }})
          alert.addAction(submitAction)
          present(alert, animated: true)
      }

      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return routineItems.count
      }

      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let routineItem = routineItems[indexPath.row]
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          cell.textLabel?.text = routineItem.name
          return cell
      }
      
      override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
          let movedItem = routineItems[sourceIndexPath.row]
          routineItems.remove(at: sourceIndexPath.row)
          routineItems.insert(movedItem, at: destinationIndexPath.row)
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
      
      func createItem(name: String, duration: Int16) {
          let newRoutineItem = RoutineItem(context: context)
          newRoutineItem.name = name
          newRoutineItem.duration = duration
          newRoutineItem.belongsToRoutine = routine
          // routine.addToHasRoutineItems(newRoutineItem)
          do {
              try context.save()
              getAllItems()
          }
          catch {
              newRoutineItem.duration = 0
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
      
      func updateItem(item: RoutineItem, newName: String, newDuration: Int16) {
          item.name = newName
          item.duration = newDuration
          do {
              try context.save()
              getAllItems()
          }
          catch {
              
          }
      }

}
