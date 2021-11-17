//
//  StarCollectionViewCell.swift
//  Diary
//
//  Created by 장기화 on 2021/11/14.
//

import UIKit

class StarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
