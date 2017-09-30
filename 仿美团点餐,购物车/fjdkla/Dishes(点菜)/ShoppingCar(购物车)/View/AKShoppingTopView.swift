//
//  AKShoppingTopView.swift
//  fjdkla
//
//  Created by AK on 2017/8/3.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class AKShoppingTopView: UIView {
    
    class func loadNib()->AKShoppingTopView{
        return Bundle.main.loadNibNamed("AKShoppingTopView", owner: nil, options: nil)?.last as! AKShoppingTopView
    }

    @IBAction func clickClearButton(_ sender: Any) {
        AKShoppingViewModel.share.clearModels()
    }
}
