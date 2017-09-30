//
//  AKShoppingCarView.swift
//  fjdkla
//
//  Created by AK on 2017/7/28.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

protocol AKShoppingCarViewDelegate {
    func clickShoppingCarBtn()
}

class AKShoppingCarView: UIView {
    @IBOutlet weak var priceLabel       : UILabel!
    @IBOutlet weak var shoppingCarBtn   : UIButton!
    weak var shoppingCarController      : AKShoppingCarController?
    
    var delegate        : AKShoppingCarViewDelegate?
    var viewModel       : AKShoppingViewModel      = AKShoppingViewModel.share
    var backgroundView  : UIView?
    
    //MARK: - 初始化
    //================= 初始化 =================
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.totalPrice), name: NSNotification.Name(rawValue: "ViewModelReloadDate"), object: nil)
        totalPrice()
    }
    
    
    //点击购物车 响应按钮
    @IBAction func clickShoppingCarBtn(_ sender: Any) {
        delegate?.clickShoppingCarBtn()
//        shoppingTableView?.showAndHidden()
    }
    
    
    
    //MARK: - 功能方法
    //================= 功能方法 =================
//    //刷新Cell数据
//    func resetCell(_ foodInfoModel: FoodModel){
//        shoppingTableView?.resetCell(foodInfoModel)
//    }
    
    func totalPrice() {
        var total: Double = 0
        for model in viewModel.models{
            total += countPrice(model)
        }
        priceLabel.text = "¥\(total)"
    }
    
    func countPrice(_ foodInfoModel: AKShoppingViewItemDelegate) -> Double{
        let price = foodInfoModel.price?.doubleValue ?? 0
        let count = Double(foodInfoModel.count)
        return price * count
    }
    

    deinit {
        //释放通知接受者身份
        NotificationCenter.default.removeObserver(self)
    }
}
