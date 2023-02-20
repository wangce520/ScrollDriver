//
//  CSA.swift
//  ScrollDriver
//
//  Created by ce.wang on 2023/2/20.
//

import Foundation

public class CSScrollItemViewModel {
    
    /// tag
    var viewTag : Int = 0
    
    /// 对应的view/cell类
    var viewClass : AnyClass
    
    /// view/cell绑定的model
    var dataModel : Any
    
    /// view/cell的大小
    var viewSize : CGSize = CGSize.zero
    
    /// 绑定的点击事件
    var eventAction : ((Int, Any) -> Any?)? = nil
    
    /// 绑定的选中事件
    var selectedAction : ((Any) -> Void)? = nil
    
    init(viewTag: Int = 0, viewClass: AnyClass, dataModel: Any, eventAction: ((Int, Any) -> Any?)? = nil, selectedAction: ((Any) -> Void)? = nil) {
        self.viewTag = viewTag
        self.viewClass = viewClass
        self.dataModel = dataModel
        self.eventAction = eventAction
        self.selectedAction = selectedAction
        
        // 更新view的视图大小
        updateViewSize()
    }
    
    /// 更新View的视图大小
    private func updateViewSize(){
        // 计算View大小
        if viewClass.conforms(to: CSScrollItemViewProtocol.self) {
            viewSize = viewClass.viewSize(by: dataModel)
        }
    }
    
    /// cell的id
    func reuseIndentifier() -> String {
        return NSStringFromClass(self.viewClass)
    }
    
    /// 配置数据
    func excuteConfigAction(_ itemView : CSScrollItemViewProtocol) {
        itemView.configDataModel?(self.dataModel)       // 配置数据
        itemView.configEventAction?(self.eventAction)   // 配置点击事件
    }
    
    /// 获取size
    func visableSizeFor(_ hostView : UIView, sectionInsets : UIEdgeInsets = .zero) -> CGSize{
        var width = viewSize.width
        if width < 0 {
            let viewWidth = hostView.frame.size.width - sectionInsets.left - sectionInsets.right
            width = viewWidth * -width
        }
        width = max(width, 0.00001)
        
        var height = viewSize.height
        if height < 0 {
            height = hostView.frame.size.height * -height
        }
        height = max(height, 0.00001)
        
        return CGSizeMake(CGFloat(Int(width)), CGFloat(Int(height)))
    }
    
    /// 触发selection
    func excuteSelectedAction(){
        if let selectedAction = selectedAction {
            selectedAction(dataModel)
        }
    }
}
