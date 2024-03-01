//
//  CryptocurrencyTableViewCell.swift
//  Assignment
//
//  Created by bleak on 29/02/24.
//

import UIKit

class CryptocurrencyTableViewCell: UITableViewCell {

    static let identifier = "CryptocurrencyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CryptocurrencyTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var coinTypeView: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUI(data: CryptocurrencyViewModel.Cryptocurrency) {
        coinNameLabel?.text = "\(data.name)"
        symbolLabel?.text = data.symbol
        
        if data.isNew {
            coinTypeView?.image = UIImage(named: "new")
        } else {
            coinTypeView.image = nil
        }
        
        if data.isActive != true {
            customImageView?.image = UIImage(named: "inactive")
        } else {
            if data.type == "token" {
                customImageView?.image = UIImage(named: "token")
            } else {
                customImageView?.image = UIImage(named: "coin")
            }
        }
    }
    
}
