//
//  Test6ViewController.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/30.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

class Test6ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let testData = [["a", "b", "c", ["d", "e", "f", ["i", "j", "k"]], "g", "h"]]
        
        let stepMenu = AUUStepMenu(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), itemSource: testData)
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
