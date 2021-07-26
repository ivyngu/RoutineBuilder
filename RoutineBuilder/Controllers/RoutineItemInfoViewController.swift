//
//  RoutineItemInfoViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/21/21.
//

import UIKit

// For implementing RoutineItemInfoViewController class.
protocol RoutineItemInfoDelegate: AnyObject {
    func itemUpdated(item: RoutineItem, name: String, minutes: Int16, seconds: Int16)
    func alertCancel()
}

// View Controller for RoutineItemInfo when user updates RoutineItem for a specific OneRoutine.
class RoutineItemInfoViewController: UIViewController {

    // Set variables for storyboard outlet.
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var secondsField: UITextField!
    @IBOutlet weak var minutesField: UITextField!
    let minutePicker = UIPickerView()
    let secondPicker = UIPickerView()
    
    // Declare delegate for calling & separating actions.
    var delegate: RoutineItemInfoDelegate?
      
    // Set variables for pickerView.
    var minutes = Array(0...120)
    var seconds = Array(0...60)
    
    // Launches initial view after loading.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var routineItem: RoutineItem?
    
    // Launches initial view after loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialFields()
        assignPickerSettings()
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(updateOldItem), for: .touchUpInside)
    }
    
    // Initial settings for fields (old durations for RoutineItem).
    private func setInitialFields() {
        nameField.text = routineItem?.name
        minutesField.text = "\(routineItem?.durationMinutes ?? 0)"
        secondsField.text = "\(routineItem?.durationSeconds ?? 0)"
    }
    
    // Properties for pickerViews.
    private func assignPickerSettings() {
        minutePicker.tag = 0
        secondPicker.tag = 1
        secondsField.inputView = secondPicker
        minutesField.inputView = minutePicker
        minutePicker.delegate = self
        secondPicker.delegate = self
    }
    
    // When user presses cancel button, dismiss the view.
    @objc func cancel() {
        delegate?.alertCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    // When user updates item, use the selected durations in pickerView & name in textfield to update RoutineItem.
    @objc func updateOldItem() {
        delegate?.itemUpdated(item: routineItem ?? RoutineItem(), name: nameField.text ?? "Item", minutes: Int16(minutes[minutePicker.selectedRow(inComponent: 0)]), seconds: Int16(seconds[secondPicker.selectedRow(inComponent: 0)]))
        self.dismiss(animated: true, completion: nil)
    }
}

extension RoutineItemInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            if component == 0 {
                return minutes.count
            } else if component == 1 {
                return 1
            }
        }
        if pickerView.tag == 1 {
            if component == 0 {
                return seconds.count
            } else if component == 1 {
                return 1
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            if component == 0 {
                //minutesField.text = String(minutes[row])
                return String(minutes[row])
            } else if component == 1 {
                return "m"
            }
        }
        if pickerView.tag == 1 {
            if component == 0 {
                //secondsField.text = String(seconds[row])
                return String(seconds[row])
            } else if component == 1 {
                return "s"
            }
        }
        return ""
    }
}
