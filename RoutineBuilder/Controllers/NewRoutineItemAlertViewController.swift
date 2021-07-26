//
//  NewRoutineItemAlert.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/19/21.
//

import UIKit

// For implementing NewRoutineItemAlert class.
protocol NewRoutineItemAlertDelegate: AnyObject {
    func itemCreated(name: String, minutes: Int16, seconds: Int16)
    func alertCancel()
}

// View Controller for NewRoutineItemAlert when user creates new RoutineItem for a specific OneRoutine.
class NewRoutineItemAlertViewController: UIViewController {
    
    // Set variables for storyboard outlet.
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var durationPicker: UIPickerView!
    
    // Declare delegate for calling & separating actions.
    var delegate: NewRoutineItemAlertDelegate?
    
    // Set variables for pickerView.
    var minutes = Array(0...120)
    var seconds = Array(0...60)
        
    // Launches initial view after loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        durationPicker.delegate = self
        durationPicker.dataSource = self
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveNewItem), for: .touchUpInside)
    }
        
    // When user presses cancel button, dismiss the view.
    @objc func cancel() {
        delegate?.alertCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    // When user saves new item, use the selected durations in pickerView & name in textfield to create
    // new RoutineItem.
    @objc func saveNewItem() {
        delegate?.itemCreated(name: nameField.text ?? "Item", minutes: Int16(minutes[durationPicker.selectedRow(inComponent: 0)]), seconds: Int16(seconds[durationPicker.selectedRow(inComponent: 2)]))
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewRoutineItemAlertViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutes.count
        } else if component == 1 {
            return 1
        } else if component == 2 {
            return seconds.count
        } else if component == 3 {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(minutes[row])
        } else if component == 1 {
            return "m"
        } else if component == 2 {
            return String(seconds[row])
        } else if component == 3 {
            return "s"
        }
        return ""
    }
}
