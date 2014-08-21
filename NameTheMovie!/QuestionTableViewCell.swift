//
//  QuestionTableViewCell.swift
//  NameTheMovie!
//
//  Created by Jeff Gayle on 8/21/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shownQuestionLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
