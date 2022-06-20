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
    }
    
    struct Output {
        let moviesSubject: PublishSubject<[Movie]>
    }
    
    private let moviesSubject = PublishSubject<[Movie]>()
    
    var disposeBag = DisposeBag()
    
    private let movieItemsRelay: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    
    private let searchRelay = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        input.searchedTextRelay
            .subscribe(
                with: self,
                onNext: { owner, searchText in
                    owner.searchMovies(searchText)
                }
            )
            .disposed(by: disposeBag)
                
        return Output(moviesSubject: moviesSubject)
    }
    
    func disappear() {
        moviesSubject
            .disposed(by: disposeBag)
    }
    
    // MARK: - private
    
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
