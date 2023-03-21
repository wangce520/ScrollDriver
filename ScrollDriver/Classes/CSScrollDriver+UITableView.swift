//
//  CSA.swift
//  ScrollDriver
//
//  Created by ce.wang on 2023/2/20.
//

import Foundation

extension CSScrollDriver : UITableViewDataSource, UITableViewDelegate {
    
    // 返回section的数量
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    // 返回cell的数量
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    // 返回cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModelForIndexPath(indexPath)!
        var cell : UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIndentifier(), for: indexPath)
        if let _cell = cell as? CSScrollItemViewProtocol {
            // 配置点击事件
            if let eventAction = viewModel.eventAction {
                _cell.configEventAction?(eventAction)
            }
            // 配置代理
            _cell.configDelegate?(viewModel.delegate as Any)
            // 配置数据
            _cell.configDataModel?(viewModel.dataModel)
            // 配置indexPath
            _cell.configIndexPath?(indexPath, sectionCount: data[indexPath.section].count)
        }
        return cell
    }
    
    // 点击选中cell
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let viewModel = viewModelForIndexPath(indexPath)!
        viewModel.excuteSelectedAction() // 触发选中事件
    }
    
    // 设置cellHeight
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = viewModelForIndexPath(indexPath)!
        return viewModel.visableSizeFor(self.hostView).height
    }
    
    // 设置HeaderView
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewModel = data[section]
        return _headerFooterViewFor(tableView, viewModel: sectionViewModel.headerViewModel, sectionCount : sectionViewModel.count)
    }
    
    // 设置HeaderView的高度
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionViewModel = data[section]
        guard let viewModel = sectionViewModel.headerViewModel else { return 0 }
        return viewModel.visableSizeFor(self.hostView).height
    }
    
    // 设置FooterView
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionViewModel = data[section]
        return _headerFooterViewFor(tableView, viewModel: sectionViewModel.footerViewModel, sectionCount : sectionViewModel.count)
    }
    
    // 设置FooterView的高度
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionViewModel = data[section]
        guard let viewModel = sectionViewModel.footerViewModel else { return CGFloat.leastNormalMagnitude }
        return viewModel.visableSizeFor(self.hostView).height
    }
    
    // 设置HeaderView|FooterView
    public func _headerFooterViewFor(_ tableView : UITableView, viewModel : CSScrollItemViewModel?, sectionCount : Int) -> UITableViewHeaderFooterView? {
        guard let viewModel = viewModel else { return nil}
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewModel.reuseIndentifier()) else { return nil }
        if let _view = view as? CSScrollItemViewProtocol {
            // 配置点击事件
            if let eventAction = viewModel.eventAction {
                _view.configEventAction?(eventAction)
            }
            // 配置代理
            _view.configDelegate?(viewModel.delegate as Any)
            // 配置数据
            _view.configDataModel?(viewModel.dataModel)
            // 配置indexPath
            _view.configIndexPath?(nil, sectionCount: sectionCount)
        }
        return view
    }
}
