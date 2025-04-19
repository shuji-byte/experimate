//
//  LabPostViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/31.
//

import UIKit
import NCMB
import PKHUD

class LabPostViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var requirementTextView: UITextView!
    @IBOutlet weak var rewartdTextView: UITextView!
    @IBOutlet weak var postButton: UIBarButtonItem!
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var summaryLabel: UILabel!
//    @IBOutlet var requirementLabel: UILabel!
//    @IBOutlet var rewardLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.delegate = self
        summaryTextView.delegate = self
        requirementTextView.delegate = self
        rewartdTextView.delegate = self
        
        postButton.isEnabled = false
        
        confirmContent()
        /*
//        ラベル
        //タイトル
        titleLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        titleLabel.layer.borderWidth = 1.0
        titleLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //概要
        summaryLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        summaryLabel.layer.borderWidth = 1.0
        summaryLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //条件
        requirementLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        requirementLabel.layer.borderWidth = 1.0
        requirementLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        //報酬
        rewardLabel.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        rewardLabel.layer.borderWidth = 1.0
        rewardLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        */
        
//        テキストビュー
        //タイトル
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
        rewartdTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        rewartdTextView.layer.borderWidth = 1.0
        
        rewartdTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        
        
    }
    
//    投稿ボタンを有効にするか否かを判定する関数
    func confirmContent() {
        if titleTextView.text.count > 0 && summaryTextView.text.count > 0 && requirementTextView.text.count > 0 && rewartdTextView.text.count > 0 {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }

//    投稿機能
    @IBAction func post(_ sender: Any) {
        
//        postクラスを作成
        let object = NCMBObject(className: "Post")
        
//        Postクラス内に投稿内容をセット
        object?.setObject(NCMBUser.current(), forKey: "user")
        object?.setObject(titleTextView.text, forKey: "title")
        object?.setObject(summaryTextView.text, forKey: "summary")
        object?.setObject(requirementTextView.text, forKey: "requirement")
        object?.setObject(rewartdTextView.text, forKey: "reward")
        object?.saveInBackground({ (error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            self.titleTextView.text = nil
            self.summaryTextView.text = nil
            self.requirementTextView.text = nil
            self.rewartdTextView.text = nil
            
            
//            タブをタイムラインに戻す
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        
//        キーボードが表示されている状態でキャンセルされた場合、キーボードを戻す
        if titleTextView.isFirstResponder == true {
            titleTextView.resignFirstResponder()
        }
        if summaryTextView.isFirstResponder == true {
            summaryTextView.resignFirstResponder()
        }
        if requirementTextView.isFirstResponder == true {
            requirementTextView.resignFirstResponder()
        }
        if rewartdTextView.isFirstResponder == true {
            rewartdTextView.resignFirstResponder()
        }
        
//        キャンセルしていいか確認
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を破棄しますか", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//            入力情報を初期状態に戻す
            self.titleTextView.text = nil
            self.summaryTextView.text = nil
            self.requirementTextView.text = nil
            self.rewartdTextView.text = nil
//            ボタンの可不可を判定し直す
            self.confirmContent()
        }
//        キャンセルをキャンセルする
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
//    textViewの編集検知
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
        
    }
//    キーボード設定
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
