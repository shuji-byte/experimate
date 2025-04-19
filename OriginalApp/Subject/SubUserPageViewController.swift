//
//  SubUserPageViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/25.
//

import UIKit
import NCMB
import PKHUD

class SubUserPageViewController: UIViewController {
    
    @IBOutlet weak var subImageView: UIImageView!
    @IBOutlet weak var subDisplayNameLabel: UILabel!
    @IBOutlet weak var subBirthLabel: UILabel!
    @IBOutlet weak var subCollegeLabel: UILabel!
    @IBOutlet weak var subFacultyLabel: UILabel!
    @IBOutlet weak var subGradeLabel: UILabel!
    @IBOutlet weak var subLabLabel: UILabel!
    
    @IBOutlet var profileButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        プロフィール画像を角丸にする
        subImageView.layer.cornerRadius = subImageView.bounds.width / 2
        subImageView.clipsToBounds = true
        
        
//        　ボタン
        //編集ボタン
        profileButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        profileButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        profileButton.layer.cornerRadius = 10
        
        profileButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        profileButton.layer.borderWidth = 2.0
        
        profileButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        
//        ラベル
       /* //名前
        subDisplayNameLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subDisplayNameLabel.layer.borderWidth = 1.0
        subDisplayNameLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //生年月日
        subBirthLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subBirthLabel.layer.borderWidth = 1.0
        subBirthLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //大学
        subCollegeLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subCollegeLabel.layer.borderWidth = 1.0
        subCollegeLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //学部
        subFacultyLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subFacultyLabel.layer.borderWidth = 1.0
        subFacultyLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //学年
        subGradeLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subGradeLabel.layer.borderWidth = 1.0
        subGradeLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //研究室
        subLabLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subLabLabel.layer.borderWidth = 1.0
        subLabLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)*/
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        ユーザー情報をNCMBUserから取得
//        .currentが期限切れか判定
        
        if let user = NCMBUser.current() {
            
            subDisplayNameLabel.text = user.object(forKey: "displayName") as? String
            subBirthLabel.text = user.object(forKey: "birth") as? String
            subCollegeLabel.text = user.object(forKey: "college") as? String
            subFacultyLabel.text = user.object(forKey: "faculty") as? String
            subGradeLabel.text = user.object(forKey: "grade") as? String
            subLabLabel.text = user.object(forKey: "lab") as? String
            
//            navigationItemのタイトルにuserIdを反映
            self.navigationItem.title = user.userName
            
//            NCMBFileからuserIdが結合しているimageFileをget
            let file = NCMBFile.file(withName: (user.objectId)! , data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
//                取得したimageを反映
                if let image = UIImage(data: data!) {
                    self.subImageView.image = image
                }
                
            }
            
        } else {
            //                遷移先のストーリーボードを取得
                            let storyboard = UIStoryboard(name: "SignIn", bundle: .main)
                            let rootVC = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            //                モーダルをフルスクリーン表示
                            rootVC.modalPresentationStyle = .fullScreen
            //                画面表示
                            self.present(rootVC, animated: true, completion: nil)
                            
            //                ログアウト状態を端末に保存
                            let ud = UserDefaults.standard
                            ud.set(false, forKey: "isLogin")
        }
    }
    
//    SignIn画面に移動
    func toSignIn() {
        //                遷移先のストーリーボードを取得
                        let storyboard = UIStoryboard(name: "SignIn", bundle: .main)
                        let rootVC = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
        //                モーダルをフルスクリーン表示
                        rootVC.modalPresentationStyle = .fullScreen
        //                画面表示
                        self.present(rootVC, animated: true, completion: nil)
                        
        //                ログアウト状態を端末に保存
                        let ud = UserDefaults.standard
                        ud.set(false, forKey: "isLogin")
                        ud.synchronize()
        
    }
    

//    メニュー表示(ログアウト)
        @IBAction func showMenu(_ sender: Any) {
            let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください", preferredStyle: .actionSheet)
    //        キャンセルシート
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
    //        ログアウトシート
            let logOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
                
    //            ログアウトを実行
                NCMBUser.logOutInBackground { (error) in
                    if error != nil {
                        print(error.debugDescription)
                        return
                    }
                    
    //                ログアウト成功
                    self.toSignIn()
                }
            }
            
    //        退会シート→アラートの中にアラート
    //        退会→userのactiveがfalseに変更される
            let signOutAction = UIAlertAction(title: "退会", style: .default) { (action) in
                
                let alert = UIAlertController(title: "会員登録の解除", message: "本当に退会しますか?退会した場合、再度このアカウントをご利用いただくことができません。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
    //                ユーザーのアクティブ状態をfalseに
                    if let user = NCMBUser.current() {
                        HUD.show(.progress, onView: self.view)
                        user.deleteInBackground { (error) in
                            HUD.hide(animated: true)
                            if error != nil {
                                print(error?.localizedDescription)
    //                            テキストを指定してエラー内容を表示→1秒後に消える
                                HUD.flash(.labeledError(title: "エラー", subtitle: "退会に失敗しました"), delay: 1)
                            } else {
    //                            userのアクティブ状態を変更できたらログイン画面に移動
                                self.toSignIn()

                            }
                        }
                    } else {
    //                     userがnilだった場合ログイン画面に移動
                        self.toSignIn()
                        
                    }
                }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
    //        アラートを表示
            alertController.addAction(logOutAction)
            alertController.addAction(signOutAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }

    }
