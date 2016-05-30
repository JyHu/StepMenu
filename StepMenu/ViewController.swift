//
//  ViewController.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/29.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var table: UITableView!
    var testVCs: [Dictionary<String, String>]! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.table = UITableView(frame: self.view.bounds, style: .Grouped)
        self.table.delegate = self
        self.table.dataSource = self
        self.view.addSubview(self.table)
        
        testVCs = [["测试0": "Test0ViewController"],
                   ["测试1": "Test1ViewController"],
                   ["测试2": "Test2ViewController"],
                   ["测试3": "Test3ViewController"],
                   ["测试4": "Test4ViewController"],
                   ["测试5": "Test5ViewController"],
                   ["测试6": "Test6ViewController"]]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testVCs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reusefulIdentifier") as UITableViewCell?
        if  cell == nil  {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "reusefulIdentifier")
        }
        
        let dict = testVCs[indexPath.row]
        cell?.textLabel?.text = dict.keys.first
        
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  let vc = testVCs[indexPath.row].values.first?.createVC {
            vc.title = testVCs[indexPath.row].keys.first
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


private extension String {
    var createVC:UIViewController? {
        if let executableFile = NSBundle.mainBundle().infoDictionary {
            if let executableFileName = executableFile["CFBundleExecutable"] {
                if let type = NSClassFromString("\(executableFileName).\(self)") as? UIViewController.Type {
                    let viewController = type.init()
                    return viewController
                }
            }
        }
        
        return nil
    }
}

