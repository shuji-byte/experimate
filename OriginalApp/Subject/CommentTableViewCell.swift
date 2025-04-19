//
//  CommentTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/19.
//

import UIKit



class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var commentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // プロフを丸くする
        userImageView.layer.cornerRadius = userImageView.bounds.width/2.0
        userImageView.clipsToBounds = true
        

//        テキストビュー
        //コメント
        commentTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        commentTextView.layer.borderWidth = 1.0
        
        commentTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
