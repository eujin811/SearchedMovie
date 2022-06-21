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
    
    private let backButton = UIButton(type: .system).then {
        $0.setImage(UIImage.setIcon(.chevronLeft), for: .normal)
        $0.tintColor = .darkGray
        $0.frame = .init(x: 0, y: 0, width: 15, height: 15)
    }
    private let backButtonItem = UIBarButtonItem()
    
    private let contentsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        
        $0.backgroundColor = .lightGray
    }
    
    private let headerView = DetailViewHeader()
    let webView = WKWebView()
    
    private let isFavoriteRelay = ReplayRelay<Bool>.create(bufferSize: 1)
    private var isFavorite = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUI() {
        super.setUI()
        
        backButtonItem.customView = backButton
        backButton.addTarget(self, action: #selector(popVC(_:)), for: .touchUpInside)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButtonItem
        
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
        
        isFavoriteRelay
            .subscribe(with: self) { owner, isFavorite in
                owner.isFavorite = isFavorite
                owner.headerView.setIsFavorite(isFavorite)
            }
            .disposed(by: disposeBag)
        
        vmOutput.movieRelay
            .bind(with: self) { owner, movie in
                owner.configure(movie: movie)
            }
            .disposed(by: disposeBag)
    }
    
    override func subscribe() {
        super.subscribe()
        
        headerView.didTapStarButton { [weak self] in
            self?.favoriteToggle()
        }
    }
    
    private func favoriteToggle() {
        isFavoriteRelay.accept(!isFavorite)
    }
    
    private func configure(movie: Movie) {
        title = movie.title?.removeTag(.bTag)
        
        headerView.configure(movie: movie)
//        loadWebView(url: movie.link?.toURL())
    }
    
    @objc private func popVC(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
