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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disappear()
    }

    // MARK: - setUI
    
    override func setUI() {
        super.setUI()
        

        view.addSubview(customSearchBar)
        view.addSubview(movieTableView)
        
        setNaviBar()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let searchBarHeight: CGFloat = 36
        
        customSearchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(padding)
            $0.leading.trailing.equalToSuperview().inset(padding)
            $0.height.equalTo(searchBarHeight)
        }
        
        movieTableView.snp.makeConstraints {
            $0.top.equalTo(customSearchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(padding)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private func setNaviBar() {
        guard let navibarHeight = navigationController?.navigationBar.frame.height else { return }
        
        customNaviBar.frame.size.height = navibarHeight
        
        navigationItem.titleView = customNaviBar
        customNaviBar.setTitle(AppComponent.appTitle)

        customSearchBar.inset(padding)
    }
    
    // MARK: - bind
    
    override func bind() {
        super.bind()
        let vmOutput = viewModel
            .transform(input: .init(searchedTextRelay: self.searchedTextRelay))
        
        bindTableView(subject: vmOutput.moviesSubject)
    }
    
    private func bindTableView(subject: PublishSubject<[Movie]>) {
        subject
            .subscribe(on: MainScheduler.instance)
            .bind(to: movieTableView.rx
            .items(
                cellIdentifier: MovieCell.id,
                cellType: MovieCell.self
            )) { index, movie, cell in
                // TODO: isFavorite check
                let testFavorite = false    // data binding 할때 체크해서 넣어줄까?? Model 따로 만들어서?? 아니면 그냥 여기서 체크할까..
                
                cell.configure(
                    imageURL: movie.imageURL?.toURL(),
                    isFavorite: testFavorite,
                    title: movie.title ?? String.empty,
                    director: movie.director ?? String.empty,
                    actor: movie.actors ?? String.empty,
                    userRating: movie.userRating ?? String.empty
                )

                cell.didTapStarButton {
                    // MARK: completion
                    print("selelct")
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
//            self?.viewModel.showFavorite()
            print("즐찾 보여줭")
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
    
}
