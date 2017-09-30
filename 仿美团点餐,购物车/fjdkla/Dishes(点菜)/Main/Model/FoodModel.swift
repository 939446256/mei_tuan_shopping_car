//
//  FoodModel.swift
//  fjdkla
//
//  Created by AK on 2017/7/27.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class FoodModel: NSObject, AKShoppingViewItemDelegate {
    func copyModel() -> AKShoppingViewItemDelegate? {
        return nil
    }

    var price: NSNumber?{
        get{ return min_price }
    }

    var id: NSNumber?
    var min_price: NSNumber?
    var praise_num: NSNumber?
    var month_saled: NSNumber?
    var picture     = ""
    var name        = ""
    var count       = 0 { didSet{ count <= 0 ? count = 0 : Void() } }
    
    
    var dic: [String:Any] = [:]{
        didSet{
            id          = dic["id"] as? NSNumber
            name        = dic["name"] as! String
            min_price   = dic["min_price"] as? NSNumber
            praise_num  = dic["praise_num"] as? NSNumber
            picture     = dic["picture"] as! String
            month_saled = dic["month_saled"] as? NSNumber
        }
    }
    
//    func copyModel() -> FoodModel {
//        let model = FoodModel()
//        model.id            = self.id
//        model.name          = self.name
//        model.min_price     = self.min_price
//        model.praise_num    = self.praise_num
//        model.picture       = self.picture
//        model.month_saled   = self.month_saled
//        return model
//    }
    
}
