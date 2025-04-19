//
//  UserDetailTableViewCell.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/08/18.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var subImageView: UIImageView!
    @IBOutlet var subDisplayNameLabel: UILabel!
    @IBOutlet var subBirthLabel: UILabel!
    @IBOutlet var subCollegeLabel: UILabel!
    @IBOutlet var subFacultyLabel: UILabel!
    @IBOutlet var subGradeLabel: UILabel!
    @IBOutlet var subLabLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        subImageView.layer.cornerRadius = subImageView.bounds.width/2.0
        subImageView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
