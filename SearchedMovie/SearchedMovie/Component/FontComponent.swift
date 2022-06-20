//
//  FontComponent.swift
//  SearchedMovie
//
//

import Foundation
import UIKit

enum FontComponent {
    case cellTitle
    case cellSubtitle
    case barTitle
    case headerViewLabel
    
    case miniButton
    
    var font: UIFont {
        switch self {
        case .cellTitle:
            return UIFont.boldSystemFont(ofSize: 16)
        case .cellSubtitle:
            return UIFont.systemFont(ofSize: 12)
        case .barTitle:
            return UIFont.boldSystemFont(ofSize: 24)
        case .headerViewLabel:
            return UIFont.systemFont(ofSize: 14)
        case .miniButton:
            return UIFont.systemFont(ofSize: 12)
        }
    }
}
