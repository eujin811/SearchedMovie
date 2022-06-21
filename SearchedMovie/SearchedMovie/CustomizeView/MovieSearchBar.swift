//
//  MovieSearchBar.swift
//  SearchedMovie
//
//

import UIKit

import SnapKit

class MovieSearchBar: CustomView {
    private let titleLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = UIFont.font(to: .barTitle)
    }
    
    private let shadow = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    private let favoriteButton = UIButton().then {
        $0.setTitle(ViewConstant.favorite, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.font(to: .miniButton)
        $0.setImage(UIImage.setIcon(.starFill), for: .normal)
        $0.tintColor = .yellow
        
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        $0.layer.borderWidth = 1
        
    }
    
    override func setUI() {
        super.setUI()
        self.frame.size.width = screenSize.width
        
        self.addSubview(shadow)
        self.addSubview(titleLabel)
        self.addSubview(favoriteButton)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
        
        contentsConstraint()
    }
    
    private func contentsConstraint() {
        let margin: CGFloat = 10
        let titleLabelPadding: CGFloat = 20
        
        let buttonHeight: CGFloat = 24
        let buttonWidth: CGFloat = 76
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(titleLabelPadding)
        }
        
        shadow.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(screenSize.width)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(buttonWidth)
        }
    }
    
    // MARK: - Action
    func didTapButton(_ action: @escaping() -> Void) {
        let addAction = UIAction { _ in
            action()
        }
        
        favoriteButton.addAction(addAction, for: .touchUpInside)
    }
}
