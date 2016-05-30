//
//  Test2ViewController.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/30.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

class TestModel: NSObject {
    var title: String!
    init(title: String) {
        super.init()
        self.title = title
    }
}

class Test2ViewController: UIViewController, AUUStepMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let stepMenu = AUUStepMenu(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 120))
        stepMenu.delegate = self
        stepMenu.itemSource = ["a", "b", "c", "d", "e", "f"]
        self.view.addSubview(stepMenu)
    }
    
    func stepMenu(menu: AUUStepMenu, selectedWithMenuIndex menuIndex: Int, menuItemIndexPath indexPath: NSIndexPath, containedItemData data: AnyObject?) -> [Array<AnyObject>]? {
        if arc4random_uniform(2) == 0 {
            var datas:[Array<AnyObject>] = []
            for _ in 0..<arc4random_uniform(10) + 1 {
                var tempDatas : Array<TestModel> = []
                for _ in 0 ..< arc4random_uniform(10) + 1 {
                    tempDatas.append(TestModel(title: "\(menuIndex) - \(indexPath.row) - \(arc4random_uniform(10000))"))
                }
                datas.append(tempDatas)
            }
            return datas
        }
        
        return nil
    }
    
    func stepMenu(menu: AUUStepMenu, unpackUnexpectedItemData data: AnyObject, forMenuIndex idnex: Int, menuItemIndexPath indexPath: NSIndexPath) -> String! {
        let testData = data as! TestModel
        return testData.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
