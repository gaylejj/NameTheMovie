//
//  AnswerTableViewCell.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/15/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerAnswerLabel: UILabel!
    
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
