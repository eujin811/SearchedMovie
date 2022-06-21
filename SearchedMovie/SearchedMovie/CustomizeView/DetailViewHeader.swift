//
//  DetailViewHeader.swift
//  SearchedMovie
//
//

import UIKit

import SnapKit

class DetailViewHeader: CustomView {
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let starButton = UIButton().then {
        $0.setImage(UIImage.setIcon(.starFill), for: .normal)
        $0.tintColor = .lightGray
    }

    private let directorLabel = UILabel().then {
        $0.font = UIFont.font(to: .headerViewLabel)
    }
    private let actorsLabel = UILabel().then {
        $0.font = UIFont.font(to: .headerViewLabel)
    }
    private let ratingLabel = UILabel().then {
        $0.font = UIFont.font(to: .headerViewLabel)
    }

    private let margin: CGFloat = 10
    
    private let favoriteColor = UIColor.yellow
    private let unFavoriteColor = UIColor.lightGray
    
    private var isFavorite = Bool()
    
    override func setUI() {
        super.setUI()
        self.backgroundColor = .white
        
        self.addSubview(posterImageView)
        self.addSubview(starButton)
        
        self.addSubview(directorLabel)
        self.addSubview(actorsLabel)
        self.addSubview(ratingLabel)
    }
    
    override func setConstraint() {
        super.setConstraint()
        
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
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(margin)
            $0.trailing.equalTo(starButton.snp.leading).inset(margin)
        }
        
        actorsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(directorLabel)
            $0.trailing.equalTo(directorLabel)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView)
            $0.leading.equalTo(directorLabel)
            $0.trailing.equalTo(directorLabel)
        }
    }
    
    // MARK: - action
    
    func configure(movie: Movie) {
        let emptyImage = UIImage.setIcon(.photo)
        posterImageView.image = movie.imageURL?.toImage() ?? emptyImage
        
        let director = movie.director?.removeText(Constant.view.orMark) ?? String.empty
        directorLabel.text = Constant.view.directorMark + director
        
        let actors = movie.actors?.removeText(Constant.view.orMark) ?? String.empty
        actorsLabel.text = Constant.view.actorsMark + actors
        
        let rating = movie.userRating ?? String.empty
        ratingLabel.text = Constant.view.ratingMark + rating
    }
    
    func setIsFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
        setFavorite(isFavorite)
    }
    
    func didTapStarButton(_ action: @escaping() -> Void) {
        let addAction = UIAction { [weak self] _ in
            action()
//            self?.toggleFavorite()
        }
        
        starButton.addAction(addAction, for: .touchUpInside)
    }
    
    private func toggleFavorite() {
        setFavorite(!isFavorite)
        self.isFavorite.toggle()
    }
    
    private func setFavorite(_ isFavorite: Bool) {
        let color = isFavorite ? favoriteColor : unFavoriteColor
        starButton.tintColor = color
    }
}
