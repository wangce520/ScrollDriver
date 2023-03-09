//
//  CSScrollDriver.swift
//  ScrollDriver
//
//  Created by ce.wang on 2023/2/7.
//

import Foundation

public class CSScrollDriver : NSObject {
    
    /// 持有的scrollView
    unowned var hostView : UIScrollView!
    
    /// 持有的数据
    var data : [CSScrollSectionViewModel] = []
    
    /// 创建方法
    public init(hostView: UIScrollView) {
        super.init()
        self.hostView = hostView
        // 判断hostView的类型
        if hostView.isKind(of: UITableView.self) {
            (hostView as! UITableView).dataSource = self
            (hostView as! UITableView).delegate = self
        } else if hostView.isKind(of: UICollectionView.self) {
            (hostView as! UICollectionView).dataSource = self
            (hostView as! UICollectionView).delegate = self
            
            // 注册空白的Header&Footer
            registerHostViewReusableView(hostView, kind: UICollectionView.elementKindSectionHeader, viewClass: UICollectionReusableView.self, reuseIdentifier: "UICollectionReusableView")
            registerHostViewReusableView(hostView, kind: UICollectionView.elementKindSectionFooter, viewClass: UICollectionReusableView.self, reuseIdentifier: "UICollectionReusableView")
        }        
    }
    
    /// 刷新视图
    public func reloadView() {
        // 判断hostView的类型
        if hostView.isKind(of: UITableView.self) {
            (hostView as! UITableView).reloadData()
        } else if hostView.isKind(of: UICollectionView.self) {
            (hostView as! UICollectionView).reloadData()
        }
    }
    
    /// 清除所有数据
    public func clear() {
        data.removeAll()
    }
    
    /// 获取所有视图的高度，如果是TableView
    public func tableHostViewHeight() -> CGFloat {
        var viewHeight : CGFloat = 0
        for sectionViewModel in data {
            viewHeight += sectionViewModel.sectionHeightForTableView()
        }
        return viewHeight
    }
    
    // MARK: - Section CRUD
    
    /// 添加section，如果是tableView，只需要tag即可
    public func addSection(_ tag : Int, headerNeedPin: Bool = false, minimumLineSpacing: CGFloat = 0, minimumInteritemSpacing: CGFloat = 0, sectionInsets: UIEdgeInsets = UIEdgeInsets.zero, backgroundColor: UIColor = UIColor.clear){
        if hasSection(tag) {
            print("重复添加section: \(tag)")
            return
        }
        let sectionViewModel = CSScrollSectionViewModel(sectionTag: tag,headerNeedPin:headerNeedPin, minimumLineSpacing: minimumLineSpacing, minimumInteritemSpacing: minimumInteritemSpacing, sectionInsets: sectionInsets, backgroundColor: backgroundColor)
        data.append(sectionViewModel)
    }
    
    /// 删除Section
    public func deleteSection(_ tag : Int){
        guard let index = data.firstIndex(where: { model in
            return model.sectionTag == tag
        }) else { return }
        data.remove(at: index)
    }
    
    /// 判断是否已经添加了相同的Section
    public func hasSection(_ tag : Int) -> Bool {
        if sectionViewModelForTag(tag) == nil {
            return false
        }
        return true
    }
    
    /// 根据指定tag获取sectionViewModel
    func sectionViewModelForTag(_ tag : Int) -> CSScrollSectionViewModel? {
        for sectionViewModel in data {
            if sectionViewModel.sectionTag == tag {
                return sectionViewModel
            }
        }
        return nil
    }
    
    /// 根据index获取sectionViewModel
    func sectionViewModelForIndex(_ index : Int) -> CSScrollSectionViewModel? {
        return data[index]
    }
    
    // MARK: - Header&Footer CURD
    
    /// 设置HeaderViewModel
    public func addHeaderToSection(_ sectionTag : Int, viewClass: AnyClass, dataModel: Any, eventAction:((Int, Any) -> Any?)? = nil, delegate : Any? = nil) {
        guard let sectionViewModel = sectionViewModelForTag(sectionTag) else { return }
        let viewModel = CSScrollItemViewModel(viewTag : 0 ,viewClass: viewClass, dataModel: dataModel, eventAction: eventAction, selectedAction: nil,delegate: delegate)
        sectionViewModel.headerViewModel = viewModel
        
        // 注册Header
        registerHostViewReusableView(hostView, kind: UICollectionView.elementKindSectionHeader, viewClass: viewModel.viewClass, reuseIdentifier: viewModel.reuseIndentifier())
    }
    
    /// 设置FooterViewModel
    public func addFooterToSection(_ sectionTag : Int, viewClass: AnyClass, dataModel: Any, eventAction:((Int, Any) -> Any?)? = nil, delegate : Any? = nil) {
        guard let sectionViewModel = sectionViewModelForTag(sectionTag) else { return }
        let viewModel = CSScrollItemViewModel(viewTag : 0, viewClass: viewClass, dataModel: dataModel, eventAction: eventAction, selectedAction: nil, delegate: delegate)
        sectionViewModel.footerViewModel = viewModel
        
        // 注册Footer
        registerHostViewReusableView(hostView, kind: UICollectionView.elementKindSectionFooter, viewClass: viewModel.viewClass, reuseIdentifier: viewModel.reuseIndentifier())
    }
    
    /// 移除Header
    public func removeHeaderFromSection(_ sectionTag : Int){
        guard let sectionViewModel = sectionViewModelForTag(sectionTag) else { return }
        sectionViewModel.headerViewModel = nil
    }
    
    /// 移除Footer
    public func removeFooterFromSection(_ sectionTag : Int){
        guard let sectionViewModel = sectionViewModelForTag(sectionTag) else { return }
        sectionViewModel.footerViewModel = nil
    }
    
    // MARK: - Cell CURD
    
    /// section添加cell
    public func addCellToSection(_ sectionTag : Int, viewTag : Int = 0, viewClass: AnyClass, dataModel: Any, eventAction:((Int, Any) -> Any?)? = nil, selectedAction:((Any) -> Void)? = nil,
        delegate:AnyObject? = nil
        ) {
        guard let sectionViewModel = sectionViewModelForTag(sectionTag) else { return }
        let viewModel = CSScrollItemViewModel(viewTag : viewTag ,viewClass: viewClass, dataModel: dataModel, eventAction: eventAction, selectedAction: selectedAction, delegate: delegate)
        sectionViewModel.addObject(viewModel)
        // 注册cell
        registerHostViewCell(hostView, viewClass: viewModel.viewClass, reuseIdentifier: viewModel.reuseIndentifier())
    }
    
    /// section移除sell
    public func removeCellFromSection(_ sectionTag : Int, viewTag : Int) {
        guard let sectionViewModel = sectionViewModelForTag(sectionTag) else { return }
        guard let index = sectionViewModel.itemsArray.firstIndex(where: { model in
            return model.viewTag == viewTag
        }) else { return }
        sectionViewModel.removeObjectAtIndex(index) // 移除cell
    }
    
    /// section移除所有cell
    public func removeAllCessFromSection(_ sectionTag : Int){
        guard let sectionViewModel = sectionViewModelForTag(sectionTag) else { return }
        sectionViewModel.removeAllObjects()
    }
    
    /// 根据indexPath获取viewModel
    func viewModelForIndexPath(_ indexPath : IndexPath) -> CSScrollItemViewModel? {
        guard let sectionViewModel = sectionViewModelForIndex(indexPath.section) else { return nil}
        return sectionViewModel.objectAtIndex(indexPath.row)
    }
    
    /// 注册cell
    func registerHostViewCell(_ hostView : UIScrollView, viewClass : AnyClass, reuseIdentifier : String) {
        // 判断hostView的类型
        if hostView.isKind(of: UITableView.self) {
            (hostView as! UITableView).register(viewClass, forCellReuseIdentifier: reuseIdentifier)
        } else if hostView.isKind(of: UICollectionView.self) {
            (hostView as! UICollectionView).register(viewClass, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }

    /// 注册ReusableView
    func registerHostViewReusableView(_ hostView : UIScrollView, kind : String, viewClass : AnyClass, reuseIdentifier : String) {
        // 判断hostView的类型
        if hostView.isKind(of: UITableView.self) {
            (hostView as! UITableView).register(viewClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        } else if hostView.isKind(of: UICollectionView.self) {
            (hostView as! UICollectionView).register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        }
    }

}

