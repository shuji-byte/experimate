//
//  UserDetailViewController.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/18.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD

class UserDetailViewController: UIViewController {
    
    @IBOutlet var subImageView: UIImageView!
    @IBOutlet var subDisplayNameLabel: UILabel!
    @IBOutlet var subBirthLabel: UILabel!
    @IBOutlet var subCollegeLabel: UILabel!
    @IBOutlet var subFacultyLabel: UILabel!
    @IBOutlet var subGradeLabel: UILabel!
    @IBOutlet var subLabLabel: UILabel!

    var selectedUser: NCMBUser!
    var posts = [NCMBObject]()
    var users = [NCMBUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedUser)
        
        
        subImageView.layer.cornerRadius = subImageView.bounds.width/2.0
        subImageView.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if selectedUser.object(forKey: "displayName") as! String != "" {
            subDisplayNameLabel.text = selectedUser.object(forKey: "displayName") as! String
        } else {
            subDisplayNameLabel.text = "表示なし"
        }
        subBirthLabel.text = selectedUser?.object(forKey: "birth") as? String
        
        subCollegeLabel.text = selectedUser?.object(forKey: "college") as? String
        
        subFacultyLabel.text = selectedUser?.object(forKey: "faculty") as? String
        
        subGradeLabel.text = selectedUser?.object(forKey: "grade") as? String
        
        subLabLabel.text = selectedUser?.object(forKey: "lab") as? String
        
        let file = NCMBFile.file(withName: (selectedUser.objectId)! , data: nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let image = UIImage(data: data!) {
                self.subImageView.image = image
            }
        }
    }

    
}
