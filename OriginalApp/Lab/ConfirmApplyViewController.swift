//
//  confirmApplyViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/12.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD

class ConfirmApplyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConfirmApplyTableViewCellDelegate {
    
    
    
    var titles = [String]()
    var selectedUser: NCMBUser?
    var selectedPost: NCMBObject?
    var posts = [NCMBObject]()
    var users = [NCMBUser]()
    @IBOutlet var confirmApplyTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        区切り線の色
        confirmApplyTableView.separatorColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0)

        confirmApplyTableView.dataSource = self
        confirmApplyTableView.delegate = self
        confirmApplyTableView.rowHeight = 140
        
        let nib = UINib(nibName: "ConfirmApplyTableViewCell", bundle: Bundle.main)
        confirmApplyTableView.register(nib, forCellReuseIdentifier: "confirmcell")
        confirmApplyTableView.tableFooterView = UIView()
        
        setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirmApply()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "confirmcell", for: indexPath) as! ConfirmApplyTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
//名前を入れる
        if let displayName = users[indexPath.row].object(forKey: "displayName") as? String {
            cell.userNameLabel.text = displayName
        } else {
            cell.userNameLabel.text = "表示名なし"
        }
//        タイトルを入れる
        cell.titleLabel.text = titles[indexPath.row] as! String
//        画像を入れる
        if let userObjectId = users[indexPath.row].objectId {
            let appId = "GwSh1j3QNUt73MyB"
            let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/" + appId + "/publicFiles/" + userObjectId
            cell.userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(systemName: "person"), options: nil, progressBlock: nil)
        } else {
            cell.userImageView.image = UIImage(systemName: "person")
        }
        
        let email = users[indexPath.row].object(forKey: "mailAddress") as! String
        cell.emailLabel.text = email
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        selectedPost = posts[indexPath.row]
        // 選択状態の解除
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didTapToDetail(targetCell tableViewCell: UITableViewCell, targetButton button: UIButton) {
//      selectedPost = posts[tableViewCell.tag]
        selectedUser = users[tableViewCell.tag]
        performSegue(withIdentifier: "toUserDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDetail" {
            let detailVC = segue.destination as! UserDetailViewController
            detailVC.selectedUser = selectedUser
        }
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        confirmApplyTableView.refreshControl = refreshControl
    }

    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.confirmApply()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    func confirmApply() {
        // オートログアウト
        guard let currentUser = NCMBUser.current() else{
            // ログアウト成功
            let storyboard = UIStoryboard(name: "SignIn",bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = rootViewController
            // ログイン情報の保持
            let ud = UserDefaults.standard
            ud.set(true, forKey: "isLogin")
            return
        }
        
   
        let query = NCMBQuery(className: "Apply")
        // 降順
        query?.order(byDescending: "createDate")
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("Applying")
//        query?.includeKey("Applying")
        query?.whereKey("Lab", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(result,error) in
            if error != nil{
                print(error)
            }else{
                self.titles = [String]()
                self.users = [NCMBUser]()
                for postObject in result as! [NCMBObject]{
                    
                self.users.append(postObject.object(forKey: "Applying") as! NCMBUser)
                self.titles.append(postObject.object(forKey: "Experiment") as! String)
                }
                self.confirmApplyTableView.reloadData()
            }
        })
        
    }
}
