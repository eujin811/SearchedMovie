//
//  MovieFavoriteViewController.swift
//  SearchedMovie
//
//
import UIKit

import RxCocoa
import SnapKit

class MovieFavoriteViewController: BasicViewController {
    private let viewModel = MovieFavoriteViewModel()
    
    private let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage.setIcon(.xmark), for: .normal)
        $0.tintColor = .darkGray
        $0.frame = .init(x: 0, y: 0, width: 15, height: 15)
    }
    private let closeButtonItem = UIBarButtonItem()
    
    private let movieTableView = UITableView().then {
        $0.register(MovieCell.self, forCellReuseIdentifier: MovieCell.id)
        $0.rowHeight = 100
    }
    
    private let emptyView = EmptyFavoriteView().then {
        $0.isHidden = true
    }
    
    private let selectedItemRelay = ReplayRelay<Movie>.create(bufferSize: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        super.setUI()
        title = Constant.view.favoriteTitle
        closeButtonItem.customView = closeButton
        closeButton.addTarget(self, action: #selector(dismissVC(_:)), for: .touchUpInside)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = closeButtonItem
        
        view.addSubview(movieTableView)
        view.addSubview(emptyView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        movieTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(movieTableView)
        }
    }
    
    override func bind() {
        super.bind()
        let vmOutput = viewModel.transform(input: .init(selectedItemRelay: selectedItemRelay))
        
        vmOutput.favoriteCountRelay
            .bind(with: self) { owner, count in
                
                let isEmpty = count < 1
                owner.emptyView.isHidden = !isEmpty
                owner.movieTableView.isHidden = isEmpty
            }
            .disposed(by: disposeBag)
        
        vmOutput.favoritesRelay
            .bind(to: movieTableView.rx
            .items(
                cellIdentifier: MovieCell.id,
                cellType: MovieCell.self
            )) { [weak self] index, movie, cell in
                guard let self = self else { return }
                let isFavorite = self.viewModel.isFavoriate(movie: movie)
                
                cell.configure(
                    imageURL: movie.imageURL?.toURL(),
                    isFavorite: isFavorite,
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
    
    override func subscribe() {
        super.subscribe()
        
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
    }
    
    // MARK: - Action
    
    @objc private func dismissVC(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func showDetail() {
        let detailVC = MovieDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
