//
//  CSFuncionSectionHeader.swift
//  ScrollDriver_Example
//
//  Created by ce.wang on 2023/2/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ScrollDriver

class CSFuncionSectionHeader: UITableViewHeaderFooterView , CSScrollItemViewProtocol{
    
    let tipLab = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tipLab)
        contentView.backgroundColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLab.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configDataModel(_ dataModel: Any) {
        tipLab.text = dataModel as! String
    }
    
    static func viewSize(by dataModel: Any) -> CGSize {
        return CGSize(width: 0, height: 50)
    }
}
