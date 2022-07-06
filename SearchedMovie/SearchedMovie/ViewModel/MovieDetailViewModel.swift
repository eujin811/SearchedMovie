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
        let movieRelay: ReplayRelay<Movie>
    }
    
    private let movieRelay = ReplayRelay<Movie>.create(bufferSize: 1)

    func transform(input: Input) -> Output {
        let isFavorite = isFavoriate(movie: DetailMovie.shared.movie)
        
        input.isFavoriteRelay.accept(isFavorite)
        input.isFavoriteRelay
            .subscribe(
                with: self,
                onNext: { owner, isFavorite in
                    if isFavorite {
                        owner.registerMovie(movie: DetailMovie.shared.movie)
                    } else {
                        owner.deleteMovie(movie: DetailMovie.shared.movie)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        movieRelay.accept(DetailMovie.shared.movie)
        
        return Output(movieRelay: movieRelay)
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
