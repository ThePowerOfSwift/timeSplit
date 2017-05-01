//
//  AccountCell.swift
//  timeSplit
//
//  Created by Cory Billeaud on 4/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class AccountCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
//    static func size(for parentWidth: CGFloat) -> CGSize {
//        
//        let numberOfCells = CGFloat(2)
//        let width = parentWidth / numberOfCells
//        return CGSize(width: width, height: width * 2)
//        
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(account: Account) {
        nameLabel.text = account.name
//        profileImage.download(image: account.profileImage?.fullPath() ?? "")
    }
    
    
    
}
