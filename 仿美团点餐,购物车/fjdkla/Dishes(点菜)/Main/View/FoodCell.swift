//
//  FoodCell.swift
//  fjdkla
//
//  Created by AK on 2017/7/27.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit
protocol  FoodCellDelegate: NSObjectProtocol{
    func checkMinusButton(_ foodInfoModel: FoodModel)
    func checkPlusButton(_ foodInfoModel: FoodModel)
    func clickStantardButton(_ foodInfoModel: FoodModel)
}



class FoodCell: UITableViewCell {
    enum FoodCellType{
        case total
        case standard
    }
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var month_saled: UILabel!
    @IBOutlet weak var praise_num: UILabel!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var orderCount: UILabel!
    
    @IBOutlet weak var standandCountLabel: UILabel!
    @IBOutlet weak var stantardButton: UIButton!
    weak var delegate: FoodCellDelegate?
    var cellType: FoodCellType = .total{
        didSet{
            switch cellType{
            case .total:
                minus.isHidden              = false
                plus.isHidden               = false
                orderCount.isHidden         = false
                stantardButton.isHidden     = true
                standandCountLabel.isHidden = true
                checkCount()
            case .standard:
                minus.isHidden              = true
                plus.isHidden               = true
                orderCount.isHidden         = true
                stantardButton.isHidden     = false
                standandCountLabel.isHidden = false
                checkStandardCount()
            }
        }
    }
    
    var model: FoodModel?{
        didSet{
            guard let m = model else{return}
            foodImageView.image = UIImage(named: m.picture)
            orderCount.text = "\(model?.count ?? 0)"
            standandCountLabel.text = "\(model?.count ?? 0)"
            name.text = m.name
            price.text = m.min_price?.stringValue ?? ""
            praise_num.text = m.praise_num?.stringValue ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    
    
    ///点击 减少
    @IBAction func checkMinusButton(_ sender: Any) {
        guard let d = delegate, let m = model else{return}
        m.count -= 1
        orderCount.text = "\(m.count)"
        checkCount()
        d.checkMinusButton(m)
    }
    
    ///点击 增加
    @IBAction func checkPlusButton(_ sender: Any) {
        guard let d = delegate, let m = model else{return}
        m.count += 1
        orderCount.text = "\(m.count)"
        checkCount()
        d.checkPlusButton(m)
    }
    
    @IBAction func clickStantardButton(_ sender: Any) {
        guard let d = delegate, let m = model else{return}
//        m.count += 1
        standandCountLabel.text = "\(m.count)"
        checkStandardCount()
        d.clickStantardButton(m)
    }
    
    
    ///判断是否显示减号
    func checkCount(){
//        guard let m = model else{return}
        let isHidden        = (model?.count ?? 0) <= 0
        minus.isHidden      = isHidden
        orderCount.isHidden = isHidden
    }
    
    ///判断是否显示规格角标
    func checkStandardCount(){
//        guard let m = model else{return}
        let isHidden        = (model?.count ?? 0) <= 0
        standandCountLabel.isHidden = isHidden
    }
}
