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
    
    struct Input {
        let selectedItemRelay: ReplayRelay<Movie>
    }
    
    struct Output {
        let favoritesRelay: ReplayRelay<[Movie]>
        let favoriteCountRelay: ReplayRelay<Int>
    }
    
    private let favoritesRelay = ReplayRelay<[Movie]>.create(bufferSize: 1)
    private let favoriteCountRelay = ReplayRelay<Int>.create(bufferSize: 1)
    
    private let favoriteRequest = FavoriteMovieRequestHelper()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.selectedItemRelay
            .subscribe(with: self
            ) { owner, item in
                owner.checkedFavorite(movie: item)
            }
            .disposed(by: disposeBag)
        
        request()
        
        return Output(favoritesRelay: favoritesRelay, favoriteCountRelay: favoriteCountRelay)
    }
    
    // MARK: - Action
    
    func request() {
        let movieResult = favoriteRequest
            .readMovieList()
            .map { objc -> Movie in
                return objc.makeModel()
            }
        
        favoriteCountRelay.accept(movieResult.count)
        
        favoritesRelay.accept(movieResult)
    }
    
    func isFavoriate(movie: Movie) -> Bool {
        guard let title = movie.title else { return false }
        let (owneMovie) = favoriteRequest.readMovie(title: title)
        return owneMovie != nil
    }
    
    private func checkedFavorite(movie: Movie) {
        let isFavorite = isFavoriate(movie: movie)
        
        if isFavorite {
            favoriteRequest.deleteMovie(movie: movie)
        } else {
            favoriteRequest.createMovie(movie)
        }
    }
    
}
