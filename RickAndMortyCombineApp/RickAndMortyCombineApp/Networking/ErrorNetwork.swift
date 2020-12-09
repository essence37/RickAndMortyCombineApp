//
//  NetworkError.swift
//  RickAndMortyCombineApp
//
//  Created by Пазин Даниил on 22.11.2020.
//

import Foundation

enum ErrorNetwork: LocalizedError {
    case unreachableAddress(url: URL)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .unreachableAddress(let url): return "\(url.absoluteString) is unreachable"
        case .invalidResponse: return "Response with mistake"
        }
    }
}
