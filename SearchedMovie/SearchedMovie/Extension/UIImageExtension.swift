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
        /// emptyImage
        case photo      
        
        var systemName: String {
            switch self {
            case .starFill:
                return ViewIdentifier.star
            case .photo:
                return ViewIdentifier.photo
            }
        }
    }
    
}
