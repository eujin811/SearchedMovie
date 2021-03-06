//
//  BasicViewController.swift
//  SearchedMovie
//
//

import UIKit
import RxSwift

class BasicViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setConstraints()
        
        bind()
        subscribe()
    }
    
    func setUI() {
        
    }
    
    func setConstraints() {
        
    }
    
    func bind() {
        
    }
    
    func subscribe() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

}
