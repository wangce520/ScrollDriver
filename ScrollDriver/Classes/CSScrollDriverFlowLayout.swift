//
//  CSScrollDriver.swift
//  ScrollDriver
//
//  Created by ce.wang on 2023/2/7.
//

import Foundation

@objc protocol CSScrollDriverFlowLayoutDelegate : UICollectionViewDelegateFlowLayout {
    
    /// 设置section的背景色
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAtIndex section : Int) -> UIColor
    
    /// 控制Header是否悬浮
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, didSectionHeaderPinToVisibleBounds section : Int) -> Bool

}

class CSScrollDriverLayoutAttributes : UICollectionViewLayoutAttributes {
    var backgroundColor : UIColor = .clear
}


class CSScrollDriverLayoutReusableView : UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let layoutAttributes = layoutAttributes as? CSScrollDriverLayoutAttributes{
            self.backgroundColor = layoutAttributes.backgroundColor
        }
    }
}

public class CSScrollDriverFlowLayout : UICollectionViewFlowLayout {
    
    /// header悬浮偏移量，默认0
    public var headerVisibleBoundsOffset : CGFloat = 0
    
    /// 描述
    var decorationViewAttributes : [UICollectionViewLayoutAttributes] = []
    
    public override func prepare(){
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        guard let viewDelegate = collectionView.delegate as? CSScrollDriverFlowLayoutDelegate else { return }
        decorationViewAttributes.removeAll()
        register(CSScrollDriverLayoutReusableView.self, forDecorationViewOfKind: "CSScrollDriverLayoutReusableView")
        
        for section in 0..<collectionView.numberOfSections {
            guard let collectionViewBGColor = collectionView.backgroundColor else { continue }
            guard let sectionBgColor = viewDelegate.collectionView?(collectionView, layout: self, colorForSectionAtIndex: section) else { continue }
            if sectionBgColor.cgColor == collectionViewBGColor.cgColor {
                continue
            }
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            if numberOfItems <= 0 {
                return
            }
            
            let firstAttribute = layoutAttributesForItem(at: IndexPath(row: 0, section: section))!
            let lastAttribute = layoutAttributesForItem(at: IndexPath(row: numberOfItems - 1, section: section))!
            
            // 获取section的edgeInsets
            var sectionInset = self.sectionInset
            if let inset = viewDelegate.collectionView?(collectionView, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            
            // 计算section的范围
            var sectionFrame = CGRectUnion(firstAttribute.frame, lastAttribute.frame)
            sectionFrame.origin.x -= sectionInset.left
            sectionFrame.origin.y -= sectionInset.top
            
            if (scrollDirection == .horizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = collectionView.frame.size.height
            }else{
                sectionFrame.size.width = collectionView.frame.size.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            // 配置
            let attribute = CSScrollDriverLayoutAttributes(forDecorationViewOfKind: "CSScrollDriverLayoutReusableView", with: IndexPath(row: 0, section: section))
            attribute.frame = sectionFrame
            attribute.zIndex = -1
            attribute.backgroundColor = sectionBgColor
            
            decorationViewAttributes.append(attribute)
        }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var superArray = super.layoutAttributesForElements(in: rect) else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        // 修改背景色
        layoutBackgroundColorAttributes(&superArray, forElementsInRect: rect)
        // 设置header悬浮
        layoutHeaderFooterAttributes(&superArray, forElementsInRect: rect)
        
        return superArray
    }
    
    // 设置header&footer悬浮
    private func layoutHeaderFooterAttributes(_ supperArray : inout [UICollectionViewLayoutAttributes], forElementsInRect rect : CGRect) {
        
        guard let collectionView = collectionView else { return }
        
        // section header 悬浮
        let noneHeaderSections = NSMutableIndexSet()
        for attributes in supperArray {
            if attributes.representedElementCategory == .cell {
                noneHeaderSections.add(attributes.indexPath.section)
            }
        }
        
        for attributes in supperArray {
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                noneHeaderSections.remove(attributes.indexPath.section)
            }
        }
        
        for sectionIndex in noneHeaderSections {
            if collectionView.numberOfItems(inSection: sectionIndex) > 0 {
                let indexPath = IndexPath(item: 0, section: sectionIndex)
                if let attributes = layoutAttributesForDecorationView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath){
                    supperArray.append(attributes)
                }
            }
        }
        
        // 遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
        guard let viewDelegate = collectionView.delegate as? CSScrollDriverFlowLayoutDelegate else { return }
        for attributes in supperArray {
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                let section = attributes.indexPath.section
                let numberofItemsInSection = collectionView.numberOfItems(inSection: section)
                
                // 判断是否需要悬浮
                guard let pinToVisibleBounds = viewDelegate.collectionView?(collectionView, layout: self, didSectionHeaderPinToVisibleBounds: section) else { continue }
                if pinToVisibleBounds == false {
                    continue
                }
                
                //
                let firstItemIndexPath = IndexPath(item: 0, section: section)
                let lastItemIndexPath = IndexPath(item: max(0, numberofItemsInSection - 1), section: section)
                var firstItemAttributes : UICollectionViewLayoutAttributes
                var lastItemAttributes : UICollectionViewLayoutAttributes
                
                // 获取section的edgeInsets
                var sectionInset = self.sectionInset
                if let inset = viewDelegate.collectionView?(collectionView, layout: self, insetForSectionAt: section) {
                    sectionInset = inset
                }
                
                if numberofItemsInSection > 0 {
                    firstItemAttributes = layoutAttributesForItem(at: firstItemIndexPath)!
                    lastItemAttributes = layoutAttributesForItem(at: lastItemIndexPath)!
                } else {
                    firstItemAttributes = UICollectionViewLayoutAttributes()
                    let y = CGRectGetMaxX(attributes.frame) + sectionInset.top
                    firstItemAttributes.frame = CGRectMake(0, y, 0, 0)
                    lastItemAttributes = firstItemAttributes
                }
                
                var rect = attributes.frame
                let offset = collectionView.contentOffset.y + self.headerVisibleBoundsOffset
                let headerY = firstItemAttributes.frame.origin.y - rect.size.height - sectionInset.top
                let maxY = max(offset, headerY)
                let headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + sectionInset.bottom - rect.size.height
                rect.origin.y = min(maxY, headerMissingY)
                attributes.frame = rect
                attributes.zIndex = 7
            }
        }
    }
    
    // 修改section背景色
    private func layoutBackgroundColorAttributes(_ supperArray : inout [UICollectionViewLayoutAttributes], forElementsInRect rect : CGRect) {
        for attr in self.decorationViewAttributes {
            if CGRectIntersectsRect(rect, attr.frame){
                supperArray.append(attr)
            }
        }
    }
}
