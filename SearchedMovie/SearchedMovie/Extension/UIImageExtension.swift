//
//  UIImageExtension.swift
//  SearchedMovie
//
//

import Foundation
import UIKit

extension UIImage {
    
    /// SFSymbol icon
    static func setIcon(_ type: SymbolType) -> UIImage? {
        return UIImage(systemName: type.systemName)
    }
    
    enum SymbolType {
        case starFill
        case starSlash
        /// emptyImage
        case photo
        case search
        case xCircle
        case chevronLeft
        case xmark
        
        var systemName: String {
            switch self {
            case .starFill:
                return ViewIdentifier.star
            case .starSlash:
                return ViewIdentifier.starSlash
            case .photo:
                return ViewIdentifier.photo
            case .search:
                return ViewIdentifier.search
            case .xCircle:
                return ViewIdentifier.xCircle
            case .chevronLeft:
                return ViewIdentifier.chevronLeft
            case .xmark:
                return ViewIdentifier.xmark
            }
        }
    }
    
}
