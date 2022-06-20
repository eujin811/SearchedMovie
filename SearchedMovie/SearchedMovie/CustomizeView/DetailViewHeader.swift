//
//  DetailViewHeader.swift
//  SearchedMovie
//
//

import UIKit

import SnapKit

class DetailViewHeader: CustomView {
    private let posterImageView = UIImageView()
    private let starButton = UIButton().then {
        $0.setImage(UIImage.setIcon(.starFill), for: .normal)
        $0.tintColor = .lightGray
    }

    private let directorLabel = UILabel()
    private let actorsLabel = UILabel()
    private let ratingLabel = UILabel()

    private let margin: CGFloat = 10
    
    private let favoriteColor = UIColor.yellow
    private let unFavoriteColor = UIColor.lightGray
    
    private var isFavorite = Bool()
    
    override func setUI() {
        super.setUI()
        
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
        }
        
        actorsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(directorLabel)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView)
            $0.leading.equalTo(directorLabel)
        }
    }
    
    // MARK: - action
    
    func configure(movie: Movie, isFavorite: Bool) {
        posterImageView.image = movie.imageURL?.toImage()
        
        let director = movie.director?.removeText(Constant.view.orMark) ?? String.empty
        directorLabel.text = Constant.view.directorMark + director
        
        let actors = movie.actors?.removeText(Constant.view.orMark) ?? String.empty
        actorsLabel.text = Constant.view.actorsMark + actors
        
        let rating = movie.userRating ?? String.empty
        ratingLabel.text = Constant.view.ratingMark + rating
        
        self.isFavorite = isFavorite
        setFavorite(isFavorite)
    }
    
    func didTapStarButton(_ action: @escaping() -> Void) {
        let addAction = UIAction { [weak self] _ in
            action()
            
            self?.toggleFavorite()
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
