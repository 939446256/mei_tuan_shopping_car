//
//  AKStandardViewController.swift
//  fjdkla
//
//  Created by AK on 2017/8/1.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

class AKStandardViewController: UIViewController {

    fileprivate var standardView: AKFoodStandardView?
    var foodInfoModel: FoodModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = AKFoodStandardView.loadNib(){
            standardView = view
            view.delegate = self
            view.foodInfoModel = foodInfoModel
            self.view.addSubview(view)
            view.center = self.view.center
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadStandard), name: NSNotification.Name(rawValue: "reloadStandardButton"), object: nil)
    }
    
    //监听 清空按钮,重置购物车按钮
    func reloadStandard(){
        guard let standardView = self.standardView else{return}
        standardView.resetAddShoppingButton()
        standardView.foodStandardNumber = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
        
    }

    deinit {
        //释放通知接受者身份
        NotificationCenter.default.removeObserver(self)
    }
}

extension AKStandardViewController: AKFoodStandardViewDelegate{
    func clickCanel() {
        self.dismiss(animated: true, completion: nil)
    }
}
