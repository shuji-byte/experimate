//
//  SubTimeLineViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/03.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD

class SubTimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,  SubTimeLineTableViewCellDelegate {
   
    
    var appendApplyIds = [String]()

    
    var selectedPost: NCMBObject?
    var posts = [NCMBObject]()
    var users = [String]()
    var searchBar: UISearchBar!
    var text: String!
    
    @IBOutlet var subTimeLineTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        subTimeLineTableView.dataSource = self
        subTimeLineTableView.delegate = self
        subTimeLineTableView.rowHeight = 700
        
        let nib = UINib(nibName: "SubTimeLineTableViewCell", bundle: Bundle.main)
        subTimeLineTableView.register(nib, forCellReuseIdentifier: "SubTimeLineCell")
        subTimeLineTableView.tableFooterView = UIView()
        
        setRefreshControl()
        
        //        区切り線の色
        subTimeLineTableView.separatorColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        loadUser()
//      print(self.users)
//        print(self.appendApplyIds)
        loadTimeLine(searchText:  nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComment" {
            let commentViewController = segue.destination as! CommentViewController
            print(selectedPost?.objectId)
            commentViewController.postId = selectedPost?.objectId as!String
        } else if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! LabDetailViewController
            detailVC.selectedUser = selectedPost?.object(forKey: "user") as? NCMBUser
        }
    }
    
    func setSearchBar() {
        //        NavigationBarにSearchBarをセット
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.delegate = self
            searchBar.placeholder = "実験を検索"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadTimeLine(searchText: nil)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadTimeLine(searchText: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTimeLineCell") as! SubTimeLineTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        let user = posts[indexPath.row].object(forKey: "user") as! NCMBUser
        //        ユーザー名の表示
//        if user.object(forKey: "displayName") as! String != "" {
            cell.labNameLabel.text = user.object(forKey: "displayName") as? String
//        } else {
//            cell.labNameLabel.text = "表示なし"
//        }
        //        ユーザーのアイコンの表示のためのurlを作る
        let userObjectId = user.object(forKey: "objectId") as! String
        let appId = "GwSh1j3QNUt73MyB"
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/" + appId + "/publicFiles/" + userObjectId
        cell.labImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(systemName: "person"), options: nil, progressBlock: nil)
        
        //        投稿文面の表示
        cell.titleTextView.text = posts[indexPath.row].object(forKey: "title") as! String
        cell.summaryTextView.text = posts[indexPath.row].object(forKey: "summary") as! String
        cell.requirementTextView.text = posts[indexPath.row].object(forKey: "requirement") as! String
        cell.rewardTextView.text = posts[indexPath.row].object(forKey: "reward") as! String
        //        日付の表示
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm"
        let date = posts[indexPath.row].createDate as! Date
        cell.timestampLabel.text = df.string(from: date)
        
        cell.tag = indexPath.row
       // DispatchQueue.main.asyncAfter(deadline: .now()+1){
          /*  if self.shouldHideButtonForIndexPath(indexPath) {
                       cell.toApplyButton.isHidden = true
                   } else {
                       cell.toApplyButton.isHidden = false
                   }
            
          print(self.appendApplyIds)
            print(self.users)*/
            
       // }
        
        
       /* if appendApplyIds.contains(users[indexPath.row]) == true {
            cell.toApplyButton.isHidden = true
        } else {
            cell.toApplyButton.isHidden = false
        }*/

        return cell
    }
    
    //    選択された時に呼ばれる関数
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedPost = posts[indexPath.row]
//        self.performSegue(withIdentifier: "toComment", sender: nil)
        // 選択状態の解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didTapToApply(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton) {
        
        guard let currentUser = NCMBUser.current() else{
            
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController = rootViewController
            let ud = UserDefaults.standard
            ud.set(true, forKey: "isLogin")
            ud.synchronize()
            return
            
        }
        
        let message = "応募しますか"
        let alert = UIAlertController(title: "応募", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let object = NCMBObject(className: "Apply")
            if let currentUser = NCMBUser.current() {
                object?.setObject(self.posts[tableViewCell.tag].object(forKey: "user") as! NCMBUser, forKey: "Lab")
                object?.setObject(currentUser, forKey: "Applying")
                object?.setObject(self.posts[tableViewCell.tag].object(forKey: "title") as! String , forKey: "Experiment")
                object?.saveInBackground({ (error) in
                    if error != nil {
                        HUD.show(.labeledError(title: error!.localizedDescription, subtitle: nil))
                    } else {
                        self.loadUser()
                        
                    }
                })
                
            } else {
                // currentUserが空(nil)だったらログイン画面へ
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = rootViewController
                
                // ログイン状態の保持
                let ud = UserDefaults.standard
                ud.set(false, forKey: "isLogin")
                ud.synchronize()
            }
        }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    
    func didTapName(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    func didTapToComment(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton) {
        // 選ばれた投稿を一時的に格納
                   selectedPost = posts[tableViewCell.tag]
           
                   // 遷移させる(このとき、prepareForSegue関数で値を渡す)
                   self.performSegue(withIdentifier: "toComment", sender: nil)
    }
    
                            
    
    //    引っ張った時にぐるぐるを出す処理
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        subTimeLineTableView.addSubview(refreshControl)
    }
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.loadTimeLine(searchText: searchBar.text )
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    //    投稿をロードする
    func loadTimeLine(searchText: String?) {
        //        オートログアウト
        guard let currentUser = NCMBUser.current() else{
            //            ログアウト
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.windows.first { $0.isKeyWindow}?.rootViewController = rootViewController
            let ud = UserDefaults.standard
            ud.set(true, forKey: "isLogin")
            return
        }
        //        初期化
        
        
        posts = [NCMBObject] ()
        let query = NCMBQuery(className: "Post")
        //        降順
        query?.order(byDescending: "createDate")
        //        投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        
        //        検索ワードがある場合
        if let text = searchText {
            print(text)
            
        }
        
        
        
        // let text: String! = searchBar.text!
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                for postObject in result as! [NCMBObject] {
                    
                    
                    
                    let title = postObject.object(forKey: "title") as! String
                    let summary = postObject.object(forKey: "summary") as! String
                    let requirement = postObject.object(forKey: "requirement") as! String
                    let reward = postObject.object(forKey: "reward") as! String
                    
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    if user.object(forKey: "active") as? Bool != false {
                        
                        if let text = searchText {
                            if summary.contains(text){
                                self.posts.append(postObject)
                            }else if requirement.contains(text){
                                self.posts.append(postObject)
                            }else if reward.contains(text){
                                self.posts.append(postObject)
                            }else if title.contains(text){
                                self.posts.append(postObject)
                            }
                        } else {
                            
                            
                            self.posts.append(postObject)
                            
                            
                        }
                        self.appendApply()
                        self.subTimeLineTableView.reloadData()
                    }
                }
            }
        })
    }
    
    
    
    func appendApply() {
        let query = NCMBQuery(className: "Apply")
        query?.includeKey("Lab")
        query?.whereKey("Applying", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                self.appendApplyIds = [String]()
                for appendings in result as! [NCMBObject] {
                    let user = appendings.object(forKey: "Lab") as! NCMBUser
                    self.appendApplyIds.append(user.objectId)
                }
                self.subTimeLineTableView.reloadData()
//               print(self.appendApplyIds)

            }
        })
        
    }
    
    
    
    
    func loadUser() {
        let query = NCMBUser.query()
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
               self.users = [String]()
                for allUser in result as! [NCMBObject] {
                    self.users.append(allUser.objectId)
                }
                
                self.appendApply()
            }
        })
    }
    
   /* func appendPosts() {
        let query = NCMBQuery(className: "Post")
        query?.includeKey("Lab")
        query?.whereKey("Applying", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                self.appendApplyIds = [String]()
                for appendings in result as! [NCMBObject] {
                    let user = appendings.object(forKey: "Lab") as! NCMBUser
                    self.appendApplyIds.append(user.objectId)
                }
                self.subTimeLineTableView.reloadData()
            }
        })
    }*/
    
  /*
  func shouldHideButtonForIndexPath(_ indexPath: IndexPath) -> Bool {
      
        // ここに条件を追加してください
        if appendApplyIds.contains(users[indexPath.row]) == true {
//            print("応募したひとの研究室",appendApplyIds)
            //            print("全会員のid",users)
            //            return indexPath.row == 1
            return true
        }
       return false
        
        
    }*/
}
