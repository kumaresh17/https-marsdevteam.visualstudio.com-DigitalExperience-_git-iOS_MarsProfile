//
//  MPShareSourceYammerTableViewCell.swift
//  MarsProfile
//
//  Created by TechMadmin on 25/07/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit

class MPShareSourceYammerTableViewCell: UITableViewCell {
    @IBOutlet weak var sourceButton:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func sourceTapped(_ sender: AnyObject) {
        let button = sender as! UIButton
        if(button.isSelected){
            button.isSelected = false
            button.setImage(UIImage(named: "unchecked_checkbox"), for: UIControlState.normal)
        }else{
            button.isSelected = true
            button.setImage(UIImage(named: "checked_checkbox"), for: UIControlState.selected)
        }
    }
}
