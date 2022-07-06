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
    
    func createMovie(_ movie: Movie) {
        guard readMovieObject(link: movie.link) == nil else { return }
        
        let object = MovieObject()
        object.configure(movie: movie)
        print("create", object)

        try! realm.write {
            realm.add(object)
        }
    }
    
    func readMovieList() -> [MovieObject] {
        let savedMovies = try! realm.objects(MovieObject.self)
        
        return Array(savedMovies)
    }
    
    func readMovie(id: Int) -> Movie? {
        let savedMovies = try! realm.objects(MovieObject.self)
        let searchedMovie = savedMovies.filter(Constant.db.primaryID + Constant.db.equalSymbol + "'\(id)'")
        let object = searchedMovie.first
        
        return object?.makeModel()
    }
    
    func readMovie(link: String) -> Movie? {
        guard let object = readMovieObject(link: link) else { return nil }
        print("readMovie", object)
        
        return object.makeModel()
    }
    
    func deleteMovie(id: String) {
        let savedMovies = try! realm.objects(MovieObject.self)
        let object = savedMovies
            .filter { $0.id == id }
            .first
        guard let delteObject = object else { return }
        
        print("delete: ", object._rlmObjcValue)
        try! realm.write {
            realm.delete(delteObject)
        }
    }
    
    func deleteMovie(movie: Movie) {
        guard let object = readMovieObject(link: movie.link) else { return }
        print("delete: ", object)
        
        try! realm.write {
            realm.delete(object)
        }
    }
    
    private func readMovieObject(link: String?) -> MovieObject? {
        guard let link = link else { return nil }
        let savedMovies = try! realm.objects(MovieObject.self)
        let searchedMovie = savedMovies.filter(Constant.db.link + Constant.db.equalSymbol + "'\(link)'")
        let owneObject = searchedMovie.first
        
        return owneObject
    }
    
}
