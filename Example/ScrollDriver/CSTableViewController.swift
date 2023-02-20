//
//  CSTableViewController.swift
//  ScrollDriver_Example
//
//  Created by ce.wang on 2023/2/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ScrollDriver

fileprivate enum SectionTag : Int {
case section0 = 0
case section1 = 1
}

class CSTableViewController: UIViewController {
    
    var tableView : UITableView!
    var tableDriver : CSScrollDriver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: view.bounds, style: .plain)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(tableView)
        
        tableDriver = CSScrollDriver(hostView: tableView)
        
        // 添加section
        let section0 = SectionTag.section0.rawValue
        tableDriver.addSection(section0)
        tableDriver.addHeaderToSection(section0, viewClass: CSFuncionSectionHeader.self, dataModel: "BannerCell的FooterView")
        
        tableDriver.addCellToSection(section0, viewClass: CSBannderTableViewCell.self, dataModel: "aaa") { eventType, dataModel in
            print("收到了eventAction，eventType:\(eventType), dataModel:\(dataModel)")
        } selectedAction: { dataModel in
            print("点击了\(dataModel)")
        }
        
        let section1 = SectionTag.section1.rawValue
        tableDriver.addSection(section1)
        tableDriver.addHeaderToSection(section1, viewClass: CSFuncionSectionHeader.self, dataModel: "功能cell")
        tableDriver.addCellToSection(section1, viewClass: CSFunctionTableViewCell.self, dataModel: "第1个功能Cell", selectedAction:  { dataModel in
            print("点击了\(dataModel)")
        })
        tableDriver.addCellToSection(section1, viewClass: CSFunctionTableViewCell.self, dataModel: "第2个功能Cell", selectedAction:  { dataModel in
            print("点击了\(dataModel)")
        })
        tableDriver.addCellToSection(section1, viewClass: CSFunctionTableViewCell.self, dataModel: "第3个功能Cell", selectedAction:  { dataModel in
            print("点击了\(dataModel)")
        })
        tableDriver.addFooterToSection(section1, viewClass: CSFuncionSectionHeader.self, dataModel: "功能cell的Footer")

        // 刷新数据
        tableDriver.reloadView()
        
        // 获取tableView的总高度
        print("tableView的总高度为:\(tableDriver.tableHostViewHeight())")
    }

}
