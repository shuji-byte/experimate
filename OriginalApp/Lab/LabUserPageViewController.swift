//
//  LabUserPageViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/25.

import UIKit
import NCMB
import PKHUD

class LabUserPageViewController: UIViewController {
    
    
    @IBOutlet weak var labImageView: UIImageView!
    @IBOutlet weak var labDisplayNameLabel: UILabel!
    @IBOutlet weak var labIntroductionTextView: UITextView!
    @IBOutlet var editProfileButton: UIButton!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labImageView.layer.cornerRadius = labImageView.bounds.width/2.0
        labImageView.clipsToBounds = true

//        ラベル
//        テキストビュー
        //研究室説明
        labIntroductionTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        labIntroductionTextView.layer.borderWidth = 1.0
        
        labIntroductionTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
//        ボタン
        //編集ボタン
        editProfileButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        editProfileButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        editProfileButton.layer.cornerRadius = 10
        
        editProfileButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        editProfileButton.layer.borderWidth = 2.0
        
        editProfileButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        
        
    }
    
//    ユーザー情報を取得する処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        ユーザー情報をNCMBUserから取得
//        currentが期限切れか判定
        if let  user = NCMBUser.current() {
            labDisplayNameLabel.text = user.object(forKey: "displayName") as? String
            labIntroductionTextView.text = user.object(forKey: "introduction") as? String
//            navigationBarのタイトルにIDを反映
            self.navigationItem.title = user.userName
            
//            NCMBFileからuserIdが結合しているimageFileをgetする
            let file = NCMBFile.file(withName: (user.objectId)!, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
//                取得したimageを反映
                if let image = UIImage(data: data!) {
                    self.labImageView.image = image
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
    
//    ボタンを押すとハーフモーダルでコメント画面へ遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination
       
        if let sheet = next.sheetPresentationController {
//            ハーフモーダルの高さ指定
            sheet.detents = [.medium(), .large()]
//            コードでの高さ切り替え
            sheet.animateChanges {
                    sheet.selectedDetentIdentifier = .medium
                }
//            モーダル内のスクロール許可
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            グラバーの表示
            sheet.prefersGrabberVisible = true
//            角を丸く
            sheet.preferredCornerRadius = 24.0
//            ハーフモーダルを表示しつつ、親viewも操作できるように
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
    }

    
   
    
    
    

    }
