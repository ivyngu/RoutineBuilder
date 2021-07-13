//
//  RoutineListViewController.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/12/21.
//

import UIKit

class RoutineListViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapButtonOne() {
        let vc = RoutineTableViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func didTapButtonTwo() {
        let vc = RoutineTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
