//
//  Test4ViewController.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/30.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

class Test4ViewController: UIViewController, AUUStepMenuDelegate, AUUStepMenuDatasource {

    var stepMenu : AUUStepMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        stepMenu = AUUStepMenu(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64))
        stepMenu.delegate = self
        stepMenu.datasource = self
        self.view.addSubview(stepMenu)
        
    }
    
    func stepMenu(menu: AUUStepMenu, numberOfSectionsForMenuIndex menuIndex: Int) -> Int {
        return Int(arc4random_uniform(10) + 1)
    }
    
    func stepMenu(menu: AUUStepMenu, numberOfItemsForMenuIndex menuIndex: Int, groupSection section: Int) -> Int {
        return Int(arc4random_uniform(20) + 1)
    }
    
    func stepMenu(menu: AUUStepMenu, cellForMenuIndex menuIndex: Int, menuItemIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reusefulIdentifier = "reusefulIdentifier"
        let tableView = menu.menuTableAtIndex(menuIndex) as UITableView!
        var cell = tableView.dequeueReusableCellWithIdentifier(reusefulIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: reusefulIdentifier)
        }
        cell?.textLabel?.text = "\(arc4random_uniform(10000))"
        return cell!
    }

    func stepMenu(menu: AUUStepMenu, hasAdditionalMenuForMenuIndex menuIndex: Int, currentMenuItemIndexPath indexPath: NSIndexPath) -> Bool {
        
        return arc4random_uniform(2) == 1
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
