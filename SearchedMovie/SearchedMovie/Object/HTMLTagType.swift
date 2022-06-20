//
//  HTMLTagType.swift
//  SearchedMovie
//
//

import Foundation

enum HTMLTagType {
    case html
    case body

    case bTag
    
    var tags: (String, String) {
        switch self {
        case .html:
            return ("<html>", "</html>")
        case .body:
            return ("<body>", "</body>")
        case .bTag:
            return ("<b>", "</b>")
        }
    }
}
