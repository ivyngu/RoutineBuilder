//
//  NewRoutineItemAlert.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/19/21.
//

import UIKit

protocol NewRoutineItemAlertDelegate: AnyObject {
    func itemCreated(name: String, minutes: Int16, seconds: Int16)
    func alertCancel()
}

class NewRoutineItemAlertViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var durationPicker: UIPickerView!
    
    var delegate: NewRoutineItemAlertDelegate?
    
    var minutes = Array(0...120)
    var seconds = Array(0...60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        durationPicker.delegate = self
        durationPicker.dataSource = self
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveNewItem), for: .touchUpInside)
    }
        
    @objc func cancel() {
        delegate?.alertCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
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
