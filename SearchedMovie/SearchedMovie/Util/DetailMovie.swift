//
//  DetailMovie.swift
//  SearchedMovie
//
//

import Foundation

class DetailMovie {
    static let shared = DetailMovie()
    
    var movie = Movie(
        title: nil,
        subTitle: nil,
        link: nil,
        imageURL: nil,
        pubDate: nil,
        director: nil,
        actors: nil,
        userRating: nil)
}
