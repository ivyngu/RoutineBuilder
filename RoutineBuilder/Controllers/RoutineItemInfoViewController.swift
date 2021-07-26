//
//  RoutineItemInfoViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/21/21.
//

import UIKit

protocol RoutineItemInfoDelegate: AnyObject {
    func itemUpdated(item: RoutineItem, name: String, minutes: Int16, seconds: Int16)
    func alertCancel()
}

class RoutineItemInfoViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var secondsField: UITextField!
    @IBOutlet weak var minutesField: UITextField!
    
    let minutePicker = UIPickerView()
    let secondPicker = UIPickerView()
    
    var delegate: RoutineItemInfoDelegate?
        
    var minutes = Array(0...120)
    var seconds = Array(0...60)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var routineItem: RoutineItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialFields()
        assignPickerSettings()
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(updateOldItem), for: .touchUpInside)
    }
    
    private func setInitialFields() {
        nameField.text = routineItem?.name
        minutesField.text = "\(routineItem?.durationMinutes ?? 0)"
        secondsField.text = "\(routineItem?.durationSeconds ?? 0)"
    }
    
    private func assignPickerSettings() {
        minutePicker.tag = 0
        secondPicker.tag = 1
        secondsField.inputView = secondPicker
        minutesField.inputView = minutePicker
        minutePicker.delegate = self
        secondPicker.delegate = self
    }
    
    @objc func cancel() {
        delegate?.alertCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
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
