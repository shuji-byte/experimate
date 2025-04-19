//
//  SubTimeLineTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/03.
//

import UIKit
import NCMB


protocol SubTimeLineTableViewCellDelegate {
    func didTapToApply(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton)
    func didTapName(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton)
    func didTapToComment(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton)
}

class SubTimeLineTableViewCell: UITableViewCell {
    
    var delegate: SubTimeLineTableViewCellDelegate?
    
    
    @IBOutlet var toDetailButton: UIButton!
    @IBOutlet var labNameLabel: UILabel!
    @IBOutlet var labImageView: UIImageView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var summaryTextView: UITextView!
    @IBOutlet var requirementTextView: UITextView!
    @IBOutlet var rewardTextView: UITextView!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var toApplyButton: UIButton!
    @IBOutlet var toCommentButton: UIButton!
    
    @IBOutlet var experimentLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var requirementLabel: UILabel!
    @IBOutlet var rewardLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        labImageView.layer.cornerRadius = labImageView.bounds.width/2.0
        labImageView.clipsToBounds = true
        
//        ボタン
        //詳細ボタン
        toDetailButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        toDetailButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        toDetailButton.layer.cornerRadius = 10
        
        toDetailButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        toDetailButton.layer.borderWidth = 2.0
        
        toDetailButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor

        //コメントボタン
        toCommentButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        toCommentButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        toCommentButton.layer.cornerRadius = 10
        
        toCommentButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        toCommentButton.layer.borderWidth = 2.0
        
        toCommentButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        
        //応募ボタン
        toApplyButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        toApplyButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        toApplyButton.layer.cornerRadius = 10
        
        toApplyButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        toApplyButton.layer.borderWidth = 2.0
        
        toApplyButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        

//        ラベル
        //実験タイトルラベル
      /*  experimentLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        experimentLabel.layer.borderWidth = 1.0
        
        //概要ラベル
        summaryLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        summaryLabel.layer.borderWidth = 1.0
        //条件ラベル
        requirementLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        requirementLabel.layer.borderWidth = 1.0
        //報酬ラベル
        rewardLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        rewardLabel.layer.borderWidth = 1.0
        */
//        テキストビュー
        //実験タイトル
        titleTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        titleTextView.layer.borderWidth = 1.0
        
        titleTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        
        //概要
        summaryTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        summaryTextView.layer.borderWidth = 1.0
        
        summaryTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        
        //条件
        requirementTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        requirementTextView.layer.borderWidth = 1.0
        
        requirementTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        
        //報酬
        rewardTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        rewardTextView.layer.borderWidth = 1.0
        
        rewardTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapToApply(button: UIButton) {
        self.delegate?.didTapToApply(targetCell: self, targetButton: button)
    }
    
    @IBAction func didTapName(button: UIButton) {
        self.delegate?.didTapName(targetCell: self, targetButton: button)
    }
    
    @IBAction func didTapToComment(button: UIButton) {
        self.delegate?.didTapToComment(targetCell: self, targetButton: button)
    }
    
}
