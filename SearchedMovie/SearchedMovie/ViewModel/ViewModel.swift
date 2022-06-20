//
//  ViewModel.swift
//  SearchedMovie
//
//

import Foundation

protocol ViewModelType {
    /// View -> VM
    associatedtype Input
    /// VM ->View
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
