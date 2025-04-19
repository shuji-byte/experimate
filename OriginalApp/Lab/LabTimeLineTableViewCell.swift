//
//  LabTimeLineTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/01.
//

import UIKit
import NCMB

//プロトロコルを設定　他のViewControllerから渡された値を利用
protocol LabTimeLineTableViewCellDelegate {
    func didTapMenuButton(targetCell: UITableViewCell, targetButton: UIButton)
    func didTapToComment(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton)
}

class LabTimeLineTableViewCell: UITableViewCell {
    
    var  delegate: LabTimeLineTableViewCellDelegate?
    var posts = [NCMBObject]()
    
    @IBOutlet weak var summaryHeightConstraint: NSLayoutConstraint!
    @IBOutlet var labNameLabel: UILabel!
    @IBOutlet var labImageView: UIImageView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var summaryTextView: UITextView!
    @IBOutlet var requirementTextView: UITextView!
    @IBOutlet var rewardTextView: UITextView!
    @IBOutlet var timestampLabel: UILabel!
    
    @IBOutlet var toCommentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        プロフィール画像を丸く
        labImageView.layer.cornerRadius = labImageView.bounds.width/2.0
        labImageView.clipsToBounds = true
        
        //コメントボタン
        toCommentButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        toCommentButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        toCommentButton.layer.cornerRadius = 10
        
        toCommentButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        toCommentButton.layer.borderWidth = 2.0
        
        toCommentButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        
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
        
        
        
        /*let jString = [posts]
        
        
        do {
            // テキストをJSONデータに変換
            let jsonData = jsonString.data(using: .utf8)!
            // JSONデータをパース
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: Any]]
            // posts配列内の各JSONオブジェクトからsummaryの内容を取得
            for jsonObject in jsonArray {
                if let summary = jsonObject["summary"] as? String {
                    print("Summary: \(summary)")
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
         */










//        let width = estimateFrameForTextView(text: String(posts[5]))
        // Configure the view for the selected state
    }
    
    @IBAction func openMenu(button: UIButton) {
        self.delegate?.didTapMenuButton(targetCell: self, targetButton: button)
    }
    @IBAction func didTapToComment(button: UIButton) {
        self.delegate?.didTapToComment(targetCell: self, targetButton: button)
    }
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func loadTimeLine() {
        
        let query = NCMBQuery(className: "Post")
        //        日付の降順で取ってくる
        query?.order(byDescending: "createDate")
        //        投稿したユーザー情報も同時取得する
        query?.includeKey("user")
        //        自分の投稿だけを表示
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                //                データの取得がうまくいったらpostsにデータを格納
                for object in result as! [NCMBObject] {
                    let user = object.object(forKey: "user") as! NCMBUser
                    
                    print(user)
                    print(object)
                    
                    //                    postsにデータを移す
                    self.posts.append(object)
                    
                }
            }
        })
        
    }
    

    
}
