//
//  CSCollectionViewController.swift
//  ScrollDriver_Example
//
//  Created by ce.wang on 2023/2/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ScrollDriver

class CSCollectionViewController: UIViewController {
    
    var collectionView : UICollectionView!
    var collectionDriver : CSScrollDriver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = CSScrollDriverFlowLayout()
        layout.headerVisibleBoundsOffset = 48
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray
        view.addSubview(collectionView)
        
        collectionDriver = CSScrollDriver(hostView: collectionView)
        
        // 添加section
        let section0 = 0
        collectionDriver.addSection(section0, headerNeedPin: true, minimumLineSpacing: 10, minimumInteritemSpacing: 10, sectionInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), backgroundColor: .red)
        collectionDriver.addHeaderToSection(section0, viewClass: CSCollectionSectionView.self, dataModel: "SectionHeader0")
        
        for i in 0..<30 {
            collectionDriver.addCellToSection(section0, viewClass: CSCollectionViewCell.self, dataModel: CGSize(width: 80, height: 80)) { eventType, dataModel in
                print("收到了eventAction，eventType:\(eventType), dataModel:\(dataModel)")
            } selectedAction: { dataModel in
                print("点击了\(dataModel)")
            }
        }
        
        collectionDriver.addFooterToSection(section0, viewClass: CSCollectionSectionView.self, dataModel: "SectionFooter0")

        
        let section1 = 1
        collectionDriver.addSection(section1, headerNeedPin: true, minimumLineSpacing: 10, minimumInteritemSpacing: 10, sectionInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), backgroundColor: .red)
        collectionDriver.addHeaderToSection(section1, viewClass: CSCollectionSectionView.self, dataModel: "SectionHeader1")
        
        for i in 0..<20 {
            collectionDriver.addCellToSection(section1, viewClass: CSCollectionViewCell.self, dataModel: CGSize(width: 100, height: 100)) { eventType, dataModel in
                print("收到了eventAction，eventType:\(eventType), dataModel:\(dataModel)")
            } selectedAction: { dataModel in
                print("点击了\(dataModel)")
            }
        }
        
        collectionDriver.addFooterToSection(section1, viewClass: CSCollectionSectionView.self, dataModel: "SectionFooter1")

        // 刷新数据
        collectionDriver.reloadView()
    }

}
