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
    private let request = FavoriteMovieRequestHelper()
    var disposeBag = DisposeBag()

    struct Input {
        let searchedTextRelay: ReplayRelay<String>
        let favoriateSelectedItemRelay: ReplayRelay<Movie>
    }
    
    struct Output {
        let moviesRelay: BehaviorRelay<[Movie]>
    }
    
    private let moviesRelay = BehaviorRelay(value: [Movie]())

    func transform(input: Input) -> Output {

        input.favoriateSelectedItemRelay
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
        
        return Output(moviesRelay: moviesRelay)
    }
    
    // MARK: - Action
    
    func isFavoriate(movie: Movie) -> Bool {
        guard let link = movie.link else { return false }
        let (owneMovie) = request.readMovie(link: link)
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
                with: self,
                onSuccess: { owner, movies in
                    owner.moviesRelay.accept(movies)
                },
                onFailure: { owner, error in
                    owner.relatedError(error)
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
