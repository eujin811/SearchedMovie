//
//  Movie.swift
//  SearchedMovie
//

import Foundation

struct MovieResults: Codable {
    let items: [Movie]
}

struct Movie: Codable {
    let title: String?
    let subTitle: String?
    let link: String?
    let imageURL: String?
    let pubDate: String?
    let director: String?
    let actors: String?
    let userRating: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, link, pubDate, director, userRating
        case subTitle = "subtitle"
        case imageURL = "image"
        case actors = "actor"
    }
}

