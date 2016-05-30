//
//  Test1ViewController.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/30.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

class Test1ViewController: UIViewController, AUUStepMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let stepMenu = AUUStepMenu(frame: CGRect(x: 0, y: 120, width: self.view.bounds.size.width, height: 300))
        
        stepMenu.itemSource = ["A", "b", "c", ["d" : ["e", "f", "g", ["h" : ["i" : ["j" : ["k" : "l"]]]]]], "m", "n", "o", "p", "q", "r", "s", "t", "u"]
        stepMenu.delegate = self
        stepMenu.menuMargin = 10
        self.view.addSubview(stepMenu)
        
    }
    
    func stepMenu(menu: AUUStepMenu, createdMenuTableView tableView: UITableView, andMenuIndex index: Int) {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
        header.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
        let label = UILabel(frame: header.bounds)
        label.text = "Menu header for menuTable \(index)"
        label.autoresizingMask = .FlexibleWidth
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByCharWrapping
        header.addSubview(label)
        tableView.tableHeaderView = header
    }
    
    func stepMenu(menu: AUUStepMenu, heightForMenuIndex menuIndex: Int, menuItemIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
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
