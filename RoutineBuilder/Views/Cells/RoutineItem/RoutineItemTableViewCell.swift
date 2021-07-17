//
//  RoutineItemTableViewCell.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/17/21.
//

import UIKit

class RoutineItemTableViewCell: UITableViewCell {

    @IBOutlet var routineLabel: UILabel!
    
    static let identifier = "RoutineItemTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RoutineItemTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
