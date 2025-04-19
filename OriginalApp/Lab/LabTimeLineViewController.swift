//
//  LabTimeLineViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/01.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD


class LabTimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LabTimeLineTableViewCellDelegate {
    
    
    
    var selectedPost: NCMBObject?
    var posts = [NCMBObject]()
    var users = [NCMBObject]()
    @IBOutlet var labTimeLineTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labTimeLineTableView.dataSource = self
        labTimeLineTableView.delegate = self
//        tableViewの高さを700pxにする
        labTimeLineTableView.rowHeight = 720
        
        let nib = UINib(nibName: "LabTimeLineTableViewCell", bundle: Bundle.main)
        labTimeLineTableView.register(nib, forCellReuseIdentifier: "Cell")
        labTimeLineTableView.tableFooterView = UIView()
        
        setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadTimeLine()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toLabComment" {
                let commentViewController = segue.destination as!  LabCommentViewController
                print(selectedPost?.objectId)
                commentViewController.postId = selectedPost?.objectId as! String
            }
        }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! LabTimeLineTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        let user = posts[indexPath.row].object(forKey: "user") as! NCMBUser
        
//        ユーザー名の表示
        if user.object(forKey: "displayName") as! String != "" {
            cell.labNameLabel.text = user.object(forKey: "displayName") as! String
        } else {
            cell.labNameLabel.text = "表示なし"
        }
        
//        ユーザーアイコンの表示のためのURLを作る
        let userObjectId = user.object(forKey: "objectId") as! String
        let appId = "GwSh1j3QNUt73MyB"
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/" + appId + "/publicFiles/" + userObjectId
        
//        ユーザー画像の設定
        cell.labImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(systemName: "person"), options: nil,progressBlock: nil)
        
//        投稿内容の表示
        cell.titleTextView.text = posts[indexPath.row].object(forKey: "title") as! String?
        cell.summaryTextView.text = posts[indexPath.row].object(forKey: "summary") as! String
        cell.requirementTextView.text = posts[indexPath.row].object(forKey: "requirement") as! String
        cell.rewardTextView.text = posts[indexPath.row].object(forKey: "reward") as! String
        
//        日付の表示
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm"
        let date = posts[indexPath.row].createDate as! Date
        cell.timestampLabel.text = df.string(from: date)
        return cell
    }
    
//    選択された時に呼ばれる関数
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedPost = posts[indexPath.row]
        self.performSegue(withIdentifier: "toLabComment", sender: nil)
        // 選択状態の解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didTapMenuButton(targetCell tableViewCell: UITableViewCell, targetButton: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let selectedPostUser = posts[tableViewCell.tag].object(forKey: "user") as! NCMBUser
        if selectedPostUser.object(forKey: "objectId") as! String == NCMBUser.current()?.objectId{
//            ログインユーザーの投稿を削除する時の一連の流れ
            let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
//                読み込み中を表すUI
                HUD.show(.progress, onView: self.view)
                let query = NCMBQuery(className: "Post")
                query?.getObjectInBackground(withId: self.posts[tableViewCell.tag].objectId, block: { (post, error) in
                    if error != nil {
                        print(error)
                    } else {
//                        取得したオブジェクトを削除
                        post?.deleteInBackground({ (error) in
                            if error != nil {
                                print(error)
                            } else {
//                                再読み込み
                                self.loadTimeLine()
//                                読み込みを直ちに消去する
                                HUD.hide(animated: true)
                            }
                        })
                    }
                })
            }
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
        } else {
            
        }
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
//    コメント画面へ遷移
    func didTapToComment(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton) {
        // 選ばれた投稿を一時的に格納
                   selectedPost = posts[tableViewCell.tag]
           
                   // 遷移させる(このとき、prepareForSegue関数で値を渡す)
                   self.performSegue(withIdentifier: "toLabComment", sender: nil)
    }
    
//    引っ張った時のぐるぐるを出す処理
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        labTimeLineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.loadTimeLine()
//        更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    func loadTimeLine() {
        guard let currentUser = NCMBUser.current() else{
//            オートログアウト
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
//            ログイン情報の保持
            let ud = UserDefaults.standard
            ud.set(true, forKey: "isLogin")
            return
        }
//        Postクラスから撮ってくるというクエリを宣言
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
                self.labTimeLineTableView.reloadData()
            }
        })
    }
    

    
}
