//
//  StringExtension.swift
//  SearchedMovie
//

import Foundation
import UIKit

extension String {
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
}
