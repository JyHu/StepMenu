//
//  Test0ViewController.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/30.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

class Test0ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let testDats = ["A", "b", "c", ["d" : ["e", "f", "g", ["h" : ["i" : ["j" : ["k" : "l"]]]]]], "m", "n", "o", "p", "q", "r", "s", "t", "u"]
        
        let stepMenu = AUUStepMenu(frame: CGRect(x: 0, y: 120, width: self.view.bounds.size.width, height:200 ), itemSource: testDats)
        stepMenu.selecteCompletion { (menuIndex, itemIndexPath, itemData) in
            print("\(menuIndex), \(itemIndexPath), \(itemData)")
        }
        self.view.addSubview(stepMenu)
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
