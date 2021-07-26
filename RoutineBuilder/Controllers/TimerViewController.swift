//
//  TimerViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/14/21.
//
//  Description: View Controller for timer of each OneRoutine consisting of RoutineItems.

import UIKit

class TimerViewController: UIViewController {
    
    // Set variables for storyboard outlets.
    @IBOutlet var countdownSecondsLabel: UILabel!
    @IBOutlet var countdownMinutesLabel: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var activeButton: UIButton!
       
    // Attain context from CoreData and grab all RoutineItems created for a specific OneRoutine.
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var routineItems = [RoutineItem]()
    var routine: OneRoutine?

    // Set variables for keeping track of timer and how far along in routine user is.
    private var index = 0
    private var secondsRemaining: Int16 = 0
    private var minutesRemaining: Int16 = 0
    private var timer: Timer!
    private var timerOn: Bool = false

    // Launch initial view when loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        loadTimer()
    }
       
    // Sets initial view of Timer.
    private func loadTimer() {
        minutesRemaining = routineItems[index].durationMinutes
        secondsRemaining = routineItems[index].durationSeconds
        setTimerDurationFormat()
        activityLabel.text = routineItems[index].name
        activeButton.setTitle("Start", for: .normal)
    }
    
    // For formatting seconds for timer.
    private func setTimerDurationFormat() {
        if secondsRemaining < 10 {
            countdownSecondsLabel.text = "0" + "\(secondsRemaining)"
        } else {
            countdownSecondsLabel.text = "\(secondsRemaining)"
        }
        countdownMinutesLabel.text = "\(minutesRemaining)"
    }
    
    // Action when user presses Start button for timer.
    @IBAction func playButtonTapped(_ sender: Any) {
        // If the timer isn't already on, set button title to pause & start timer.
        // Otherwise, if it's already on, user wants to pause and timer needs to invalidate.
        if !timerOn {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
            activeButton.setTitle("Pause", for: .normal)
        } else {
            timer.invalidate()
            activeButton.setTitle("Start", for: .normal)
        }
        timerOn.toggle()
    }
       
    // For keeping track of where user is in their routine. Keep increasing index until they reach the end of it.
    private func increaseIndex() {
        if (index < routineItems.count) {
            index += 1
        }
    }
     
    // Timer settings
    @objc func step() {
        // For counting down
        if minutesRemaining > 0 || secondsRemaining > 0 {
            secondsRemaining -= 1
            if (secondsRemaining == -1) {
                secondsRemaining = 59
                minutesRemaining -= 1
            }
        } else {
            timer.invalidate()
            // If reach the end of the routine then congratulate user
            if index == routineItems.count - 1 {
                let congratsAlert = UIAlertController(title: "Congrats!", message: "You finished your routine. Amazing work!", preferredStyle: .alert)
                congratsAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {_ in
                    self.storyboard?.instantiateInitialViewController()
                }))
                present(congratsAlert, animated: true)
            } else {
                // Continue with routine
                increaseIndex()
                minutesRemaining = routineItems[index].durationMinutes
                secondsRemaining = routineItems[index].durationSeconds
                activityLabel.text = routineItems[index].name
                activeButton.setTitle("Start", for: .normal)
                timerOn.toggle()
            }
        }
        setTimerDurationFormat()
    }
       
    // Retrieves all RoutineItems within a OneRoutine in CoreData context & sorts them by index.
    func getAllItems() {
        routineItems = routine?.hasRoutineItems?.allObjects as? [RoutineItem] ?? []
        routineItems.sort {
            $0.index < $1.index
        }
    }
}
