//
//  SubApplyHistoryTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/05.
//

import UIKit


class SubApplyHistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet var labNamelabel: UILabel!
    @IBOutlet var labImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labImageView.layer.cornerRadius = labImageView.bounds.width/2.0
        labImageView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
