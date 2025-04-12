//
//  SudokuLayout.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import UIKit

class SudokuLayout: UICollectionViewLayout {
    let smallOffset: CGFloat = 1.0
    let largeOffset: CGFloat = 2.0
    
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var contentBounds = CGRect.zero
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        print(UIScreen.main.bounds.width)
        print(collectionView.bounds)
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        let availableWidth = UIScreen.main.bounds.width - 32.0
        let cellSize = floor((availableWidth - 8.0 * smallOffset - 4.0 * largeOffset) / CGFloat(SudokuConstants.fildSize))
        
        var yOffset: CGFloat = 0.0
        for row in 0..<SudokuConstants.fildSize {
            
            var xOffset: CGFloat = 0
            yOffset += offsetInGrid(component: row)
            
            let yPosition = yOffset + cellSize * CGFloat(row)
            
            for column in 0..<SudokuConstants.fildSize {
                
                xOffset += offsetInGrid(component: column)
                
                let indexPath = IndexPath(item: column, section: row)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let xPosition = xOffset + cellSize * CGFloat(column)
                
                attributes.frame = CGRect(x: xPosition, y: yPosition, width: cellSize, height: cellSize)
                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(attributes.frame)
            }
        }
    }
    
    /// - Tag: CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    /// - Tag: ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    /// - Tag: LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.section * 9 + indexPath.item]
    }
    
    /// - Tag: LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
        
        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }
    
    // Perform a binary search on the cached attributes array.
    private func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
    
    // Returns offset for Row or Column due to symetry. I.e. largeOffset or smallOffset
    private func offsetInGrid(component: Int) -> CGFloat {
        (component % 3 == 0) ? largeOffset : smallOffset
    }
}
