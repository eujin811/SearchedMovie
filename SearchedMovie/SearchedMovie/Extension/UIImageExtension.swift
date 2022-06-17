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
        
        var systemName: String {
            switch self {
            case .starFill:
                return "star.fill"
            }
        }
    }
    
}
