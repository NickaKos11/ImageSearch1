//
//  SessionError.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 07.01.2021.
//

import Foundation

enum SessionError: Error {
    case invalidUrl, decodingError(Error), serverError(_ statusCode: Int), other(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Некорректный URL-адрес"
        case let .decodingError(error):
            return error.localizedDescription
        case let .serverError(statusCode):
            return "Не удалось связаться с сервером (\(statusCode))"
        case let .other(error):
            return error.localizedDescription
        }
    }
    
}
