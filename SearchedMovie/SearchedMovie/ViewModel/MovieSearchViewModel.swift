//
//  MovieSearchViewModel.swift
//  SearchedMovie
//
//

import Foundation
import RxSwift
import RxCocoa

class MovieSearchViewModel: ViewModelType  {
    private let api = MovieSearchAPI()
    
    struct Input {
        let searchedTextRelay: ReplayRelay<String>
        let selectedItemRelay: ReplayRelay<Movie>
    }
    
    struct Output {
        let moviesSubject: PublishSubject<[Movie]>
    }
    
    private let moviesSubject = PublishSubject<[Movie]>()
    
    private let request = FavoriteMovieRequestHelper()

    var disposeBag = DisposeBag()
    
    private let movieItemsRelay: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    
    private let searchRelay = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        input.selectedItemRelay
            .subscribe(with: self
            ) { owner, item in
                owner.checkedFavorite(movie: item)
            }
            .disposed(by: disposeBag)
        
        input.searchedTextRelay
            .subscribe(with: self
            ) { owner, searchText in
                owner.searchMovies(searchText)
            }
            .disposed(by: disposeBag)
                
        return Output(moviesSubject: moviesSubject)
    }
    
    func disappear() {
        moviesSubject
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    func isFavoriate(movie: Movie) -> Bool {
        guard let title = movie.title else { return false }
        let (owneMovie) = request.readMovie(title: title)
        return owneMovie != nil
    }
    
    private func checkedFavorite(movie: Movie) {
        let isFavorite = isFavoriate(movie: movie)
        
        if isFavorite {
            request.deleteMovie(movie: movie)
        } else {
            request.createMovie(movie)
        }
    }
    
    private func searchMovies(_ searchText: String) {
        api.request(type: .movies(searchText))
            .subscribe(
                onSuccess: { [weak self] movies in
                    self?.moviesSubject.onNext(movies)
                },
                onFailure: { [weak self] error in
                    self?.relatedError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func relatedError(_ error: Error) {
        if let smError = error as? SMError {
            print(smError.errorDescription)
        } else {
            print(error.localizedDescription)
        }
    }
    
}
