//
//  LabCommentViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/09/10.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD

class LabCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var comments = [NCMBObject]()
    var postId: String!
    @IBOutlet var labcommentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        labcommentTableView.dataSource = self
        labcommentTableView.delegate = self
        labcommentTableView.rowHeight = 150
        
        let nib = UINib(nibName: "LabCommentTableViewCell", bundle: Bundle.main)
        labcommentTableView.register(nib, forCellReuseIdentifier: "labcommenttableviewcell")
        labcommentTableView.tableFooterView = UIView()
        
        loadComments()
        
        //        区切り線の色
        labcommentTableView.separatorColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labcommenttableviewcell") as! LabCommentTableViewCell
        
        cell.tag = indexPath.row
        let user = comments[indexPath.row].object(forKey: "user") as! NCMBUser
        let appId = "GwSh1j3QNUt73MyB"
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/" + appId + "/publicFiles/" + user.objectId
        // ユーザー画像の設定
        cell.labuserImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(systemName: "person"),options: nil,progressBlock: nil)
        cell.labuserNameLabel.text = user.object(forKey: "displayName") as! String
        cell.labcommentTextView.text = comments[indexPath.row].object(forKey: "text") as! String
        
        cell.labuserImageView.layer.cornerRadius = cell.labuserImageView.bounds.width/2.0
        cell.labuserImageView.clipsToBounds = true
        
        //コメント
        cell.labcommentTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        cell.labcommentTextView.layer.borderWidth = 1.0
        
        cell.labcommentTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        return cell
    }
    
    // コメントロード
        func loadComments() {
            comments = [NCMBObject]()
            HUD.show(.progress, onView: self.view)
            
            let query = NCMBQuery(className: "Comment")
            query?.whereKey("postId", equalTo: postId)
            query?.includeKey("user")
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    HUD.hide(animated: true)
                } else {
                    HUD.hide(animated: true)
                    
                    for commentObject in result as! [NCMBObject] {
    //                    コメントの文字を取得
                        let text = commentObject.object(forKey: "text") as! String
                        self.comments.append(commentObject)
                        
    //                    テーブルをリロード
                        self.labcommentTableView.reloadData()
                    }
                }
            })
        }
    
    //    コメント追加
        @IBAction func addComment() {
            let alert = UIAlertController(title: "コメント", message: "コメントを入力して下さい", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        HUD.show(.progress, onView: self.view)
                        // コメント情報をCommentテーブルにセットする
                        let object = NCMBObject(className: "Comment")
                        object?.setObject(self.postId, forKey: "postId")
                        object?.setObject(NCMBUser.current(), forKey: "user")
                        object?.setObject(alert.textFields?.first?.text, forKey: "text")
                        object?.saveInBackground({ (error) in
                            if error != nil {
                                print(error)
                                HUD.hide(animated: true)
                            } else {
                                HUD.hide(animated: true)
                                self.loadComments()
                            }
                        })
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    // アラートアクションシートに文字入力欄も追加できる
                    alert.addTextField { (textField) in
                        textField.placeholder = "ここにコメントを入力"
                    }
                    self.present(alert, animated: true, completion: nil)
                
            }
    

}
