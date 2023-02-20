//
//  CSFunctionTableViewCell.swift
//  ScrollDriver_Example
//
//  Created by ce.wang on 2023/2/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ScrollDriver

class CSFunctionTableViewCell: UITableViewCell , CSScrollItemViewProtocol {
    
    let tipLab = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .blue
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 创建视图
    func createSubViews() {
        contentView.addSubview(tipLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLab.frame = contentView.bounds
    }
    
    func configDataModel(_ dataModel: Any) {
        tipLab.text = dataModel as? String
    }
    
    static func viewSize(by dataModel: Any) -> CGSize {
        return CGSize(width: 0, height: 50)
    }
}
