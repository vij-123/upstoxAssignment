//
//  FilterCollectionViewCell.swift
//  Assignment
//
//  Created by bleak on 01/03/24.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var filterLabel: UILabel!

    func configureUI(data: BottomFilterDataModel) {
        filterStackView.layer.cornerRadius = 15
        filterStackView.clipsToBounds = true
        filterStackView.backgroundColor = UIColor.lightGray
        
        if data.isSelected {
            checkmarkImageView.isHidden = false
        } else {
            checkmarkImageView.isHidden = true
        }
    }
    
    

}
