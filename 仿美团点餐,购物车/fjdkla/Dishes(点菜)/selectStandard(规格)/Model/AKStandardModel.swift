//
//  AKStandardModel.swift
//  fjdkla
//
//  Created by AK on 2017/8/2.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class AKStandardModel: NSObject {
    var 分类      : String = ""
    var 副标题    : String = ""
    var 必选      : String = ""
    var 种类      : [AKStandardKindModel] = []
    
    var standardHelp: AKStandardHelp?
    
    override init(){
        super.init()
    }
    
    
    init(classify: String, from dictionary: [String:Any]!){
        super.init()
        standardHelp = AKStandardHelp()
        standardHelp?.standardModel = self
        分类 = classify
        副标题 = dictionary["副标题"] as! String
        必选 = dictionary["必选"] as! String
        let kinds = dictionary["种类"] as! [String]
        var kingArray = [AKStandardKindModel]()
        for king in kinds{
            kingArray.append(AKStandardKindModel(name: king, standardHelp: standardHelp!))
        }
        种类 = kingArray
    }
    
    func copyModel()->AKStandardModel{
        let model = AKStandardModel()
        model.分类 = self.分类
        model.副标题 = self.副标题
        model.必选 = self.必选
        model.standardHelp = AKStandardHelp()
        model.standardHelp?.standardModel = model
        var ary = [AKStandardKindModel]()
        for kind in self.种类{
            ary.append(kind.copyModel(model.standardHelp))
        }
        model.种类 = ary
        return model
    }
}




class AKStandardKindModel{
    var 名称 = ""
    var count = 0
    var isMax = false
    
    var kingCount: Int{
        get{ return count }
        set{
            standardHelp?.checkMax(current: self, newValue: newValue)
        }
    }
    
    weak var standardHelp: AKStandardHelp?
    
    init(name: String,standardHelp: AKStandardHelp?) {
        self.名称 = name
        self.standardHelp = standardHelp
    }
    
    func copyModel(_ standardHelp: AKStandardHelp?)->AKStandardKindModel{
        let model = AKStandardKindModel(name: self.名称, standardHelp: standardHelp)
        model.count = self.count
        return model
    }
}
