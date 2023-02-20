//
//  CSA.swift
//  ScrollDriver
//
//  Created by ce.wang on 2023/2/20.
//

import Foundation

public class CSScrollSectionViewModel {
    
    // Tag
    var sectionTag = 0
    
    // CollectionView特有
    var minimumLineSpacing : CGFloat = 0                // 最小行距
    var minimumInteritemSpacing : CGFloat = 0           // 最小间距
    var sectionInsets = UIEdgeInsets.zero               // section边缘间距
    var backgroundColor = UIColor.clear                 // section背景色
    
    // MARK: - Header
    var headerNeedPin = false // header是否悬浮
    var headerViewModel : CSScrollItemViewModel?
    var headerViewSize : CGSize {
        return headerViewModel?.viewSize ?? CGSize.zero
    }
    // MARK: - Footer
    var footerViewModel : CSScrollItemViewModel?
    var footerViewSize : CGSize {
        return footerViewModel?.viewSize ?? CGSize.zero
    }

    // MARK: - Items
    var itemsArray : [CSScrollItemViewModel] = []
    
    // 个数
    var count : Int {
        return itemsArray.count
    }
    
    /// 方法
    func addObject(_ object : CSScrollItemViewModel) {
        itemsArray.append(object)
    }
    
    /// 添加多个
    func addObjects(_ objects : [CSScrollItemViewModel]) {
        itemsArray.append(contentsOf: objects)
    }
    
    /// 获取指定下标的viewModel
    func objectAtIndex(_ index : Int) -> CSScrollItemViewModel? {
        return itemsArray[index]
    }
    
    /// 删除指定下标的viewModel
    func removeObjectAtIndex(_ index : Int) {
        itemsArray.remove(at: index)
    }
    
    /// 移除所有的viewModess
    func removeAllObjects(){
        itemsArray.removeAll()
    }
    
    /// 获取sectionView的height
    func sectionHeightForTableView() -> CGFloat{
        var viewHeight : CGFloat = 0
        if let viewModel = headerViewModel {
            viewHeight += viewModel.viewSize.height
        }
        for viewModel in itemsArray {
            viewHeight += viewModel.viewSize.height
        }
        if let viewModel = footerViewModel {
            viewHeight += viewModel.viewSize.height
        }
        return viewHeight
    }
    
    init(sectionTag: Int = 0, headerNeedPin:Bool = false, minimumLineSpacing: CGFloat = 0, minimumInteritemSpacing: CGFloat = 0, sectionInsets: UIEdgeInsets = UIEdgeInsets.zero, backgroundColor: UIColor = UIColor.clear) {
        self.sectionTag = sectionTag
        self.headerNeedPin = headerNeedPin
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInsets = sectionInsets
        self.backgroundColor = backgroundColor
    }
}
