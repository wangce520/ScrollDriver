//
//  CSCollectionSectionView.swift
//  ScrollDriver_Example
//
//  Created by ce.wang on 2023/2/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import ScrollDriver

class CSCollectionSectionView: UICollectionReusableView , CSScrollItemViewProtocol {
    
    let tipLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        addSubview(tipLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLab.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize(by dataModel: Any) -> CGSize {
        return CGSize(width: 375, height: 80)
    }
    
    func configDataModel(_ dataModel: Any) {
        tipLab.text = dataModel as? String
    }
}
