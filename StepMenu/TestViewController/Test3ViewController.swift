//
//  Test3ViewController.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/30.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let c = CGFloat(arc4random_uniform(255)) / 255.0
        self.backgroundColor = UIColor(red: c, green: c, blue: c, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(0, 0, 100, 44)
        titleLabel.font = UIFont.systemFontOfSize(12)
        titleLabel.textColor = UIColor(red: 1 - c, green: 1 - c, blue: 1 - c, alpha: 1 - c)
        titleLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Test3ViewController: UIViewController, AUUStepMenuDelegate {

    var stepMenu : AUUStepMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        stepMenu = AUUStepMenu(frame: CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64))
        stepMenu.delegate = self
        stepMenu.itemSource = ["A", "b", "c", ["d" : ["e", "f", "g", ["h" : ["i" : ["j" : ["k" : "l"]]]]]], "m", "n", "o", "p", "q", "r", "s", "t", "u"]
        self.view.addSubview(stepMenu)
    }
    
    func stepMenu(registerItemCellClassForMenu: AUUStepMenu) -> AnyClass! {
        return TestTableViewCell.self
    }
    
    func stepMenu(menu: AUUStepMenu, dequenceForMenuItemCell cell: UITableViewCell!, menuItemData data: AnyObject!) {
        let cell = cell as! TestTableViewCell
        if data is String {
            cell.titleLabel.text = data as? String
        }
        else if data is Dictionary<String, AnyObject> {
            cell.titleLabel.text = (data as! Dictionary<String, AnyObject>).keys.first
        }
        else if data is TestModel {
            cell.titleLabel.text = (data as! TestModel).title
        }
    }
    
    func stepMenu(menu: AUUStepMenu, selectedWithMenuIndex menuIndex: Int, menuItemIndexPath indexPath: NSIndexPath, containedItemData data: AnyObject?) -> [AnyObject]? {
        if arc4random_uniform(2) == 0 {
            var datas:[TestModel] = []
            for _ in 0..<arc4random_uniform(10) + 1 {
                datas.append(TestModel(title: "\(menuIndex) - \(indexPath.row) - \(arc4random_uniform(10000))"))
            }
            return datas
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
