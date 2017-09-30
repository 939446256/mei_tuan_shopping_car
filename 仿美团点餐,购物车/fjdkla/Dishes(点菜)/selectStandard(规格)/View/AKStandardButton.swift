//
//  AKStandardButton.swift
//  fjdkla
//
//  Created by AK on 2017/8/2.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit
protocol AKFoodStandardButtonDelegate{
    func clickStandardButton(_ badge: Int,_ kingModel: AKStandardKindModel)
}

class AKStandardButton: UIButton {
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        setupButton(title)
    }
    

    func setupButton(_ title: String){
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.setTitleColor(UIColor.orange, for: .selected)
        self.layer.cornerRadius  = 4
        self.layer.borderColor   = UIColor.black.cgColor
        self.layer.borderWidth   = 1
        self.addTarget(self, action: #selector(self.clickStandardBtn), for: .touchUpInside)
    }
    
    func clickStandardBtn(_ btn: UIButton){
        if btn.isSelected{
            btn.isSelected = false
            btn.layer.borderColor   = UIColor.black.cgColor
        }else{
            btn.isSelected = true
            btn.layer.borderColor   = UIColor.orange.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//继承
class AKFoodStandardButton: AKStandardButton{
    weak var classifyStandardModel: AKClassifyStandardModel?
    
    var badgeLabel: UILabel?
    var foodStandardDelegate: AKFoodStandardButtonDelegate?
    var kingModel: AKStandardKindModel?
    var badge: Int = 0{
        didSet{
            if badge >= 1{
                self.isSelected = true
                self.layer.borderColor   = UIColor.orange.cgColor
                
                print("\(kingModel!.名称): \(badge)")
                self.layer.borderColor   = UIColor.orange.cgColor
                if badge > 1{
                    if let flatL = badgeLabel{
                        flatL.isHidden = false
                        flatL.text = "\(badge)"
                    }
                }
            }else{
                self.isSelected = false
                self.badgeLabel?.isHidden = true
            }
        }
    }
    
    init(kingModel: AKStandardKindModel, frame: CGRect) {
        super.init(title: kingModel.名称, frame: frame)
        self.kingModel = kingModel
        buildBadge()
        self.badge = kingModel.kingCount
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadStandardButton), name: NSNotification.Name(rawValue: "reloadStandardButton"), object: nil)
    }
    
    
    func reloadStandardButton(){
        //更新数据
        badge = kingModel!.kingCount
        if kingModel!.kingCount == 0{
            //判断该类别是否选满
            if kingModel!.isMax{
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.setTitleColor(UIColor.lightGray, for: .normal)
            }else{
                self.layer.borderColor = UIColor.black.cgColor
                self.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildBadge(){
        
        let lab = UILabel()
        lab.text = ""
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.orange
        lab.font = UIFont.systemFont(ofSize: 10)
        lab.clipsToBounds = true    
        lab.textAlignment = .center
        lab.layer.cornerRadius = 10
        lab.isHidden = true
        self.addSubview(lab)
        lab.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        lab.center = CGPoint(x: self.frame.size.width, y: 0)
        badgeLabel = lab
    }
    
    
    override func clickStandardBtn(_ btn: UIButton) {
        guard let kingModel = self.kingModel else{return}
        if btn.isSelected{
            kingModel.kingCount += 1
        }else{
            kingModel.kingCount = 1
        }
        badge = kingModel.kingCount
        
        foodStandardDelegate?.clickStandardButton(badge, kingModel)
    }
    
    deinit {
        //释放通知接受者身份
        NotificationCenter.default.removeObserver(self)
    }
}
