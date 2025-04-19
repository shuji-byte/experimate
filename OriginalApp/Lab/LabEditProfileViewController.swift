//
//  LabEditProfileViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/28.
//

import UIKit
import NCMB


class LabEditProfileViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var labImageView: UIImageView!
    @IBOutlet weak var labNameTextField: UITextField!
    @IBOutlet weak var labIdTextField: UITextField!
    @IBOutlet weak var labIntroductionTextView: UITextView!
    @IBOutlet var editImageButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labNameTextField.delegate = self
        labIdTextField.delegate = self
        labIntroductionTextView.delegate = self
        
        labImageView.layer.cornerRadius = labImageView.bounds.width/2.0
        labImageView.clipsToBounds = true


        
//        テキストフィールド
      /*  //名前
        labNameTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        labNameTextField.layer.borderWidth = 1.0
        //ID
        labIdTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        labIdTextField.layer.borderWidth = 1.0*/
//        テキストビュー
        //説明
        labIntroductionTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        labIntroductionTextView.layer.borderWidth = 1.0
        
        labIntroductionTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        ボタン
        //画像編集
        editImageButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        editImageButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        editImageButton.layer.cornerRadius = 10
        
        editImageButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        editImageButton.layer.borderWidth = 2.0
        
        editImageButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        
        
        //    ユーザー情報を読み込む
        loadUserData()
        
        //    NCMBFileからuserIDが結合しているimageFileをgetする
        let file = NCMBFile.file(withName: (NCMBUser.current()?.objectId)!, data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            //                取得したimageを反映
            if let image = UIImage(data: data!) {
                self.labImageView.image = image
            } else {
                //               signIn画面へ移動
                self.toSignIn()
            }
            
        }
        
    }
    
//   SignIn画面に移動
    func toSignIn() {
//    遷移先のストーリーボードを取得
        let storyboard = UIStoryboard(name: "SignIn", bundle: .main)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
//       モーダルをフルスクリーン表示
            rootVC.modalPresentationStyle = .fullScreen
//                画面表示
            self.present(rootVC, animated: true, completion: nil)
                            
//                ログアウト状態を端末に保存
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            
        }
    
//    userdataのload
    func loadUserData() {
        if let user = NCMBUser.current() {
            labNameTextField.text = user.object(forKey: "displayName") as? String
            labIntroductionTextView.text = user.object(forKey: "introduction") as? String
            labIdTextField.text = user.userName
        } else {
//            signIn画面へ
            self.toSignIn()
        }
    }
    
    @IBAction func saveLabInfo(_ sender: Any) {
        if let user = NCMBUser.current() {
            user.setObject(labNameTextField.text, forKey: "displayName")
            user.setObject(labIdTextField.text, forKey: "userName")
            user.setObject(labIntroductionTextView.text, forKey: "introduction")
            user.saveInBackground({ (error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            self.toSignIn()
        }
    }
    
    // プロフィールの画像編集ボタン
       @IBAction func selectImage(_ sender: Any) {
           
           let actionController = UIAlertController(title: "画像の選択", message: "選択してください", preferredStyle: .actionSheet)
           let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
               
               // カメラ起動
               let picker = UIImagePickerController()
               picker.sourceType = .camera
               picker.delegate = self
               picker.allowsEditing = true
               self.present(picker, animated: true, completion: nil)
           }
           let albumAction = UIAlertAction(title: "アルバム", style: .default) { (action) in
               
               // アルバム起動
               let picker = UIImagePickerController()
               picker.sourceType = .photoLibrary
               picker.delegate = self
               picker.allowsEditing = true
               self.present(picker, animated: true, completion: nil)
           }
           let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
               self.dismiss(animated: true, completion: nil)
           }
           
           actionController.addAction(cameraAction)
           actionController.addAction(albumAction)
           actionController.addAction(cancelAction)
           self.present(actionController, animated: true, completion: nil)
           
           
       }
       
       // 画像が選択された時の処理
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           
           // 選択された写真のデータをpickerImageに入れる
           if let pickerImage = info[.editedImage] as? UIImage {
               
               labImageView.image = pickerImage
               
               picker.dismiss(animated: true, completion: nil)
               
               // 画像アップロード(NCMBFile)
               // 画像をデータ型に変換
               let imageData = pickerImage.jpegData(compressionQuality: 0.1)
               // 保存したいデータを含んだファイルを保存する
               // fileパスがデフォルトではただの文字列で抽出しにくい→userIdと結合する
               // 会員管理のobjectIdが末尾についている
               let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: imageData) as! NCMBFile
               // 保存実行
               file.saveInBackground { (error) in
                   // エラー処理
                   if error != nil {
                       print(error.debugDescription)
                       return
                   } else {
                       // 保存に成功したら画像を反映する
                       self.labImageView.image = pickerImage
                   }
                   
               } progressBlock: { (progress) in
                   print(progress)
               }
     
           }
           
           
       }
       
       // 撮影orアルバムのキャンセル処理
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           
           picker.dismiss(animated: true, completion: nil)
           
       }
       // キーボードの設定
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
           textView.resignFirstResponder()
           return true
       }

    
    
    
}
