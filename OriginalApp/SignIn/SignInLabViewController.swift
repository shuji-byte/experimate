//
//  SignInLabViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/24.
//

import UIKit
import NCMB
import PKHUD

class SignInLabViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passWordTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn() {
        HUD.show(.progress)
        NCMBUser.logInWithUsername(inBackground: userNameTextField.text, password: passWordTextField.text){ user, error in
            if error != nil {
                HUD.hide(animated: true)
                print(error)
            } else {
                HUD.hide(animated: true)
                let storyboard = UIStoryboard(name: "LabMain", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                UIApplication.shared.windows.first { $0.isKeyWindow}?.rootViewController = rootViewController
//                ログイン状態を保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.set(true, forKey: "isAdmin")
                print("LabMain")
            }
        }
    }
}
