//
//  StringExtension.swift
//  SearchedMovie
//

import Foundation
import UIKit

extension String {
    static let empty = ""
    
    func toURL() -> URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
    
    func toImage() -> UIImage? {
        guard let imageURL = self.toURL() else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL),
                let image = UIImage(data: imageData)
        else { return nil }
        
        return image
    }
    
    func removeText(_ text: String) -> String {
        return self.replacingOccurrences(of: text, with: String.empty)
    }
    
    func removeTag(_ tagType: HTMLTagType) -> String {
        let (firstTag, secondeTag) = tagType.tags
        
        return self
            .replacingOccurrences(of: firstTag, with: String.empty)
            .replacingOccurrences(of: secondeTag, with: String.empty)
    }
}
