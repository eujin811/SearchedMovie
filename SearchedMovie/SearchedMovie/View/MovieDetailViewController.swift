//
//  MovieDetailViewController.swift
//  SearchedMovie
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class MovieDetailViewController: BasicViewController {
    private let viewModel = MovieDetailViewModel()
    
    private let isFavoriteRelay = PublishRelay<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUI() {
        super.setUI()
    }
    
    override func setConstraints() {
        super.setConstraints()
    }
    
    override func bind() {
        super.bind()
        
        let vmOutput = viewModel
            .transform(input: .init(isFavoriteRelay: isFavoriteRelay))
    }
    
    override func subscribe() {
        super.subscribe()
    }
    
}
