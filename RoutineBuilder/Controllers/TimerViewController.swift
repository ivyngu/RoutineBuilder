//
//  TimerViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/14/21.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var activeButton: UIButton!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var routineItems = [RoutineItem]()

    private var timeRemaining: Int16 = 0
    private var timer: Timer!
    private var index = 0
    private var timerOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        loadTimer()
    }
    
    func loadTimer() {
        timeRemaining = routineItems[index].duration
        countdownLabel.text = String(routineItems[index].duration)
        activityLabel.text = routineItems[index].name
        activeButton.setTitle("Start", for: .normal)
        print(index)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if !timerOn {
            print(index)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
            activeButton.setTitle("Pause", for: .normal)
        } else {
            print(index)
            timer.invalidate()
            activeButton.setTitle("Start", for: .normal)
            increaseIndex()
        }
        timerOn.toggle()
    }
    
    func increaseIndex() -> Int {
        if (index < routineItems.count) {
            index += 1
            return index
        }
        return routineItems.count
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else if increaseIndex() == routineItems.count {
            timer.invalidate()
            let congratsAlert = UIAlertController(title: "Congrats!", message: "You finished your routine. Amazing work!", preferredStyle: .alert)
            congratsAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {_ in
                self.navigationController?.pushViewController(RoutineListTableViewController(), animated: true)
            }))
            present(congratsAlert, animated: true)
        }
        else {
            timer.invalidate()
            timeRemaining = routineItems[index].duration
            activityLabel.text = routineItems[index].name
            activeButton.setTitle("Start", for: .normal)
            timerOn.toggle()
        }
        countdownLabel.text = "\(timeRemaining)"
    }
    
    func getAllItems() {
        do {
            routineItems = try context.fetch(RoutineItem.fetchRequest())
            DispatchQueue.main.async {
            }
        }
        catch {
            //error
        }
    }
}
