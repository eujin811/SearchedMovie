//
//  EmptyFavoriteView.swift
//  SearchedMovie
//
//

import UIKit

import RxCocoa
import SnapKit

class EmptyFavoriteView: CustomView {
    let emptyImageView = UIImageView().then {
        $0.image = UIImage.setIcon(.starSlash)
        $0.contentMode = .scaleAspectFill
    }
    
    let emptyMessage = UILabel().then {
        $0.text = Constant.view.emptyFavorite
    }
    
    override func setUI() {
        super.setUI()
        
        self.addSubview(emptyImageView)
        self.addSubview(emptyMessage)
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        let padding: CGFloat = 10
        
        let imageSize: CGFloat = 100
        
        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY)
            $0.size.equalTo(imageSize)
        }
        
        emptyMessage.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(padding)
            $0.centerX.equalToSuperview()
        }
        
    }
}
