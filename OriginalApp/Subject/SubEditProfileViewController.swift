//
//  SubEditProfileViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/30.
//

import UIKit
import NCMB

class SubEditProfileViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var subImageView: UIImageView!
    @IBOutlet weak var subNameTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var subBirthTextField: UITextField!
    @IBOutlet weak var subCollegeTextField: UITextField!
    @IBOutlet weak var subFacultyTextField: UITextField!
    @IBOutlet weak var subGradeTextField: UITextField!
    @IBOutlet weak var subLabTextField: UITextField!
    
    @IBOutlet var imageEditButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subImageView.layer.cornerRadius = subImageView.bounds.width/2.0
        subImageView.clipsToBounds = true
        
//        ボタン
        //画像編集
        imageEditButton.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        imageEditButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        imageEditButton.layer.cornerRadius = 10
        
        imageEditButton.layer.borderColor = UIColor(red: 100/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        imageEditButton.layer.borderWidth = 2.0
        
        imageEditButton.layer.shadowColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        
//    テキストフィールド
        //名前
        subNameTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subNameTextField.layer.borderWidth = 1.0
        
        //id
        userIdTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        userIdTextField.layer.borderWidth = 1.0
        
        //生年月日
        subBirthTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subBirthTextField.layer.borderWidth = 1.0
        
        //大学
        subCollegeTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subCollegeTextField.layer.borderWidth = 1.0
        
        //学部
        subFacultyTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subFacultyTextField.layer.borderWidth = 1.0
        
        //学年
        subGradeTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subGradeTextField.layer.borderWidth = 1.0
        
        //研究室
        subLabTextField.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
        subLabTextField.layer.borderWidth = 1.0
        
        
        
        
        subNameTextField.delegate = self
        userIdTextField.delegate = self
        subBirthTextField.delegate = self
        subCollegeTextField.delegate = self
        subFacultyTextField.delegate = self
        subGradeTextField.delegate = self
        subLabTextField.delegate = self
        
        //    ユーザー情報を読み込む
        loadUserData()
        
//        プロフィールを角丸
        subImageView.layer.cornerRadius = subImageView.bounds.width / 2
        
        //    NCMBFileからuserIDが結合しているimageFileをgetする
        let file = NCMBFile.file(withName: (NCMBUser.current()?.objectId)!, data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            //                取得したimageを反映
            if let image = UIImage(data: data!) {
                self.subImageView.image = image
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
            subNameTextField.text = user.object(forKey: "displayName") as? String
            subBirthTextField.text = user.object(forKey: "birth") as? String
            userIdTextField.text = user.userName
            subCollegeTextField.text = user.object(forKey: "college") as? String
            subFacultyTextField.text = user.object(forKey: "faculty") as? String
            subGradeTextField.text = user.object(forKey: "grade") as? String
            subLabTextField.text = user.object(forKey: "lab") as? String
            
        } else {
//            signIn画面へ
            self.toSignIn()
        }
    }
    
    @IBAction func saveSubInfo(_ sender: Any) {
        if let user = NCMBUser.current() {
            user.setObject(subNameTextField.text, forKey: "displayName")
            user.setObject(userIdTextField.text, forKey: "userName")
            user.setObject(subBirthTextField.text, forKey: "birth")
            user.setObject(subCollegeTextField.text, forKey: "college")
            user.setObject(subFacultyTextField.text, forKey: "faculty")
            user.setObject(subGradeTextField.text, forKey: "grade")
            user.setObject(subLabTextField.text, forKey: "lab")
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
               
               subImageView.image = pickerImage
               
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
                       self.subImageView.image = pickerImage
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
