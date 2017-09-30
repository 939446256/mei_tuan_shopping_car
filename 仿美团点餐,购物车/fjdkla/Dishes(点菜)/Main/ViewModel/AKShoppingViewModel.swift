//
//  AKShoppingViewModel.swift
//  fjdkla
//
//  Created by AK on 2017/7/28.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit
//重写运算符 转换协议为实例,并比较是否同一内存
private func == (_ t1: AKShoppingViewItemDelegate,_ t2: AKShoppingViewItemDelegate)->Bool{
    guard let obj1 = t1 as? NSObject, let obj2 = t2 as? NSObject else{return false}
    return obj1 == obj2
}

//只有Model中继承了该协议,才能加入购物车
protocol AKShoppingViewItemDelegate {
    var count: Int {get set}
    var price: NSNumber? {get}
//    var name:  String? {get set}
}

//MARK: - 购物车ViewModel
//================= 动态加入和删除购物车 =================
class AKShoppingViewModel: NSObject {
    //统一数据管理
    var models: Array<AKShoppingViewItemDelegate> = []
    
    //单例
    static let share = AKShoppingViewModel()
    
    ///清空购物车数据
    func clearModels(){
        for model in models{
            if let foodModel = model as? FoodModel{
                foodModel.count = 0
            }else if let classifyModel = model as? AKClassifyStandardModel{
                classifyModel.count = 0
                classifyModel.foodModel?.count = 0
            }
        }
        models.removeAll()
        //发送 数据修改通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ViewModelReloadDate"), object: nil)
    }
    
    //移除或增加到models数组
    func resetItem(_ model: AKShoppingViewItemDelegate){
        //判断传入Model的数量
        if model.count <= 0{
            //移除对应的项
            delete(model)
        }else{
            add(model)
        }
        
        //发送 数据修改通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ViewModelReloadDate"), object: nil)
    }
    
    //移除对应的项
    func delete(_ item: AKShoppingViewItemDelegate){
        if let row = search(item){
            models.remove(at: row)
        }
    }
    
    //增加到models数组
    func add(_ item: AKShoppingViewItemDelegate){
        if search(item) != nil{
            return
        }else{
            models.append(item)
        }
    }
    
    //遍历搜索是否存在于models数组
    func search(_ item: AKShoppingViewItemDelegate)->Int?{
        var row: Int?
        for (i,delegate) in models.enumerated(){
            if item == delegate{
                row = i;break
            }
        }
        return row
    }
    
}
