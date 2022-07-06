//
//  MovieFavoriteViewModel.swift
//  SearchedMovie
//
//

import Foundation

import RxSwift
import RxRelay
import UIKit
import RxCocoa

class MovieFavoriteViewModel: ViewModelType {
    private let favoriteRequest = FavoriteMovieRequestHelper()
    var disposeBag = DisposeBag()
    
    struct Input {
        let selectedItemRelay: ReplayRelay<Movie>
    }
    
    struct Output {
        let favoriteDriver: Driver<[Movie]>
        let favoriteCountDriver: Driver<Int>
    }
    
    private let favoritesSubject = ReplaySubject<[Movie]>.create(bufferSize: 1)
    private let favoriteCountSubject = ReplaySubject<Int>.create(bufferSize: 1)
    
    func transform(input: Input) -> Output {
        input.selectedItemRelay
            .subscribe(with: self
            ) { owner, item in
                owner.checkedFavorite(movie: item)
            }
            .disposed(by: disposeBag)
        
        request()
        
        return Output(
            favoriteDriver: favoritesSubject.asDriver(onErrorJustReturn: []),
            favoriteCountDriver: favoriteCountSubject.asDriver(onErrorJustReturn: 0)
        )
    }
    
    // MARK: - Action
    
    func request() {
        let movieResult = favoriteRequest
            .readMovieList()
            .map { objc -> Movie in
                return objc.makeModel()
            }
        
        favoriteCountSubject.onNext(movieResult.count)
        favoritesSubject.onNext(movieResult)
    }
    
    func isFavoriate(movie: Movie) -> Bool {
        guard let link = movie.link else { return false }
        let (owneMovie) = favoriteRequest.readMovie(link: link)
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
