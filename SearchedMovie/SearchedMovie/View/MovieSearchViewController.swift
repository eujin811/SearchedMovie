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
    
    private let movieTableView = UITableView().then {
        $0.register(MovieCell.self, forCellReuseIdentifier: MovieCell.id)
        $0.rowHeight = 100
    }
    
    private let customSearchBar = CustomSearchBar()
    
    private let padding: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disappear()
    }
    
    override func setUI() {
        super.setUI()
        title = AppComponent.appTitle
        
        customSearchBar.inset(padding)
        
        view.addSubview(customSearchBar)
        view.addSubview(movieTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let searchBarHeight: CGFloat = 40
        
        customSearchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
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
        let output = viewModel
            .transform(input: .init(searchedTextRelay: self.searchedTextRelay))
        
        bindTableView(subject: output.moviesSubject)
    }
    
    private func bindTableView(subject: PublishSubject<[Movie]>) {
        subject.bind(to: movieTableView.rx
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
    
    override func subscribe() {
        movieTableView.rx
            .modelSelected(Movie.self)
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, movie in
                    print("selected", movie)
                    owner.viewModel.showDetailView()
                }
            )
            .disposed(by: disposeBag)
        
        // TODO: searchView
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
            print("search")
            self?.searchedTextRelay
                .accept(searchBarTextField.text ?? String.empty)
        }
    }
    
}
