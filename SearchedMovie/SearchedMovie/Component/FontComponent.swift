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
    
    var font: UIFont {
        switch self {
        case .cellTitle:
            return UIFont.boldSystemFont(ofSize: 16)
        case .cellSubtitle:
            return UIFont.systemFont(ofSize: 12)
        }
    }
}
