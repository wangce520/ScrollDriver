//
//  CSA.swift
//  ScrollDriver
//
//  Created by ce.wang on 2023/2/20.
//

import Foundation

extension CSScrollDriver : UICollectionViewDataSource, UICollectionViewDelegate , CSScrollDriverFlowLayoutDelegate{
    
    // MARK: - UICollectionViewDataSource
    
    /// section的数量
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    /// cell的数量
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    /// 设置cell
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModelForIndexPath(indexPath)!
        var cell : UICollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIndentifier(), for: indexPath)
        if let _cell = cell as? CSScrollItemViewProtocol {
            viewModel.excuteConfigAction(_cell)
        }
        return cell
    }
    
    /// 设置HeaderOrFooter
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionViewModel = sectionViewModelForIndex(indexPath.section)!
        // 如果有值
        if let viewModel = (kind == UICollectionElementKindSectionHeader ? sectionViewModel.headerViewModel : sectionViewModel.footerViewModel) {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewModel.reuseIndentifier(), for: indexPath)
            if let _view = view as? CSScrollItemViewProtocol {
                viewModel.excuteConfigAction(_view)
            }
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            return view
        }
    }
    
    // MARK: - UICollectionViewDelegate
        
    /// item点击
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let viewModel = viewModelForIndexPath(indexPath)!
        viewModel.excuteSelectedAction()
    }
    
    ///  UICollectionViewDelegate
    
    /// item的大小
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = viewModelForIndexPath(indexPath)!
        let sectionViewModel = sectionViewModelForIndex(indexPath.section)!
        return viewModel.visableSizeFor(collectionView, sectionInsets: sectionViewModel.sectionInsets)
    }
    
    /// Header的大小
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionViewModel = sectionViewModelForIndex(section)!
        guard let viewModel = sectionViewModel.headerViewModel else {return .zero}
        return viewModel.visableSizeFor(collectionView, sectionInsets: sectionViewModel.sectionInsets)
    }
    
    /// Footer的大小
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let sectionViewModel = sectionViewModelForIndex(section)!
        guard let viewModel = sectionViewModel.footerViewModel else {return .zero}
        return viewModel.visableSizeFor(collectionView, sectionInsets: sectionViewModel.sectionInsets)
    }
    
    /// 行间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionViewModel = sectionViewModelForIndex(section)!
        return sectionViewModel.minimumLineSpacing
    }
    
    /// item间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionViewModel = sectionViewModelForIndex(section)!
        return sectionViewModel.minimumInteritemSpacing
    }
    
    /// SectionInsect
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionViewModel = sectionViewModelForIndex(section)!
        return sectionViewModel.sectionInsets
    }
    
    // MARK: - CSScrollDriverFlowLayoutDelegate
    
    /// 背景色
    public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAtIndex section: Int) -> UIColor {
        let sectionViewModel = sectionViewModelForIndex(section)!
        return sectionViewModel.backgroundColor
    }
    
    /// 设置header是否悬浮
    public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, didSectionHeaderPinToVisibleBounds section: Int) -> Bool {
        let sectionViewModel = sectionViewModelForIndex(section)!
        return sectionViewModel.headerNeedPin
    }
}
