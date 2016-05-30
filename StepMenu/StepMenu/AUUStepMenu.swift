//
//  AUUStepMenu.swift
//  StepMenu
//
//  Created by 胡金友 on 16/5/29.
//  Copyright © 2016年 胡金友. All rights reserved.
//

import UIKit

private let __menuStartTag : Int = 888888   // 第一个菜单开始的tag
private let __defaultAnimationDuration : Double = 0.35  // 菜单位置改变的动画时间
private let __reusefulCellIdentifier : String = "__reusefulCellIdentifier"  // 复用的菜单项的cell的标识

public typealias AUUStepMenuSelectCompletion = (menuIndex: Int, itemIndexPath: NSIndexPath, itemData: AnyObject?) -> Void   // 选择菜单以后的回调block

// 多级菜单的代理方法
@objc protocol AUUStepMenuDelegate {
    
    /**
     每当创建一个子目录的table的时候就会调用这个代理方法，可以在这里对table进行一些自定义的操作
     
     - parameter menu:      self
     - parameter tableView: 当前创建的table
     - parameter index:     当前创建的table目录的索引，从0开始
     */
    optional func stepMenu(menu: AUUStepMenu, createdMenuTableView tableView: UITableView, andMenuIndex index: Int)
    
    /**
     设置每个item的菜单项的高度
     
     - parameter menu:      self
     - parameter menuIndex: 当前目录的索引
     - parameter indexPath: 当前目录中菜单项的索引
     
     - returns: 菜单项的高度
     */
    optional func stepMenu(menu: AUUStepMenu, heightForMenuIndex menuIndex: Int, menuItemIndexPath indexPath: NSIndexPath) -> CGFloat
    
    /**
     当选择了菜单中的任何一项的时候会调用这个方法
     
     - parameter menu:      self
     - parameter menuIndex: 被选择的目录的索引
     - parameter indexPath: 被选择的目录菜单项的索引
     - parameter data:      当前被选择的目录菜单项中可能包含的数据
     
     - returns: 下级菜单的数据，如果返回nil，则会根据已经传入的全部数据来判断是否有子目录，如果不是nil，则会根据返回的数据来创建下级目录，传入的itemSource中的数据将会无效。
     - warning: 当添加了datasource代理方法的话，返回值将会无效
     */
    optional func stepMenu(menu: AUUStepMenu, selectedWithMenuIndex menuIndex: Int, menuItemIndexPath indexPath: NSIndexPath,  containedItemData data: AnyObject?) -> [AnyObject]?
    
    /**
     注册一个自定义的菜单项(UITableViewCell)，此时需要调用"stepMenu:dequenceForMenuItemCell:menuItemData:"方法自己对当前cell填充数据
     
     - parameter menu: self
     
     - returns: cell的class
     */
    optional func stepMenu(registerItemCellClassForMenu menu: AUUStepMenu) -> AnyClass!
    
    /**
     对复用的cell进行数据的填充
     
     - parameter menu:  self
     - parameter cell:  被复用的菜单项cell
     - parameter data:  当前菜单项cell的数据
     */
    optional func stepMenu(menu: AUUStepMenu, dequenceForMenuItemCell cell: UITableViewCell!, menuItemData data: AnyObject!)
    
    /**
     不是基本的数据类型(Dictionary<String, AnyObject>, String)，需用自己给出当前菜单项的标题。
     这个方法可以用在自定的数据类型(Model)时。
     
     - parameter menu:      self
     - parameter index:     菜单索引
     - parameter data:      无法解析的数据
     - parameter indexPath: 菜单项的索引
     
     - returns: 目录菜单项的标题
     */
    optional func stepMenu(menu: AUUStepMenu, unpackUnexpectedItemData data: AnyObject, forMenuIndex index: Int, menuItemIndexPath indexPath: NSIndexPath) -> String!
}

// 自己管理和自定义cell的数据源
@objc protocol AUUStepMenuDatasource {
    
    /**
     设置每个目录下分组数
     
     - parameter menu:      self
     - parameter menuIndex: 当前目录的索引
     
     - returns: 分组数
     */
    func stepMenu(menu: AUUStepMenu, numberOfSectionsForMenuIndex menuIndex: Int) -> Int
    
    /**
     每个分组下的菜单项的个数
     
     - parameter menu:      self
     - parameter menuIndex: 目录的索引
     - parameter section:   分组的索引
     
     - returns: 菜单项的个数
     */
    func stepMenu(menu: AUUStepMenu, numberOfItemsForMenuIndex menuIndex: Int, groupSection section:Int) -> Int
    
    /**
     每个菜单项的cell
     
     - parameter menu:      self
     - parameter menuIndex: 当前目录的索引
     - parameter indexPath: 菜单项的索引
     
     - returns: cell
     */
    func stepMenu(menu: AUUStepMenu, cellForMenuIndex menuIndex: Int, menuItemIndexPath indexPath : NSIndexPath) -> UITableViewCell
    
    /**
     是否还有下一级的目录
     
     - parameter menu:      self
     - parameter menuIndex: 当前目录的索引
     - parameter indexPath: 当前选择的菜单项的索引
     
     - returns: Bool
     */
    func stepMenu(menu: AUUStepMenu, hasAdditionalMenuForMenuIndex menuIndex: Int, currentMenuItemIndexPath indexPath: NSIndexPath) -> Bool
}

class AUUStepMenu: UIView, UITableViewDelegate, UITableViewDataSource {

    private var cachedItemSource : [AnyObject]!                 // 缓存的最原始的数据
    private var cachedMaxMenuStepsShown : Int = 3               // 最多可以同时展示多少个菜单
    private var selectCompletion : AUUStepMenuSelectCompletion? // 回调的闭包
    private var menuCount : Int = 0                             // 当前已经展示的菜单的个数
    private var cachedMenuMargin : CGFloat = 0                  // 每个目录之间的间隔
    
    
    internal var delegate : AUUStepMenuDelegate?        // 代理
    internal var datasource : AUUStepMenuDatasource?    // 数据源
    internal var autoDeselsectItemCell : Bool = true    // 是否自动取消点击的效果
    
    /**
     初始化方法
     
     - parameter frame:      Frame
     - parameter itemSource: 数据源
     
     - returns: self
     */
    init(frame: CGRect, itemSource: AnyObject?) {
        super.init(frame: frame)
        self.itemSource = itemSource
        self.clipsToBounds = true
    }
    
    /**
     初始化方法
     
     - parameter frame: frame
     
     - returns: self
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    /**
     初始化方法
     
     - parameter itemSource: 数据源
     
     - returns: self
     */
    init(itemSource: AnyObject?) {
        super.init(frame: CGRectZero)
        self.itemSource = itemSource
        self.clipsToBounds = true
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置整个菜单的初始数据源
    internal var itemSource : AnyObject? {
        set {
            if let tempSource = newValue {
                var tempCachedItemSource = Array<AnyObject>()
                if tempSource is Array<AnyObject> {
                    tempCachedItemSource = tempSource as! Array<AnyObject>
                }
                else if tempSource is Dictionary<String, AnyObject> {
                    tempCachedItemSource = [tempSource]
                }
                else { return }
                self.cachedItemSource = tempCachedItemSource
                self.removeSubmenuBehindTag(__menuStartTag - 1)
                if self.menuCount > 0 {
                    self.setNeedsLayout()
                }
                
                self.menuCount = 0
            }
        }
        get {
            return self.cachedItemSource
        }
    }
    
    // 两个菜单之间的间隔
    internal var menuMargin: CGFloat {
        set { self.cachedMenuMargin = newValue > 0 ? newValue : 0 }
        get { return self.cachedMenuMargin }
    }
    
    internal var maxMenuShow : Int {
        set { self.cachedMaxMenuStepsShown = newValue >= 1 ? newValue : 3 }
        get { return self.cachedMaxMenuStepsShown }
    }
    
    // 设置选择回调的block
    internal func selecteCompletion(completion : AUUStepMenuSelectCompletion!) {
        self.selectCompletion = completion
    }
    
    // 根据索引获取一个菜单table
    internal func menuTableAtIndex(index: Int) -> UITableView? {
        return self.viewWithTag(index + __menuStartTag) as? UITableView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.datasource != nil {
            self.addTableWithDatasource(nil, tag: __menuStartTag)
            return
        }
        self.addTableWithDatasource(self.cachedItemSource as Array<AnyObject>, tag: __menuStartTag)
    }
}

// 对自身操作的所有的私有方法
private extension AUUStepMenu {
    /**
     重新布局页面上所有的菜单的位置和大小
     */
    func reLayoutSubmenus() {
        // 计算每个菜单的宽度
        let pwidth = (self._sizeWidth - self.menuMargin * CGFloat(self.menuCount - 1)) / CGFloat(self.menuCount > self.maxMenuShow ? self.maxMenuShow : self.menuCount)
        // 菜单位置及大小改变的动画时间
        var duration = __defaultAnimationDuration
        if self.menuCount == 1 {
            duration = 0
        }
        
        UIView.animateWithDuration(duration, animations: { () in
            // 循环去设置最后4个菜单的frame
            for i in self.menuCount - self.maxMenuShow - 1 ..< self.menuCount {
                if (i >= 0) {
                    let table = self.viewWithTag(__menuStartTag + i) as! UITableView
                    table._sizeWidth = pwidth
                    table._originX = pwidth * CGFloat(self.menuCount > self.maxMenuShow ? i - (self.menuCount - self.maxMenuShow) : i) + self.menuMargin * CGFloat(i)
                }
            }
        })
    }
    
    /**
     根据给定的一个菜单项，移除其之后的所有菜单
     
     - parameter tag: 指定的table的tag
     */
    func removeSubmenuBehindTag(tag : Int) {
        if tag >= __menuStartTag + self.menuCount - 1 {
            // 如果tag超过当前存在的最后一个table的tag，那就直接返回
            return
        }
        
        for i in (tag + 1) ..< __menuStartTag + self.menuCount {
            // 从给定的tag后面一个开始，遍历其后的所有table并移除
            let table = self.viewWithTag(i) as? UITableView
            if table != nil {
                UIView.animateWithDuration(__defaultAnimationDuration, animations: { () in
                    table?._originX = self._sizeWidth
                    }, completion: { (finished) in
                        table?.removeFromSuperview()
                })
            }
        }
        self.menuCount = tag - __menuStartTag + 1
        self.reLayoutSubmenus()
    }
    
    /**
     添加一个菜单项到页面中
     
     - parameter datas: 菜单中对应的数据
     - parameter tag:   菜单所在的table的tag
     */
    func addTableWithDatasource(datas: Array<AnyObject>?, tag : Int) {
        if let _ = self.viewWithTag(tag) {
            if tag > __menuStartTag {
                self.removeSubmenuBehindTag(tag)
            }
        }
        else {
            // 创建一个菜单
            let tableView = UITableView(frame: self.bounds, style: .Grouped)
            tableView._originX = self._sizeWidth
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.clearColor()
            tableView.tag = tag
            tableView.datasArray = datas
            tableView.tableFooterView = UIView()
            // 用代理通知一下创建了菜单
            self.delegate?.stepMenu?(self, createdMenuTableView: tableView, andMenuIndex: tag - __menuStartTag)
            // 如果没有使用datasource，通知一下是否使用自定义cell
            if self.datasource == nil {
                if let cellClass = self.delegate?.stepMenu?(registerItemCellClassForMenu: self) {
                    tableView.registerClass(cellClass, forCellReuseIdentifier: __reusefulCellIdentifier)
                    tableView.useSelfCreatedCell = true
                }
            }
            self.addSubview(tableView)
            self.menuCount = tag - __menuStartTag + 1
            self.reLayoutSubmenus()
        }
    }
}

// tableview 的所有delegate和datasource
extension AUUStepMenu {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let datasource = self.datasource {
            // 如果使用了datasource，就必须自己管理所有的菜单
            let sections = datasource.stepMenu(self, numberOfSectionsForMenuIndex: tableView.tag - __menuStartTag)
            return sections >= 0 ? sections : 0
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = self.datasource {
            // 如果使用了datasource，就必须自己管理所有的菜单
            let rows = datasource.stepMenu(self, numberOfItemsForMenuIndex: tableView.tag - __menuStartTag, groupSection: section)
            return rows >= 0 ? rows : 0
        }
        if let datas = tableView.datasArray {
            return datas.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let datasource = self.datasource {
            // 如果使用了datasource，就必须自己管理所有的菜单
            return datasource.stepMenu(self, cellForMenuIndex: tableView.tag - __menuStartTag, menuItemIndexPath: indexPath)
        }
        
        if tableView.useSelfCreatedCell {
            // 如果使用了自定义的cell，则数据的填充需要自己去做
            let cell = tableView.dequeueReusableCellWithIdentifier(__reusefulCellIdentifier)
            self.delegate?.stepMenu!(self, dequenceForMenuItemCell: cell, menuItemData: tableView.datasArray![indexPath.row])
            
            return cell!
        }
        
        // 由系统管理的cell
        var cell = tableView.dequeueReusableCellWithIdentifier(__reusefulCellIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: __reusefulCellIdentifier)
            cell?.backgroundColor = UIColor.clearColor()
        }
        
        if let datas = tableView.datasArray {
            let currentData = datas[indexPath.row]
            if currentData is String {
                cell?.textLabel?.text = currentData as? String
            }
            else if currentData is Dictionary<String, AnyObject> {
                cell?.textLabel?.text = (currentData as! Dictionary<String, AnyObject>).keys.first
            }
            else {
                // 如果数据不是基本的数据类型(Dictionary<String, AnyObject>, String),则需要自己解析并返回一个title用于显示
                if let itemTitle = self.delegate?.stepMenu?(self, unpackUnexpectedItemData: currentData, forMenuIndex: tableView.tag - __menuStartTag, menuItemIndexPath: indexPath) {
                    cell?.textLabel?.text = itemTitle
                }
                else {
                    cell?.textLabel?.text = "Un expected title"
                    print("Unexpected item data : \(currentData), please give me an answer with method 'stepMenu:menuIndex:unexpectedItemData:forMenuItemIndexPath' in AUUStepMenuDelegate")
                }
            }
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let rowHeight = self.delegate?.stepMenu?(self, heightForMenuIndex: tableView.tag - __menuStartTag, menuItemIndexPath: indexPath) {
            // 如果实现了heightForMenuIndex这个代理，请务必返回一个有效的高度，否则会按默认的30处理
            return rowHeight > 0 ? rowHeight : 30
        }
        return 30
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.autoDeselsectItemCell {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        var selectdItemData : AnyObject? = nil  // 被选择的当前菜单项的数据
        var createMenuTableData : [AnyObject]?  // 创建下一级菜单的数据
        
        if tableView.tag < self.menuCount + __menuStartTag - 1 {
            self.removeSubmenuBehindTag(tableView.tag)
        }
        
        if let datasource = self.datasource {
            // 询问是否有下级菜单
            let hasAdditionalMenu = datasource.stepMenu(self, hasAdditionalMenuForMenuIndex: tableView.tag - __menuStartTag, currentMenuItemIndexPath: indexPath)
            if hasAdditionalMenu {
                self.addTableWithDatasource(nil, tag: tableView.tag + 1)
            }
        }
        else {
            if let datas = tableView.datasArray {
                let currentData = datas[indexPath.row]
                selectdItemData = currentData
                if currentData is Dictionary<String, AnyObject> {
                    let currentDataDict = currentData as! Dictionary<String, AnyObject>
                    
                    // 取出当前菜单项的子数据，并根据子数据创建下级菜单的数据
                    let value = currentDataDict.values.first
                    if value is String || value is Dictionary<String, AnyObject> {
                        createMenuTableData = [value!]
                    }
                    else if value is Array<AnyObject> {
                        createMenuTableData = value as? [AnyObject]
                    }
                    else {
                        print("Unrecognized submenu data : \(value)")
                    }
                }
            }
        }
        
        // 用block进行回调
        if let selectCompletionBlock = self.selectCompletion {
            selectCompletionBlock(menuIndex: tableView.tag - __menuStartTag, itemIndexPath: indexPath, itemData: selectdItemData)
        }
        
        // 调用选择了菜单项的代理
        if let subMenuData = self.delegate?.stepMenu?(self, selectedWithMenuIndex: tableView.tag - __menuStartTag, menuItemIndexPath: indexPath, containedItemData: selectdItemData) {
            if self.datasource == nil {
                self.addTableWithDatasource(subMenuData, tag: tableView.tag + 1)
            }
            // 以返回的数据为主，如果有返回的数据的话，就直接用这个创建子菜单，否则，继续往下，用上面判断中的数据创建菜单
            return
        }
        
        // 如果有数据，就创建一个子菜单
        if let finalData = createMenuTableData {
            self.addTableWithDatasource(finalData, tag: tableView.tag + 1)
        }
    }
}

// tableview的extension
private extension UITableView {
    struct AssociatedKeys {
        static var datasArray : [AnyObject]?
        static var useSelfCreatedCell : String?
    }
    // 缓存的自身关联的数据源
    var datasArray : [AnyObject]? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.datasArray, newValue as [AnyObject], .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.datasArray) as? [AnyObject]
        }
    }
    // 缓存是否使用了自定义的cell
    var useSelfCreatedCell: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.useSelfCreatedCell, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            let storedValue = objc_getAssociatedObject(self, &AssociatedKeys.useSelfCreatedCell)
            if let boolValue = storedValue as? Bool { return boolValue }
            return false
        }
    }
}

// view的extension
private extension UIView {
    var _originX : CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(origin: CGPoint(x: newValue, y: self.frame.origin.y), size: self.frame.size) }
    }
    var _sizeWidth : CGFloat {
        get { return self.frame.size.width }
        set { self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: newValue, height: self.frame.size.height)) }
    }
}
