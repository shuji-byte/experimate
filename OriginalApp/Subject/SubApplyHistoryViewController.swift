//
//  SubApplyHistoryViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/05.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD

class SubApplyHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var titles = [String]()
    var selectedPost: NCMBObject?
    var posts = [NCMBObject]()
    var users = [NCMBUser]()
    @IBOutlet var subApplyHistoryTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subApplyHistoryTableView.dataSource = self
        subApplyHistoryTableView.delegate = self
        subApplyHistoryTableView.rowHeight = 100
        
        let nib = UINib(nibName: "SubApplyHistoryTableViewCell", bundle: Bundle.main)
        subApplyHistoryTableView.register(nib, forCellReuseIdentifier: "historycell")
        subApplyHistoryTableView.tableFooterView = UIView()
        
        setRefreshControl()
        
//        区切り線の色
        subApplyHistoryTableView.separatorColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadApplyHistory()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell") as! SubApplyHistoryTableViewCell
                
                
                cell.tag = indexPath.row
                //let user = users[indexPath.row].object(forKey: "lab") as! NCMBUser
                //        ユーザ名の表示
                if users[indexPath.row].object(forKey: "displayName") as? String != "" {
                    cell.labNamelabel.text = users[indexPath.row].object(forKey: "displayName") as? String
                } else {
                    cell.labNamelabel.text = "表示なし"
                }
                //　　　　title表示
                cell.titleLabel.text = titles[indexPath.row] as! String
                //let userObjectId = users[indexPath.row].objectId
                let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/GwSh1j3QNUt73MyB/publicFiles/" + users[indexPath.row].objectId
                cell.labImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
                return cell
    }
    
    
    // 引っ張った時にグルグルを出す処理
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        subApplyHistoryTableView.addSubview(refreshControl)
    }
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.loadApplyHistory()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    func loadApplyHistory() {
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
        query?.includeKey("Lab")
//        query?.includeKey("Applying")
        query?.whereKey("Applying", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(result,error) in
            if error != nil{
                print(error)
            }else{
                self.titles = [String]()
                self.users = [NCMBUser]()
                for postObject in result as! [NCMBObject]{
                    
                self.users.append(postObject.object(forKey: "Lab") as! NCMBUser)
                self.titles.append(postObject.object(forKey: "Experiment") as! String)
                }
                self.subApplyHistoryTableView.reloadData()
            }
        })
        
    }
}
