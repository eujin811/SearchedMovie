//
//  MovieDetailViewModel.swift
//  SearchedMovie
//
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel: ViewModelType {
    struct Input {
        let isFavoriteRelay: PublishRelay<Bool>
    }
    
    struct Output {
        let movieRelay: ReplayRelay<Movie>
        let isFavoriteRelay: ReplayRelay<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    private let movieRelay = ReplayRelay<Movie>.create(bufferSize: 1)
    private let isFavorite = ReplayRelay<Bool>.create(bufferSize: 1)

    func transform(input: Input) -> Output {
        input.isFavoriteRelay
            .subscribe(
                with: self,
                onNext: { owner, isFavorite in
                    print("isFavorite")
                }
            )
            .disposed(by: disposeBag)
        
        movieRelay.accept(DetailMovie.shared.movie)
        
        checkFavorite()
        print("detail!!!", DetailMovie.shared.movie)
        
        return Output(movieRelay: movieRelay, isFavoriteRelay: isFavorite)
    }
    
    // TODO
    func checkFavorite() {
        isFavorite.accept(true)
    }
    
}
