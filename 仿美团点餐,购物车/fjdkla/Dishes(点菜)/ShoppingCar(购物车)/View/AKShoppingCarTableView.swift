//
//  AKShoppingCarTableView.swift
//  fjdkla
//
//  Created by AK on 2017/7/31.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class AKShoppingCarTableView: UITableView {
    /// 添加购物车低栏
    lazy var shoppingCarBottomView: AKShoppingCarView = {
        let shoppingCarView = Bundle.main.loadNibNamed("AKShoppingCarView", owner: nil, options: nil)?.last as! AKShoppingCarView
        shoppingCarView.frame = CGRect(x: 0,
                                       y: SCREEN_HEIGHT - 64,
                                       width: SCREEN_WIDTH,
                                       height: 64)
        return shoppingCarView
    }()
    
    
    //MARK: - 初始化
    //================= 初始化 =================
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        let tableViewW = UIScreen.main.bounds.size.width
        self.frame      = CGRect(x: 0, y: 0, width: tableViewW, height: 200)
        self.isHidden   = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shoppingTableViewReloadData), name: NSNotification.Name(rawValue: "ViewModelReloadDate"), object: nil)
    }
    
    func shoppingTableViewReloadData(){
        self.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //释放通知接受者身份
        NotificationCenter.default.removeObserver(self)
    }
    
}
