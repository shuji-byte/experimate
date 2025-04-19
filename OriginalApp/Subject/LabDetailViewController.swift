//
//  LabDetailViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/18.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD

class LabDetailViewController: UIViewController{
    
    @IBOutlet var labImageView: UIImageView!
    @IBOutlet var labNameLabel: UILabel!
    @IBOutlet var labMailAddressLabel: UILabel!
    @IBOutlet var labIntroductionTextView: UITextView!
    
    var selectedUser: NCMBUser!
    var posts = [NCMBObject]()
    var users = [NCMBUser]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labImageView.layer.cornerRadius = labImageView.bounds.width/2.0
        labImageView.clipsToBounds = true
        
        //        ラベル
            
        //        テキストビュー
                labIntroductionTextView.layer.borderColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1.0).cgColor
                labIntroductionTextView.layer.borderWidth = 1.0
                
                labIntroductionTextView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if selectedUser.object(forKey: "displayName") as! String != "" {
            labNameLabel.text = selectedUser.object(forKey: "displayName") as! String
        } else {
            labNameLabel.text = "表示なし"
        }
        labMailAddressLabel.text = selectedUser?.object(forKey: "mailAddress") as? String
        
        labIntroductionTextView.text = selectedUser?.object(forKey: "introduction") as? String
        
        let file = NCMBFile.file(withName: (selectedUser.objectId)! , data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let image = UIImage(data: data!) {
                self.labImageView.image = image
            }
        }
    }
        
    
}
