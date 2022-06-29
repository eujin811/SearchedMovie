//
//  MovieCell.swift
//  SearchedMovie
//
//  해당 cell은 의존도를 낮추기 위해 callback 형식으로 제작.

import Foundation
import UIKit

import SnapKit

class MovieCell: UITableViewCell {
    static let id = Constant.viewID.moviewCellID
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let starButton = UIButton().then {
        $0.setImage(UIImage.setIcon(.starFill), for: .normal)
    }
    
    private let contentStackView = UIStackView().then {
        let margin: CGFloat = 10
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.layoutMargins.left = margin
        $0.layoutMargins.right = margin
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
        
        self.selectionStyle = .none
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
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(directorLabel)
        contentStackView.addArrangedSubview(actorLabel)
        contentStackView.addArrangedSubview(userRatingLabel)
    }
    
    private func setConstraints() {
        let margin: CGFloat = 10
        
        let imageWidth: CGFloat = 60
        let starSize: CGFloat = 30
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(margin)
            $0.width.equalTo(imageWidth)
        }
        
        starButton.snp.makeConstraints {
            $0.top.equalTo(margin)
            $0.trailing.equalToSuperview().inset(margin)
            $0.width.height.equalTo(starSize)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(margin)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(margin)
            $0.trailing.equalTo(starButton.snp.leading).inset(margin)
        }
        
    }
    
    // MARK: - Function
    
    func configure(
        imageURL: URL?,
        isFavorite: Bool,
        title: String,
        director: String,
        actor: String,
        userRating: String
    ) {
        // contents
        self.titleLabel.text = title.removeTag(.bTag)
        self.directorLabel.text = Constant.view.directorMark + director.removeText(Constant.view.orMark)
        self.actorLabel.text = Constant.view.actorsMark + actor.removeText(Constant.view.orMark)
        self.userRatingLabel.text = Constant.view.ratingMark + userRating
        
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
            
            self?.toggleFavorite()
        }
        
        starButton.addAction(addAction, for: .touchUpInside)
    }
    
    // MARK: - private
    
    private func toggleFavorite() {
        isFavorite.toggle()
        setFavorite(isFavorite)
    }
    
    private func setFavorite(_ isFavorite: Bool) {
        let color = isFavorite ? selectedColor : unselectedColor
        
        starButton.setImage(UIImage.setIcon(.starFill), for: .normal)
        starButton.tintColor = color
    }
    
}
