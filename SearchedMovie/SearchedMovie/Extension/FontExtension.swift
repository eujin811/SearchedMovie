//
//  FontExtension.swift
//  SearchedMovie
//
//

import Foundation
import UIKit

extension UIFont {
    static func font(to fontType: FontComponent) -> UIFont {
        return fontType.font
    }
}
