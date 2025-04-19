//
//  SignUpSubViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/24.
//

import UIKit
import NCMB

class SignUpSubViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var mailAddressTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        mailAddressTextField.delegate = self
        passWordTextField.delegate = self
        confirmTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    ボタンを押して新規会員登録
    @IBAction func signUp() {
        if  userNameTextField.text?.count == 0 || mailAddressTextField.text?.count == 0 || passWordTextField.text!.count < 3 || confirmTextField.text!.count < 3 || (passWordTextField.text != confirmTextField.text) {
            return
        } else if mailAddressTextField.text?.contains("@") == false {
            alertController = UIAlertController(title: "入力された文字の中に@が入っていません", message: "メールアドレスを入力してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return
        }
        let user = NCMBUser()
        user.userName = userNameTextField.text!
        user.mailAddress = mailAddressTextField.text!
        user.password = passWordTextField.text!
        var acl = NCMBACL()
        acl.setPublicReadAccess(true)
        acl.setPublicWriteAccess(true)
        user.acl = acl
        user.setObject(false, forKey: "admin")
        user.setObject(true, forKey: "active")
        user.setObject("", forKey: "displayName")
        user.signUpInBackground { (error) in
            if error != nil {
                print(error)
            } else {
                let storyboard = UIStoryboard(name: "SubjectMain", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = rootViewController
                
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.set(false, forKey: "isAdmin")
            }
        }
    }
}
