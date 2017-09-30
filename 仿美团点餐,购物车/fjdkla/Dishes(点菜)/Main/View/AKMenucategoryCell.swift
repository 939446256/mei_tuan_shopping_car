//
//  AKMenucategoryCell.swift
//  fjdkla
//
//  Created by AK on 2017/7/27.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class AKMenucategoryCell: UITableViewCell {
    @IBOutlet weak var menuCategoryLabel: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var menuCategoryLabelToIcon: NSLayoutConstraint!
    
    var menuCategory = ""{
        didSet{
            switch menuCategory{
            case "热销":
                menuCategoryLabel.textColor = UIColor.red
                icon.image = UIImage(named: "Minus")
                icon.isHidden = false
                menuCategoryLabelToIcon.priority = 902
            case "推荐":
                menuCategoryLabel.textColor = UIColor.orange
                icon.image = UIImage(named: "Plus")
                icon.isHidden = false
                menuCategoryLabelToIcon.priority = 902
            case "收藏":
                menuCategoryLabel.textColor = UIColor.green
                icon.image = UIImage(named: "praise")
                icon.isHidden = false
                menuCategoryLabelToIcon.priority = 902
            default :
                menuCategoryLabel.textColor = UIColor.black
                icon.isHidden = true
                menuCategoryLabelToIcon.priority = 900
            }
            menuCategoryLabel.text = menuCategory
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.darkGray
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            self.contentView.backgroundColor = UIColor.white
        }else{
            self.contentView.backgroundColor = UIColor.lightGray
        }
    }
}
