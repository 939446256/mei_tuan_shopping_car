//
//  AKClassifyStandardModel.swift
//  fjdkla
//
//  Created by AK on 2017/8/2.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class AKClassifyStandardModel: NSObject, AKShoppingViewItemDelegate {


    weak var foodModel: FoodModel?

    var 套餐名 : String!
    var 主菜 : AKStandardModel!
    var 汤 : AKStandardModel!
    var 配菜 : AKStandardModel!
    
    var price: NSNumber?
    var count: Int = 0 {
        didSet{
            //判断count是增1还是减1
            if count - oldValue == 1{
                foodModel?.count += 1
            }else{
                foodModel?.count -= 1
            }
            count <= 0 ? count = 0 : Void()
        }
    }
    
    var dic = [String:AKStandardModel]()
    
    init(foodModel: FoodModel?, from dictionary: [String:Any]?){
        self.foodModel = foodModel
        self.price = foodModel?.price
        guard let dict = dictionary else{return}
        主菜 = AKStandardModel(classify: "主菜", from: dict["主菜"] as! [String:Any])
        汤 = AKStandardModel(classify: "汤", from: dict["汤"] as! [String:Any])
        配菜 = AKStandardModel(classify: "配菜", from: dict["配菜"] as! [String:Any])
        dic = ["主菜":主菜,"汤":汤,"配菜":配菜]
    }
    
    func checkAllDic(){
        for standard in self.dic{
            var count = 0
            for kind in standard.value.种类{
                count += kind.kingCount
            }
        }
    }
    
    
    func copyModel() -> AKClassifyStandardModel{
        let classModel = AKClassifyStandardModel(foodModel: self.foodModel, from: nil)
        classModel.主菜 = self.主菜.copyModel()
        classModel.汤 = self.汤.copyModel()
        classModel.配菜 = self.配菜.copyModel()
        classModel.dic = ["主菜":classModel.主菜,"汤":classModel.汤,"配菜":classModel.配菜]
        return classModel
    }
}
