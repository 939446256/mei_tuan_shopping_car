//
//  AKShoppingCarController
//  fjdkla
//
//  Created by AK on 2017/7/31.
//  Copyright © 2017年 DayLife_Warehouse. All rights reserved.
//

import UIKit

///屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.width
///屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.height
///主窗口
let KEY_WINDOW = UIApplication.shared.keyWindow

class AKShoppingCarController: UIViewController {
    var viewModel = AKShoppingViewModel.share
    
    lazy var shoppingTableView: AKShoppingCarTableView = AKShoppingCarTableView()
    
    var shoppingTopView: AKShoppingTopView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        buildShoppingTableView()
        shoppingTopView = AKShoppingTopView.loadNib()
        
    }
    
    func buildShoppingTableView(){
        shoppingTableView.delegate = self
        shoppingTableView.dataSource = self
        shoppingTableView.rowHeight = 50
        shoppingTableView.register(UINib(nibName: "AKShoppingCarCellTableViewCell", bundle: nil), forCellReuseIdentifier: "AKShoppingCarCellTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTableView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hiddenTableView()
    }
    
    ///显示购物车
    private func showTableView(){
        self.shoppingTableView.reloadData()
        self.shoppingTableView.isHidden = false
        
        
        self.shoppingTopView?.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 44)
        self.view.addSubview(self.shoppingTableView)
        self.view.addSubview(shoppingTopView!)
        self.view.addSubview(shoppingTableView.shoppingCarBottomView)
        //动画效果
        self.shoppingTableView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 200)
        UIView.animate(withDuration: 0.3, animations: {
            self.shoppingTableView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 64 - 200, width: SCREEN_WIDTH, height: 200)
            self.shoppingTopView?.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 64 - 200 - 44, width: SCREEN_WIDTH, height: 44)
        })
    }
    
    ///隐藏购物车
    func hiddenTableView(){
        //动画效果
        UIView.animate(withDuration: 0.3, animations: {
            self.shoppingTableView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 200)
            self.shoppingTopView?.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 44)
        }, completion: { (competion) in
            self.dismiss(animated: true, completion: nil)
        })
    }
}


extension AKShoppingCarController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AKShoppingCarCellTableViewCell") as? AKShoppingCarCellTableViewCell
        if let m = viewModel.models[indexPath.row] as? AKShoppingViewItemDelegate{
            cell?.model = m
        }
        cell?.delegate = self
        return cell!
    }
}



extension AKShoppingCarController: AKShoppingCarCellTableViewCellDelegate{
    func reloadDate(_ model: AKShoppingViewItemDelegate) {
        viewModel.resetItem(model)
        self.shoppingTableView.reloadData()
    }
}
