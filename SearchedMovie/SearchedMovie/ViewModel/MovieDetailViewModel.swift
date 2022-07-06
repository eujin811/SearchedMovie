//
//  MovieDetailViewModel.swift
//  SearchedMovie
//
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel: ViewModelType {
    private let request = FavoriteMovieRequestHelper()
    var disposeBag = DisposeBag()
    
    struct Input {
        let isFavoriteRelay: ReplayRelay<Bool>
    }
    
    struct Output {
        let movieDriver: Driver<Movie>
    }
    
    func transform(input: Input) -> Output {
        let movie = DetailMovie.shared.movie
        let movieRelay = BehaviorRelay(value: movie)
        
        let isFavorite = isFavoriate(movie: movie)
        
        input.isFavoriteRelay.accept(isFavorite)
        
        input.isFavoriteRelay
            .subscribe(with: self
            ) { owner, isFavorite in
                if isFavorite {
                    owner.registerMovie(movie: movie)
                } else {
                    owner.deleteMovie(movie: movie)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(movieDriver: movieRelay.asDriver(onErrorJustReturn: Movie.empty()))
    }
    
    func isFavoriate(movie: Movie) -> Bool {
        guard let link = movie.link else { return false }
        let (owneMovie) = request.readMovie(link: link)
        return owneMovie != nil
    }
    
    func registerMovie(movie: Movie) {
        request.createMovie(movie)
    }
    
    func deleteMovie(movie: Movie) {
        request.deleteMovie(movie: movie)
    }
}
