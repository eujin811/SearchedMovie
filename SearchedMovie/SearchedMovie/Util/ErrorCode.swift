//
//  ErrorCode.swift
//  SearchedMovie
//
//

import Foundation
import FileProvider

enum ErrorCode: String {
    case incorrectRequest = "SE01"      // 검색API 요청 오류
    case invalidDisplay = "SE02"        // display 요청 변수값 허용범위 check
    case invalidStart = "SE03"          // start 요청 변수값 허용범위 check
    case invalidSort = "SE04"           // 부적절한 sort 값. (변수값 오타 check)
    case invalidSearchAPI = "SE05"      // 존재하지 않는 API (search api 오타)
    case malformedEncoding = "SE06"     // 잘못된 형식의 인코딩 (UTF-8 X)

    case systemError = "SE99"           // 서버 내부 에러 발생.
    
    var httpCode: Int {
        switch self {
        case .incorrectRequest, .invalidDisplay,
                .invalidStart, .invalidSort,
                .malformedEncoding:
            return 400
        case .invalidSearchAPI:
            return 404
        case .systemError:
            return 500
        }
    }
    
    var errorDescription: String {
        switch self {
        case .incorrectRequest:
            return "검색 API 요청 오류 (SE01)"
        case .invalidDisplay:
            return "display 요청 변수 값 허용범위를 확인해주세요. (SE02)"
        case .invalidStart:
            return "시작 요청 변수 값 허용범위를 확인해주세요. (SE03)"
        case .invalidSort:
            return "부적절한 sort 입니다. (SE04)"
        case .invalidSearchAPI:
            return "존재하지 않는 API입니다. (SE05)"
        case .malformedEncoding:
            return "잘못된 형식의 인코딩 입니다. UTF-8 형식이 맞는지 확인해주세요. (SE06)"
        case .systemError:
            return "naver 서버 문제 (SE99)"
        }
    }
    
}
