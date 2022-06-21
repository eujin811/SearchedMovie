//
//  MovieFavoriteViewModel.swift
//  SearchedMovie
//
//

import Foundation

import RxSwift
import RxRelay
import UIKit

class MovieFavoriteViewModel: ViewModelType {
    
    struct Input { }
    
    struct Output {
        let favoritesRelay: ReplayRelay<[Movie]>
        let favoriteCountRelay: ReplayRelay<Int>
    }
    
    private let favoritesRelay = ReplayRelay<[Movie]>.create(bufferSize: 1)
    private let favoriteCountRelay = ReplayRelay<Int>.create(bufferSize: 1)
    
    private let favoriteRequest = FavoriteMovieRequestHelper()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        request()
        
        return Output(favoritesRelay: favoritesRelay, favoriteCountRelay: favoriteCountRelay)
    }
    
    // MARK: - action
    
    func request() {
        let movieResult = favoriteRequest
            .readMovieList()
            .map { objc -> Movie in
                return objc.makeModel()
            }
        
        favoriteCountRelay.accept(movieResult.count)
        
        favoritesRelay.accept(movieResult)
    }
}
