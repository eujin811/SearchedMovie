//
//  MovieSearchViewController.swift
//  SearchedMovie
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class MovieSearchViewController: BasicViewController {
    let viewModel = MovieSearchViewModel()
    
    private let searchedTextRelay = ReplayRelay<String>.create(bufferSize: 1)
    private let selectedItemRelay = ReplayRelay<Movie>.create(bufferSize: 1)
    
    private let customNaviBar = MovieSearchBar()
    private let customSearchBar = CustomSearchBar()
    private let movieTableView = UITableView().then {
        $0.register(MovieCell.self, forCellReuseIdentifier: MovieCell.id)
        $0.rowHeight = 100
    }
    
    private let padding: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - setUI
    
    override func setUI() {
        super.setUI()
        
        customNaviBar.setTitle(AppComponent.appTitle)

        view.addSubview(customSearchBar)
        view.addSubview(movieTableView)
        
        view.addSubview(customNaviBar)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let searchBarHeight: CGFloat = 36
        let navibarHeight: CGFloat = 60
        
        customNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(navibarHeight)
        }
        
        customSearchBar.snp.makeConstraints {
            $0.top.equalTo(customNaviBar.snp.bottom).offset(padding)
            $0.leading.trailing.equalToSuperview().inset(padding)
            $0.height.equalTo(searchBarHeight)
        }
        
        movieTableView.snp.makeConstraints {
            $0.top.equalTo(customSearchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(padding)
            $0.bottom.equalToSuperview()
        }
        
    }
   
    // MARK: - bind
    
    override func bind() {
        super.bind()
        let vmOutput = viewModel
            .transform(input: .init(
                searchedTextRelay: self.searchedTextRelay,
                selectedItemRelay: self.selectedItemRelay))
        
        bindTableView(subject: vmOutput.moviesSubject)
    }
    
    private func bindTableView(subject: PublishSubject<[Movie]>) {
        subject
            .subscribe(on: MainScheduler.instance)
            .bind(to: movieTableView.rx
            .items(
                cellIdentifier: MovieCell.id,
                cellType: MovieCell.self
            )) { [weak self] index, movie, cell in
                guard let self = self else { return }
                
                let isFavoriate = self.viewModel.isFavoriate(movie: movie)
                
                cell.configure(
                    imageURL: movie.imageURL?.toURL(),
                    isFavorite: isFavoriate,
                    title: movie.title ?? String.empty,
                    director: movie.director ?? String.empty,
                    actor: movie.actors ?? String.empty,
                    userRating: movie.userRating ?? String.empty
                )
                
                cell.didTapStarButton { [weak self] in
                    self?.selectedItemRelay.accept(movie)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - subscribe
    
    override func subscribe() {
        movieTableView.rx
            .modelSelected(Movie.self)
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, movie in
                    DetailMovie.shared.movie = movie
                    owner.showDetail()
                }
            )
            .disposed(by: disposeBag)
        
        customNaviBar.didTapButton { [weak self] in
            self?.presnetFavorite()
        }

        subscribeSearchBar()
    }
    
    func subscribeSearchBar() {
        let searchBarTextField = customSearchBar.textField
        
        searchBarTextField.rx.controlEvent([.editingDidEndOnExit])
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, searchText in
                    owner.searchedTextRelay
                        .accept(searchBarTextField.text ?? String.empty)
                    owner.customSearchBar.showCancelButton()
                }
            )
            .disposed(by: disposeBag)
        
        searchBarTextField.rx.controlEvent([.editingChanged])
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    let searchText = searchBarTextField.text
                    if searchText == String.empty {
                        owner.customSearchBar.showSearchButton()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        customSearchBar.didTapCancelButton {}
        customSearchBar.didTapSearchButton { [weak self] in
            self?.searchedTextRelay
                .accept(searchBarTextField.text ?? String.empty)
        }
    }
    
    // MARK: - action
    
    private func showDetail() {
        let detailVC = MovieDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func presnetFavorite() {
        let favoriteVC = UINavigationController(
            rootViewController: MovieFavoriteViewController())
        favoriteVC.modalPresentationStyle = .fullScreen
        
        self.present(favoriteVC, animated: true)
    }
}
