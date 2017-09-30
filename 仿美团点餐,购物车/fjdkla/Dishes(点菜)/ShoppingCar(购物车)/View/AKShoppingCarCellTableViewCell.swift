//
//  AKShoppingCarCellTableViewCell.swift
//  fjdkla
//
//  Created by AK on 2017/7/28.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

protocol AKShoppingCarCellTableViewCellDelegate: NSObjectProtocol{
    func reloadDate(_ model: AKShoppingViewItemDelegate)
}

class AKShoppingCarCellTableViewCell: UITableViewCell {

    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var standardLabel: UILabel!
    
    weak var delegate: AKShoppingCarCellTableViewCellDelegate?
    
    var model: AKShoppingViewItemDelegate?{
        didSet{
            if let m = model as? FoodModel{
                foodName.text = m.name
                count.text = "\(m.count)"
                standardLabel.isHidden = true
            }else if let classifyM = model as? AKClassifyStandardModel{
                foodName.text = classifyM.套餐名
                count.text = "\(classifyM.count)"
                standardLabel.isHidden = false
                var standardString = ""
                let standardArray = getStandardArray(classifyM)
                for (i,str) in standardArray.enumerated(){
                    if i == standardArray.count - 1{
                        standardString += "[\(str)]"
                    }else{
                        standardString += "[\(str)]、"
                    }
                }
                standardLabel.text = standardString
                
            }
        }
    }
    
    func getStandardArray(_ model: AKClassifyStandardModel)->[String]{
        var standardModels = [String]()
        for key in model.dic.keys{
            let standardM = model.dic[key]
            for kind in standardM?.种类 ?? []{
                if kind.kingCount >= 1{
                    var string = "\(kind.名称)"
                    if kind.kingCount > 1 {string = string + "X \(kind.kingCount)"}
                    standardModels.append(string)
                }
            }
        }
        return standardModels
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickPlusBtn(_ sender: Any) {
        guard var m = model else{return}
        m.count += 1
        delegate?.reloadDate(m)
    }
    
    @IBAction func clickMinusBtn(_ sender: Any) {
        guard var m = model else{return}
        m.count -= 1
        delegate?.reloadDate(m)
    }
}
