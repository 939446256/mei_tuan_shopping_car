//
//  UIView+Extension.swift
//  fjdkla
//
//  Created by AK on 2017/7/31.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

extension UIView {
    //展示弹框
    class func showContent(_ contenView: UIView, in mainView: UIView) -> UIView{
        //创建显示界面
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        contenView.center = backView.center
        
        backView.addSubview(contenView)
        mainView.addSubview(backView)
        //添加手势 移除
        let tap = UITapGestureRecognizer(target: backView, action: #selector(self.deinitView))
        backView.addGestureRecognizer(tap)
        return backView
    }
    
    //移除
    func deinitView(_ tap: UIGestureRecognizer){
        tap.view
        //渐隐消失
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (comp) in
            self.removeFromSuperview()
        }
    }
}
