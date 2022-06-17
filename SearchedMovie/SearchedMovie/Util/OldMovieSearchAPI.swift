//
//  OldMovieSearchAPI.swift
//  SearchedMovie
//
//  responseJSON: 디플리케이트 예정으로 구버전 style -> responseDecodable 변경 MoviewSearchAPI

import Foundation
import Alamofire

class OldMovieSearchAPI {
    private let parsinngUtil = Constant.parsingConstant
    
    private let baseURLStr = Constant.parsingConstant.searchedMovieURL
    
    private var headers: HTTPHeaders {
        return [parsinngUtil.contentTypeField: parsinngUtil.parsingType,
                parsinngUtil.naverClientIDField: AppBundle.naverAPIID,
                parsinngUtil.naverClientPWField: AppBundle.naverAPIPW]
    }
    
    func request(searchText: String) {
        guard let url = baseURLStr.toURL() else { return }
        guard searchText != String.empty else { return }    // 검색 내용 없음
        let searchText = searchText
        let jsonObject = [parsinngUtil.queryField: searchText]
        
        _ = AF.request(
            url,
            method: .get,
            parameters: jsonObject,
            encoding: URLEncoding.default,
            headers: headers)
        .responseJSON { response in
            guard let data = response.data else { return }
            
            switch response.result {
            case .success(let result):
                guard let body = try? JSONDecoder().decode(MovieResults.self, from: data) else { return }
                
                if let state = result as? NSDictionary,
                   let errorCode = state["errorCode"] as? String {
                    let error = SMError.toAPIError(errorSTR: errorCode)
                    print("APIError: ", error.errorDescription)
                }
                
                print("!!! \n", body, "\n!!!")
                
            case .failure(let error):
                print("Error: (\(error)), \(error.errorDescription ?? String.empty)")
            }
           
        }
        
    }
    
}
