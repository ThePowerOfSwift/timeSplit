//
//  CommentCell.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var commentByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(comment: EffectComment) {
        titleLabel.text = comment.title
        commentTextLabel.text = comment.text
        commentByLabel.text = comment.commentBy
    }
}
