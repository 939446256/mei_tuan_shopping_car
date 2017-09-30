//
//  AKDishesViewController.swift
//  DayLife
//
//  Created by AK on 2017/8/4.
//  Copyright © 2017年 影子恋人. All rights reserved.
//

import UIKit

class AKDishesViewController: UIViewController {
    var dataArray = [
        ["id": 9323283,
         "name": "马可波罗意面",
         "min_price": 12.0,
         "praise_num": 20,
         "picture":"1.png",
         "month_saled":12],
        ["id": 9323284,
         "name": "鲜珍焗面",
         "min_price": 28.0,
         "praise_num": 6,
         "picture":"2.png",
         "month_saled":34],
        ["id": 9323285,
         "name": "经典焗面",
         "min_price": 28.0,
         "praise_num": 8,
         "picture":"3.png",
         "month_saled":16],
        ["id": 26844943,
         "name": "摩洛哥烤肉焗饭",
         "min_price": 32.0,
         "praise_num": 1,
         "picture":"4.png",
         "month_saled":56],
        ["id": 9323279,
         "name": "莎莎鸡肉饭",
         "min_price": 29.0,
         "praise_num": 11,
         "picture":"5.png",
         "month_saled":11],
        ["id": 9323289,
         "name": "曼哈顿海鲜巧达汤",
         "min_price": 22.0,
         "praise_num": 2,
         "picture":"6.png",
         "month_saled":5],
        ["id": 9323243,
         "name": "意式香辣12寸传统",
         "min_price": 72.0,
         "praise_num": 0,
         "picture":"7.png",
         "month_saled":19],
        ["id": 9323220,
         "name": "超级棒约翰9寸卷边",
         "min_price": 64.0,
         "praise_num": 28,
         "picture":"8.png",
         "month_saled":7],
        ["id": 9323280,
         "name": "牛肉培根焗饭",
         "min_price": 30.0,
         "praise_num": 48,
         "picture":"9.png",
         "month_saled":0],
        ["id": 9323267,
         "name": "胡椒薯格",
         "min_price": 16.0,
         "praise_num": 9,
         "picture":"10.png",
         "month_saled":136]
    ]
    
    
    @IBOutlet weak var foodMenuCategoryTableView: UITableView!
    @IBOutlet weak var foodInfoTableView        : UITableView!
    @IBOutlet weak var shoppingView             : UIView!
    
    var isSelectedCell                      = false
    var viewModel                           = AKShoppingViewModel.share
    var sectionHeaderNumbers: [Int]         = []
    var dataModels          : [FoodModel]   = []
    var foodCellID                          = "FoodCell"
    var shoppingCarView     : AKShoppingCarView?
    var shoppingCarController: AKShoppingCarController = AKShoppingCarController()
    
    class func loadNib()->AKDishesViewController{
        return AKDishesViewController(nibName: "AKDishesViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildShoppingCarView()
        setupTableView()
        request()
        NotificationCenter.default.addObserver(self, selector: #selector(self.foodInfoTableViewReloadData), name: NSNotification.Name(rawValue: "ViewModelReloadDate"), object: nil)
    }
    
    func buildShoppingCarView(){
        let shoppingCarView = Bundle.main.loadNibNamed("AKShoppingCarView", owner: nil, options: nil)?.last as! AKShoppingCarView
        shoppingCarView.delegate = self
        shoppingCarView.frame = shoppingView.bounds
        shoppingView.addSubview(shoppingCarView)
        self.shoppingCarView = shoppingCarView
    }
    
    func setupTableView(){
        foodMenuCategoryTableView.register(UINib(nibName: "AKMenucategoryCell", bundle: nil), forCellReuseIdentifier: "测试")
        foodInfoTableView.register(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: foodCellID)
        foodMenuCategoryTableView.delegate = self
        foodInfoTableView.delegate = self
        foodMenuCategoryTableView.dataSource = self
        foodInfoTableView.dataSource = self
        foodMenuCategoryTableView.estimatedRowHeight = 44
        foodInfoTableView.estimatedRowHeight = 44
    }
    
    func request(){
        for data in dataArray{
            let model = FoodModel()
            model.dic = data
            dataModels.append(model)
        }
    }
    
    func foodInfoTableViewReloadData(){
        foodInfoTableView.reloadData()
    }
    
    deinit {
        //释放通知接受者身份
        NotificationCenter.default.removeObserver(self)
    }
}


extension AKDishesViewController: FoodCellDelegate{
    func clickStantardButton(_ foodInfoModel: FoodModel) {
        let vc = AKStandardViewController()
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.foodInfoModel = foodInfoModel
        self.present(vc, animated: true, completion: nil)
    }
    
    ///点击 减少
    func checkMinusButton(_ foodInfoModel: FoodModel) {
        viewModel.resetItem(foodInfoModel)
    }
    
    ///点击 增加
    func checkPlusButton(_ foodInfoModel: FoodModel) {
        viewModel.resetItem(foodInfoModel)
    }
}

//MARK: - tableView数据源方法
//================= tableView数据源方法 =================
extension AKDishesViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == foodMenuCategoryTableView{
            return 1
        }else{
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == foodMenuCategoryTableView{
            return 20
        }else{
            if section == 9{
                return 1
            }
            return dataModels.count
        }
    }
    
    //返回sectionheader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == foodInfoTableView{
            //添加头部
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            lab.text = "\(section + 1)"
            lab.textColor = UIColor.black
            lab.sizeToFit()
            v.backgroundColor = UIColor.white
            v.addSubview(lab)
            return v
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == foodInfoTableView ? 44 : 0
    }
    
    /// UITableView 数据源方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curTableView = tableView == foodMenuCategoryTableView ? foodMenuCategoryTableView(tableView, cellForRowAt: indexPath) : foodInfoTableView(tableView, cellForRowAt: indexPath)
        return curTableView
    }
    
    /// foodMenuCategoryTableView 数据源方法
    func foodMenuCategoryTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "测试") as? AKMenucategoryCell
        switch indexPath.row {
        case 0: cell?.menuCategory = "热销"
        case 1: cell?.menuCategory = "推荐"
        case 2: cell?.menuCategory = "收藏"
        default: cell?.menuCategory = "123321123"
        }
        return cell!
    }
    
    /// foodInfoTableView 数据源方法
    func foodInfoTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: foodCellID) as? FoodCell
        cell?.delegate = self
        cell!.model = dataModels[indexPath.row]
        if indexPath.row % 2 == 0{
            cell?.cellType = .standard
        }else{
            cell?.cellType = .total
        }
        return cell!
    }
    
}


//MARK: - tableView代理方法
//================= tableView代理方法 =================
extension AKDishesViewController: UITableViewDelegate{
    /// 自动计算高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /// 分割线置顶
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins  = UIEdgeInsets.zero
    }
    
    //触发 点击Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == foodMenuCategoryTableView{
            //滚动对应的info表
            let headerIndexPath = IndexPath(row: 0, section: indexPath.row)
            isSelectedCell = true
            foodInfoTableView.scrollToRow(at: headerIndexPath, at: .top, animated: true)
        }
    }
    
    ///触发 组头部开始显示
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if sectionHeaderNumbers.last ?? 0 <= section{
            sectionHeaderNumbers.append(section)
        }else{
            sectionHeaderNumbers.insert(section, at: 0)
        }
        if isSelectedCell == false{
            //滚动Menu表
            let index = IndexPath(row: sectionHeaderNumbers.first!, section: 0)
            foodMenuCategoryTableView.selectRow(at: index, animated: true, scrollPosition: .middle)
            print("记录\(sectionHeaderNumbers)")
        }
    }
    
    ///触发 组头部结束显示
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        for (i,num) in sectionHeaderNumbers.enumerated(){
            if num == section { sectionHeaderNumbers.remove(at: i) }
        }
        print("移除\(section)")
        //判断 标记是否选择 滚动结束
        if isSelectedCell == false{
            //滚动Menu表
            guard let firstItem = sectionHeaderNumbers.first else{return}
            let index = IndexPath(row: firstItem, section: 0)
            foodMenuCategoryTableView.selectRow(at: index, animated: true, scrollPosition: .middle)
            print("记录\(sectionHeaderNumbers)")
        }
        
    }
    
    ///触发 滚动结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //标记滚动结束
        isSelectedCell = false
    }
}

extension AKDishesViewController: AKShoppingCarViewDelegate{
    func clickShoppingCarBtn() {
        let vc = AKShoppingCarController()
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}



