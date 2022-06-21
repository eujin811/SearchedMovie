//
//  RealmsHelper.swift
//  SearchedMovie
//
//

import Foundation

import RealmSwift

struct FavoriteMovieRequestHelper {
    let realm = try! Realm()
    
    let realmFilePath = Realm.Configuration.defaultConfiguration.fileURL
    
    func create(object: Object) {
        print("create", object)
        try! realm.write {
            realm.add(object)
        }
    }
    
    func readMovieList() -> [MovieObject] {
        let savedMovies = try! realm.objects(MovieObject.self)
        
        return Array(savedMovies)
    }
    
    func readMovie(id: String) -> MovieObject? {
        let savedMovies = try! realm.objects(MovieObject.self)
        let searchedMovie = savedMovies.filter(Constant.db.primaryID + Constant.db.equalSymbol + "'\(id)'")
        
        return searchedMovie.first
    }
    
    func readMovie(title: String) -> MovieObject? {
        let savedMovies = try! realm.objects(MovieObject.self)
        let searchedMovie = savedMovies.filter(Constant.db.title + Constant.db.equalSymbol + "'\(title)'")
        
        return searchedMovie.first
    }
    
}
