//
//  MovieCell.swift
//  SearchedMovie
//
//  해당 cell은 의존도를 낮추기 위해 callback 형식으로 제작.

import Foundation
import UIKit

import SnapKit

class MovieCell: UITableViewCell {
    let id = Constant.viewID.moviewCellID
    
    private let posterImageView = UIImageView()
    private let starButton = UIButton().then {
        $0.setImage(UIImage.setIcon(.starFill), for: .normal)
  
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.font(to: .cellTitle)
    }
    private let directorLabel = UILabel().then {
        $0.font = UIFont.font(to: .cellSubtitle)
    }
    private let actorLabel = UILabel().then {
        $0.font = UIFont.font(to: .cellSubtitle)
    }
    private let userRatingLabel = UILabel().then {
        $0.font = UIFont.font(to: .cellSubtitle)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    private let selectedColor = UIColor.yellow
    private let unselectedColor = UIColor.lightGray
    
    private var isFavorite = Bool()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(starButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(directorLabel)
        contentView.addSubview(actorLabel)
        contentView.addSubview(userRatingLabel)
    }
    
    private func setConstraints() {
        let margin: CGFloat = 10
        
        let imageWidth: CGFloat = 80
        let starSize: CGFloat = 30
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(imageWidth)
        }
        
        starButton.snp.makeConstraints {
            $0.top.trailing.equalTo(margin)
            $0.width.height.equalTo(starSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView)
            $0.leading.equalTo(posterImageView.snp.trailing)
        }
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel)
        }
        actorLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom)
            $0.leading.equalTo(titleLabel)
        }
        userRatingLabel.snp.makeConstraints {
            $0.top.equalTo(actorLabel.snp.bottom)
            $0.leading.equalTo(titleLabel)
        }
    }
    
    // MARK: - Function
    
    func configure(
        imageURL: URL?,
        isFavorite: Bool,
        title: String,
        director: String,
        action: String,
        userRating: String
    ) {
        self.titleLabel.text = title
        self.directorLabel.text = director
        self.actorLabel.text = action
        self.userRatingLabel.text = userRating
        
        // image
        let emptyImage = UIImage.setIcon(.photo)
        posterImageView.image = imageURL?.toImage() ?? emptyImage
        
        // button
        setFavorite(isFavorite)
        self.isFavorite = isFavorite
    }
    
    func didTapStarButton(_ action: @escaping() -> Void) {
        let addAction = UIAction { [weak self] _ in
            action()
            
            self?.isFavorite.toggle()
            self?.setFavorite()
        }
        
        starButton.addAction(addAction, for: .touchUpInside)
    }
    
    // MARK: - private
    
    private func setFavorite(_ isFavorite: Bool? = nil) {
        let isChecked = isFavorite ?? self.isFavorite
        let color = isChecked ? selectedColor : unselectedColor
        starButton
            .setImage(
                UIImage.setIcon(.starFill)?.withTintColor(color),
                for: .normal
            )
    }
    
}
