//
//  LabDetailTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/18.
//

import UIKit

class LabDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var labImageView: UIImageView!
    @IBOutlet var labNameLabel: UILabel!
    @IBOutlet var labMailAddressLabel: UILabel!
    @IBOutlet var labIntroductionTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        labImageView.layer.cornerRadius = labImageView.bounds.width/2.0
        labImageView.clipsToBounds = true
        

        //メールアドレス
        labMailAddressLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        labMailAddressLabel.layer.borderWidth = 1.0
        labMailAddressLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        テキストビュー
        labIntroductionTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        labIntroductionTextView.layer.borderWidth = 1.0
        
        labIntroductionTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
