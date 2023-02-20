//
//  CSBannderTableViewCell.swift
//  ScrollDriver_Example
//
//  Created by ce.wang on 2023/2/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ScrollDriver

class CSBannderTableViewCell: UITableViewCell, CSScrollItemViewProtocol {
    
    var eventAction : ((Int, Any) -> Any?)?
    
    let button = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 创建视图
    func createSubViews() {
        
        backgroundColor = .blue
        
        button.frame = CGRectMake(0, 0, 100, 100)
        button.backgroundColor = .red
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(buttonTestClick), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.center = CGPoint(x: contentView.bounds.size.width / 2, y: contentView.bounds.size.height / 2)
    }
    
    @objc func buttonTestClick(){
        if let eventAction = eventAction {
            let _ = eventAction(1,"eventAction的数据")
        }
    }
    
    // MARK: - CSScrollItemViewProtocol
    
    // 设置尺寸
    static func viewSize(by dataModel: Any) -> CGSize {
        return CGSizeMake(0, 150)
    }
    
    // 配置数据
    func configDataModel(_ dataModel: Any) {
        print("CSBannderTableViewCell配置数据：\(dataModel)")
    }
    
    // 点击事件
    func configEventAction(_ eventAction: ((Int, Any) -> Any?)?) {
        self.eventAction = eventAction
    }
}
