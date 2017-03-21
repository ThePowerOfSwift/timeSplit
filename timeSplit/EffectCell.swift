//
//  EffectCell.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class EffectCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var effectedDateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var submittedByLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentsNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(effect: Effect) {
        nameLabel.text = effect.name
        categoryLabel.text = effect.category
        effectedDateLabel.text = effect.effectedDate
        descLabel.text = effect.desc
        submittedByLabel.text = effect.submittedBy
        likeLabel.text = "\(effect.likes!)"
        
        commentsNumberLabel.text = "\(effect.commentNumber!)"
    }
}
