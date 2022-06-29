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
    }
    
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.backgroundColor = .white
    }
    
    private let headerView = DetailViewHeader()
    let webView = WKWebView().then {
        $0.scrollView.isScrollEnabled = false
    }
    
    private let isFavoriteRelay = ReplayRelay<Bool>.create(bufferSize: 1)
    private var isFavorite = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func setUI() {
        super.setUI()
        
        backButtonItem.customView = backButton
        backButton.addTarget(self, action: #selector(popVC(_:)), for: .touchUpInside)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButtonItem
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentsStackView)
        
        contentsStackView.addArrangedSubview(webView)
        
        webView.addSubview(headerView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let screenBound = UIScreen.main.bounds
        
        let headerViewHeight: CGFloat = 120
        let webViewHeight: CGFloat = screenBound.height * 1.35
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        contentsStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(screenBound.width)
            $0.height.equalTo(webViewHeight)
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(headerViewHeight)
        }
        
        webView.snp.makeConstraints {
            $0.height.equalTo(webViewHeight)
        }
    }
    
    override func bind() {
        super.bind()
        
        let vmOutput = viewModel
            .transform(input: .init(isFavoriteRelay: isFavoriteRelay))
        
        isFavoriteRelay
            .subscribe(with: self
            ) { owner, isFavorite in
                owner.isFavorite = isFavorite
                owner.headerView.setIsFavorite(isFavorite)
            }
            .disposed(by: disposeBag)
        
        vmOutput.movieRelay
            .bind(with: self
            ) { owner, movie in
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
        loadWebView(url: movie.link?.toURL())
    }
    
    @objc private func popVC(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
