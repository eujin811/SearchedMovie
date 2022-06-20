//
//  MovieDetailViewController.swift
//  SearchedMovie
//

import UIKit
import WebKit

import RxCocoa
import RxSwift
import SnapKit

class MovieDetailViewController: BasicViewController {
    private let viewModel = MovieDetailViewModel()
    
    private let contentsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        
        $0.backgroundColor = .lightGray
    }
    
    private let headerView = DetailViewHeader()
    let webView = WKWebView()
    
    private let isFavoriteRelay = PublishRelay<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUI() {
        super.setUI()
//        navigationItem.backButtonTitle = ""
//        navigationItem.backBarButtonItem?.tintColor = .gray
        
        
        view.addSubview(contentsStackView)
        
        contentsStackView.addArrangedSubview(headerView)
        contentsStackView.addArrangedSubview(webView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        contentsStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
//        webView.snp.makeConstraints {
//            $0.top.leading.trailing.bottom.equalToSuperview()//.equalTo(view.safeAreaLayoutGuide)
//        }
    }
    
    override func bind() {
        super.bind()
        
        let vmOutput = viewModel
            .transform(input: .init(isFavoriteRelay: isFavoriteRelay))
        
        Observable.combineLatest(
            vmOutput.movieRelay,
            vmOutput.isFavoriteRelay)
        .bind(with: self) { owner, data in
            let (movie, isFavorite) = data
            owner.configure(movie: movie, isFavorite: isFavorite)
        }
        .disposed(by: disposeBag)
    }
    
    override func subscribe() {
        super.subscribe()
        
        headerView.didTapStarButton {
            print("tap star")
        }
    }
    
    private func configure(movie: Movie, isFavorite: Bool) {
        title = movie.title?.removeTag(.bTag)
        
        headerView.configure(movie: movie, isFavorite: isFavorite)
        print("configure", movie.title)
    }
    
}
