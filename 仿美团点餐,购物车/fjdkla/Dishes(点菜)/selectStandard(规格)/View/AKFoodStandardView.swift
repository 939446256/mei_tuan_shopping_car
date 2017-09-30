//
//  AKFoodStandardView.swift
//  fjdkla
//
//  Created by AK on 2017/8/1.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

protocol AKFoodStandardViewDelegate{
    func clickCanel()
}

class AKFoodStandardView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countPriceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addShoppingCarButton: UIButton!
    
    var delegate: AKFoodStandardViewDelegate?
    let viewModel = AKShoppingViewModel.share
    var standardModelArray = [AKStandardModel]()
    
    let testDic = [
        "主菜":[
            "副标题":"固定",
            "必选":"1",
            "种类":["拌面"]
        ],
        "汤":[
            "副标题":"3选1",
            "必选":"1",
            "种类":["海带汤","冬瓜汤","玉米汤"]
        ],
        "配菜":[
            "副标题":"5选2",
            "必选":"2",
            "种类":["牛肉","猪肉","羊肉","鱼肉"]
        ]
    ]
    
    var currentModel: AKClassifyStandardModel?{
        didSet{
            if let model = currentModel { foodStandardNumber = model.count }
        }
    }
    
    var shoppingCarModel: AKClassifyStandardModel?{
        didSet{
            if let model = shoppingCarModel { foodStandardNumber = model.count }
        }
    }
    
    
    var foodInfoModel: FoodModel?{
        didSet{
            foodStandardNumber = foodInfoModel?.count ?? 0
            request()
            addTitle()
        }
    }
    
    var foodStandardNumber = 0{
        didSet{
            if foodStandardNumber > 0 {
                addShoppingCarButton.isHidden = true
                plusButton.isHidden = false
                minusButton.isHidden = false
                countLabel.isHidden = false
            }else{
                addShoppingCarButton.isHidden = false
                plusButton.isHidden = true
                minusButton.isHidden = true
                countLabel.isHidden = true
            }
            countLabel.text = "\(foodStandardNumber)"
            guard let model = foodInfoModel else{return}
            countPriceLabel.text = "¥\(countPrice(model))"
        }
    }
    
    //MARK: - 初始化
    //================= 初始化 =================
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    /// 加载Nib
    class func loadNib() -> AKFoodStandardView?{
        return Bundle.main.loadNibNamed("AKFoodStandardView", owner: nil, options: nil)?.last as? AKFoodStandardView
    }
    
    /// 模拟发送请求
    func request(){
        guard let infoM = foodInfoModel else{return}
        currentModel = AKClassifyStandardModel(foodModel: infoM, from: testDic)
    }
    
    /// 创建小标题
    func addTitle(){
        var bottomToTitle: CGFloat = 0
        var standardModelArray = [AKStandardModel]()
        print("替换后 根据\(currentModel!)")
        for (i,model) in currentModel!.dic.enumerated(){
            let x       : CGFloat = 0
            let y       : CGFloat = bottomToTitle
            let height  : CGFloat = 60
            let width   : CGFloat = 0
            let frame = CGRect(x: x, y: y, width: width, height: height)
            //快速创建UILabel方法
            func createLabel() -> UILabel{
                let titleLabel: UILabel = UILabel()
                titleLabel.sizeToFit()
                self.scrollView.addSubview(titleLabel)
                return titleLabel
            }
            //创建 标题一
            let titleLabel1 = createLabel()
            titleLabel1.text    = model.value.分类
            titleLabel1.font = UIFont.boldSystemFont(ofSize: 15)
            titleLabel1.sizeToFit()
            titleLabel1.frame = CGRect(x: x, y: y, width: titleLabel1.frame.size.width, height: height)
            //创建 标题二
            let titleLabel2 = createLabel()
            titleLabel2.text    = model.value.副标题
            titleLabel2.textColor = UIColor.lightGray
            titleLabel2.sizeToFit()
            titleLabel2.frame = CGRect(x: x + titleLabel1.frame.size.width + 5, y: y, width: titleLabel2.frame.size.width, height: height)
            //创建 清空按钮
            
            let clearButton = UIButton()
            clearButton.setTitle("清空", for: .normal)
            clearButton.setTitleColor(UIColor.lightGray, for: .normal)
            clearButton.addTarget(self, action: #selector(self.clickClearButton), for: .touchUpInside)
            clearButton.sizeToFit()
            clearButton.tag = i
            clearButton.frame = CGRect(x: SCREEN_WIDTH - 80 - 44, y: y, width: 44, height: height)
            standardModelArray.append(model.value)
            if model.value.种类.count > 1{
                //添加到scrollView上
                self.scrollView.addSubview(clearButton)
            }
            //            print("组y: \(titleLabel1.frame.origin.y)")
            //添加后的标题底部位置
            let btnsTop = bottomToTitle + titleLabel1.frame.size.height
            //遍历选项按钮
            bottomToTitle = self.addButtons(from: btnsTop, ary: model.value.种类)
        }
        self.standardModelArray = standardModelArray
        //根据数据,扩展scroll内容
        self.scrollView.contentSize = CGSize(width: 0, height: bottomToTitle + 20)
        //根据scroll扩展后大小,改变self的高度,最大不超过(屏幕高度 - 80)
        var foodSandardHeight = bottomToTitle + 20 + 64 + 64
        if foodSandardHeight > SCREEN_HEIGHT - 80 { foodSandardHeight = SCREEN_HEIGHT - 80 }
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 40, height: foodSandardHeight)
        self.center = KEY_WINDOW!.center
    }
    
    /// 遍历选项创建按钮
    func addButtons(from top: CGFloat, ary: [AKStandardKindModel]) -> CGFloat{
        var bottom  : CGFloat = top
        let space   : CGFloat = 20
        let btnWidth  = (SCREEN_WIDTH - 80) / 3 - space
        for (i,standard) in ary.enumerated(){
            let height  : CGFloat = 40
            let x       : CGFloat = CGFloat(i % 3) * btnWidth + space * (CGFloat(i % 3))
            let y       : CGFloat = CGFloat(i / 3) * height + top + space * (CGFloat(i / 3))
            print("传入\(standard.名称): \(standard.kingCount)")
            let btn = AKFoodStandardButton(kingModel: standard, frame: CGRect(x: x, y: y, width: btnWidth, height: height))
            btn.foodStandardDelegate = self
            self.scrollView.addSubview(btn)
            //如果可选只有一种则默认 选择,并无法再点击
            if ary.count == 1 { btn.clickStandardBtn(btn); btn.isUserInteractionEnabled = false}
            else{
                //循环 实现点击功能,已选好的项
                for _ in 0..<standard.kingCount{ btn.clickStandardBtn(btn) }
            }
            if i == ary.count - 1{
                bottom = y + height
            }
            //            print("按钮\(i): \(btn.frame)")
        }
        //        print("底部Y: \(bottom)")
        return bottom
    }
    
    //MARK: - 功能方法
    //================= 功能方法 =================
    /// 合计价格
    func countPrice(_ foodInfoModel: AKShoppingViewItemDelegate) -> Double{
        let price = foodInfoModel.price?.doubleValue ?? 0
        let count = Double(self.foodStandardNumber)
        return price * count
    }
    /// 判断购物车按钮是否可用
    func resetAddShoppingButton(){
        if checkCanAddShopping(){
            addShoppingCarButton.isUserInteractionEnabled = true
            addShoppingCarButton.backgroundColor = UIColor.orange
        }else{
            addShoppingCarButton.isUserInteractionEnabled = false
            addShoppingCarButton.backgroundColor = UIColor.lightGray
        }
    }
    
    /// 判断是否满足条件
    func checkCanAddShopping()->Bool{
        guard let classifyModel = currentModel else{return false}
        
        var maxNumber = 0
        for model in classifyModel.dic{
            guard let max = Int(model.value.必选) else{return false}
            var sum = 0
            for kind in model.value.种类{
                sum += kind.count
            }
            if max == sum{
                maxNumber += 1
            }
        }
        return classifyModel.dic.count == maxNumber
    }
    
    
    //MARK: - 响应事件
    //================= 响应事件 =================
    /// 点击 取消按钮
    @IBAction func clickCancelButton(_ sender: UIButton) {
        delegate?.clickCanel()
    }
    
    /// 点击 加入购物车按钮
    @IBAction func clickAddShoppingCarButton(_ sender: UIButton) {
        if let model = currentModel {
//            count += 1
            model.套餐名 = foodInfoModel?.name
            model.count += 1
            print("加入购物车: \(model)")
            shoppingCarModel = model
            viewModel.resetItem(model)
            //清除UIButton
            print("清除UIButton-------")
            for view in self.scrollView.subviews{
                view.removeFromSuperview()
            }
            //新建模型
            currentModel = shoppingCarModel?.copyModel()
            print("替换后 currentModel: \(currentModel!)-------shoppingCarModel:\(shoppingCarModel!)")
            //重新加载 模型到按钮上
            addTitle()
        }
    }
    
    /// 点击 +按钮
    @IBAction func clickPlusButton(_ sender: UIButton) {
        guard let shoppingM = shoppingCarModel else{return}
        foodStandardNumber += 1
        shoppingM.count += 1
        viewModel.resetItem(shoppingM)
        
    }
    
    /// 点击 -按钮
    @IBAction func clickMinusButton(_ sender: UIButton) {
        guard let shoppingM = shoppingCarModel else{return}
        foodStandardNumber -= 1
        shoppingM.count -= 1
        viewModel.resetItem(shoppingM)
    }
    
    /// 点击 分类清除按钮
    func clickClearButton(_ btn: UIButton){
        print("点击清除")
        let standard = standardModelArray[btn.tag]
        standard.standardHelp?.clearStandardModel()
    }
    
}

//MARK: - 规格按钮响应
//================= 规格按钮响应 =================
extension AKFoodStandardView: AKFoodStandardButtonDelegate{
    /// 触发 点击规格按钮
    func clickStandardButton(_ badge: Int, _ kingModel: AKStandardKindModel) {
        print("当前的选择的套餐: \(currentModel!)")
        //遍历寻找购物车里是否有相同的类
        for shoppingCarModel in viewModel.models{
            //找出输入规格类的
            if let shoppingCarM = shoppingCarModel as? AKClassifyStandardModel, let infoM = foodInfoModel{
                //找出套餐名相同的
                if shoppingCarM.套餐名 == infoM.name{
                    print("打印购物车上的套餐: \(shoppingCarM)")
                    //开始比较
                    if isSame(model1: currentModel!, model2: shoppingCarM){
                        self.shoppingCarModel = shoppingCarM
                        print("相同的套餐选项: \(currentModel!) 和 \(shoppingCarM)")
                        return
                    }
                }
            }
        }
        resetAddShoppingButton()
        self.foodStandardNumber = 0
    }
    
    /// 判断 当前model跟 购物车 相同
    func isSame(model1: AKClassifyStandardModel,model2: AKClassifyStandardModel) -> Bool{
        for key in model1.dic.keys{
            guard let standardM1 = model1.dic[key], let standardM2 = model2.dic[key] else{return false}
            for (i,kind) in standardM1.种类.enumerated(){
                print("XXXX\(kind.名称) 数量\(kind.kingCount):\(standardM2.种类[i].名称) 数量\(standardM2.种类[i].kingCount)")
                guard kind.名称 == standardM2.种类[i].名称 else{return false}
                guard kind.kingCount == standardM2.种类[i].kingCount else{return false}
            }
        }
        return true
    }
}
