//
//  CSScrollItemViewProtocol.swift
//  ScrollDriver
//
//  Created by ce.wang on 2023/2/7.
//

import UIKit

@objc public protocol CSScrollItemViewProtocol {
    
    /// 获取cell/view大小
    static func viewSize(by dataModel : Any) -> CGSize
    
    /// 设置cell的数据源
    @objc optional func configDataModel(_ dataModel : Any)
    
    /// 设置点击回调
    @objc optional func configEventAction(_ eventAction : ((Int, Any) -> Any?))
    
    /// 设置自定义代理
    @objc optional func configDelegate(_ delegate : Any)

}
