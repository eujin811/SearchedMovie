//
//  MovieSearchAPI.swift
//  SearchedMovie
//

import Foundation
import Alamofire
import RxSwift

class MovieSearchAPI {
    private let parseConstant = Constant.parsingConstant
    
    private let baseURLStr = Constant.parsingConstant.searchedMovieURL
    
    private var headers: HTTPHeaders {
        return [parseConstant.contentTypeField: parseConstant.parsingType,
                parseConstant.naverClientIDField: AppBundle.naverAPIID,
                parseConstant.naverClientPWField: AppBundle.naverAPIPW]
    }
  
    func request(type: SearchType) -> Single<[Movie]> {
        let headers = self.headers
        let baseURL = baseURLStr.toURL()
        
        return Single<[Movie]>.create { obsever -> Disposable in
            guard let url = baseURL
            else {
                obsever(.failure(SMError.emptyData))
                return Disposables.create()
            }
            
            let jsonObject = type.jsonObject
            
            AF.request(
                url,
                method: .get,
                parameters: jsonObject,
                encoding: URLEncoding.default,
                headers: headers)
            .responseDecodable(of: MovieResults.self) { response in
                switch response.result {
                case .success(let result):
                    print("result", result)
                    obsever(.success(result.items))
                case .failure(let error):
                    print("Error: (\(error)), \(error.localizedDescription)")
                    obsever(.failure(error))
                }
            }
            
            return Disposables.create()
        }
        
    }

     /// - MovieSearchAPI().request(type: .movies("여름"))
     /// - MovieSearchAPI().request(type: .addMovies("바다", 15))
    enum SearchType {
        static let displayCount = 10
        
        case movies(String)     // 기본 10개 display
        /// searchText, startPosition
        /// startPosition의 경우 1부터 시작.
        case addMovies(String, Int)
        
        var jsonObject: [String : Any] {
            let parseConstant = Constant.parsingConstant

            switch self {
            case .movies(let searchText):
                return [parseConstant.queryField: searchText]
            case let .addMovies(searchText, startPosition):
                return [parseConstant.queryField: searchText,
                        parseConstant.searchDisplayField: SearchType.displayCount,
                        parseConstant.searchPositionField: startPosition]
            }
        }
    }
    
}
