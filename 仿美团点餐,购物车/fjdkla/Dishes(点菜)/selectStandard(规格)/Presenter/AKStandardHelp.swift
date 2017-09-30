//
//  AKStandardHelp.swift
//  fjdkla
//
//  Created by AK on 2017/8/3.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class AKStandardHelp: NSObject {
    weak var standardModel: AKStandardModel?
    
    weak var lastKindModel: AKStandardKindModel?
    
    /// 检查已选项是否超过该类别的最大数
    func checkMax(current: AKStandardKindModel, newValue: Int){
        guard let standardModel = self.standardModel else{return}
        //守卫
        guard let max = Int(standardModel.必选) else{return}
        
        switch max{
        case 1:
            case
        }
        
        var sum = 0
        for kind in standardModel.种类{
            sum += kind.count
        }
        
        if max == 1{
            lastKindModel?.count = 0
            lastKindModel = current
            current.count = 1
            NotificationCenter.default.post(name: NSNotification.Name("reloadStandardButton"), object: nil)
            return
        }
        //判断已选项,是否少于最大值
        if max > sum{
            current.count = newValue
        }
        
        for kind in standardModel.种类{sum += kind.count}
        if max <= sum{
            for kind in standardModel.种类{
                kind.isMax = true
            }
            resetStandardButton()
        }
    }
    
    /// 发送通知到所有分类按钮上
    func resetStandardButton(){
        NotificationCenter.default.post(name: NSNotification.Name("reloadStandardButton"), object: nil)
    }
    
    /// 清除分类数据
    func clearStandardModel(){
        guard let standardModel = self.standardModel else{return}
        for king in standardModel.种类{
            king.count = 0
            king.isMax = false
        }
        resetStandardButton()
    }

    deinit {
        //释放通知接受者身份
        NotificationCenter.default.removeObserver(self)
    }
}
