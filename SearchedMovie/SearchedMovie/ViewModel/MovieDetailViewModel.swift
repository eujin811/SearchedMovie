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
        let movieRelay: PublishRelay<Movie>
    }
    
    var disposeBag = DisposeBag()
    
    private let movieRelay = PublishRelay<Movie>()

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
        
        print("detail!!!", DetailMovie.shared.movie)
        
        return Output(movieRelay: movieRelay)
    }
    
    func loadWebView() {
        
    }
}
