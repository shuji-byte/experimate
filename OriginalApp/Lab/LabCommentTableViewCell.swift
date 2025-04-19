//
//  LabCommentTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/09/10.
//

import UIKit

class LabCommentTableViewCell: UITableViewCell {
    
    @IBOutlet var labuserNameLabel: UILabel!
    @IBOutlet var labuserImageView: UIImageView!
    @IBOutlet var labcommentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // プロフを丸くする
     /*   labuserImageView.layer.cornerRadius = labuserImageView.bounds.width/2.0
        labuserImageView.clipsToBounds = true
        
        //        テキストビュー
                //コメント
                labcommentTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
                labcommentTextView.layer.borderWidth = 1.0
                
                labcommentTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
