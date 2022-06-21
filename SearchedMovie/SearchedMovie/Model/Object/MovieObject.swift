//
//  MovieObject.swift
//  SearchedMovie
//
//

import Foundation

import RealmSwift

class MovieObject: Object {
    @objc dynamic var id: Int = -1
    
    @objc dynamic var title: String = String.empty
    @objc dynamic var subtitle: String = String.empty
    @objc dynamic var linkStr: String = String.empty
    var link: URL? {
        return linkStr.toURL()
    }
    @objc dynamic var imageURLStr: String = String.empty
    var imageURL: URL? {
        return imageURLStr.toURL()
    }
    @objc dynamic var pubDate: String = String.empty
    @objc dynamic var director: String = String.empty
    @objc dynamic var actors: String = String.empty
    @objc dynamic var userRating: String = String.empty
    
    override static func primaryKey() -> String? {
        return Constant.db.primaryID
    }
    
    func configure(movie: Movie) {
        self.title = movie.title ?? String.empty
        self.subtitle = movie.subTitle ?? String.empty
        self.linkStr = movie.link ?? String.empty
        self.imageURLStr = movie.imageURL ?? String.empty
        self.pubDate = movie.pubDate ?? String.empty
        self.director = movie.director ?? String.empty
        self.actors = movie.actors ?? String.empty
        self.userRating = movie.userRating ?? String.empty
    }
    
    func makeModel() -> Movie {
        return .init(
            title: self.title,
            subTitle: self.subtitle,
            link: self.linkStr,
            imageURL: self.imageURLStr,
            pubDate: self.pubDate,
            director: self.director,
            actors: self.actors,
            userRating: self.userRating
        )
    }
}
