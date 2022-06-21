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
    
    func createMovie(_ model: Movie) {
        let object = MovieObject()
        object.configure(movie: model)
        
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
    
    func readMovie(title: String) -> Movie? {
        let savedMovies = try! realm.objects(MovieObject.self)
        let searchedMovie = savedMovies.filter(Constant.db.title + Constant.db.equalSymbol + "'\(title)'")
        guard let object = searchedMovie.first else { return nil }
        print("redMovie", object)
        
        return object.makeModel()
    }
    
    func deleteMovie(id: String) {
        let savedMovies = try! realm.objects(MovieObject.self)
        let object = savedMovies
            .filter { $0.id == id }
            .first
        
        print("delete: ", object)
        guard let delteObject = object else { return }
        
        try! realm.write {
            realm.delete(delteObject)
        }
    }
    
    func deleteMovie(movie: Movie) {
        guard let title = movie.title else { return }
        let savedMovies = try! realm.objects(MovieObject.self)
        let searchedMovie = savedMovies.filter(Constant.db.title + Constant.db.equalSymbol + "'\(title)'")

        guard let object = searchedMovie.first else { return }
        
        try! realm.write {
            realm.delete(object)
        }
    }
}
