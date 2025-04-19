//
//  ConfrimApplyTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/12.
//

import UIKit


protocol ConfirmApplyTableViewCellDelegate {
    func didTapToDetail(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton)
    
}


class ConfirmApplyTableViewCell: UITableViewCell {
    
    
    
    var delegate: ConfirmApplyTableViewCellDelegate?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var toDetailButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width/2.0
       userImageView.clipsToBounds = true
        
        //        ボタン
                //詳細ボタン
        toDetailButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        toDetailButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                
        toDetailButton.layer.cornerRadius = 10
                
                toDetailButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        toDetailButton.layer.borderWidth = 2.0
                
        toDetailButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func confirmApply(button: UIButton) {
        self.delegate?.didTapToDetail(targetCell: self, targetButton: button)
    }
    
    
}
