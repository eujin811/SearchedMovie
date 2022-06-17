//
//  ParsingConstant.swift
//  SearchedMovie
//
//

import Foundation

enum ParsingConstant {
    static let parsingType = "application/json"
    
    // MARK: URL
    static let searchedMovieURL = "https://openapi.naver.com/v1/search/movie.json"
    
    // MARK: Field
    static let queryField = "query"
    static let searchDisplayField = "display"      // 검색 결과 출력 건수를 지정, 기본 10, 최대 100
    static let searchPositionField = "start"       // 검색 시작 위치 지정, 최대 1000까지
//    static let genreField = "genre"
    
    static let contentTypeField = "Content-Type"
    static let acceptField = "Accept"

    static let naverClientIDField = "X-Naver-Client-Id"
    static let naverClientPWField = "X-Naver-Client-Secret"
    
    // 출력결과
    static let searchResult = "channel"
    static let searchItem = "items"       // 검색결과 개별 아이템
    static let movieTitle = "title"       // 검색어와 일치하는 부분 태그로 감싸져 있음.
    static let movieLink  = "link"        // 영화 하이퍼텍스트 link
    static let movieImage = "image"
    static let movieSubtitle = "subtitle"
    static let moviePubDate = "pubDate"
    static let movieDirector = "director"
    static let movieActor = "actor"
    static let movieUserRating = "userRating"
}
