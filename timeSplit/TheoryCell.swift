//
//  TheoryCell.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/16/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class TheoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var commentsNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(theory: Theory) {
        titleLabel.text = theory.title
        descLabel.text = theory.description
        createdBy.text = theory.createdBy
        
        commentsNumberLabel.text = "\(theory.commentNumber!)"
    }
}
