//
//  URLExtension.swift
//  SearchedMovie
//

import Foundation
import UIKit

extension URL {
    func toImage() -> UIImage? {
        guard let imageData = try? Data(contentsOf: self),
                let image = UIImage(data: imageData)
        else { return nil }
        
        return image
    }
}
