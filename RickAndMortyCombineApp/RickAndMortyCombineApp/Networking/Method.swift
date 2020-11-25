//
//  Method.swift
//  RickAndMortyCombineApp
//
//  Created by Пазин Даниил on 22.11.2020.
//

import Foundation

enum Method {
    static let baseURL = URL(string: "https://rickandmortyapi.com/api/")!
    
    case character(Int?)
    case location
    case episode(Int)
    
    
    var url: URL {
        switch self {
        case .character(let id):
            guard let id = id else {
                return Method.baseURL.appendingPathComponent("character")
            }
            return Method.baseURL.appendingPathComponent("character/\(id)")
        case .episode(let id):
            return Method.baseURL.appendingPathComponent("episode/\(id)")
        default:
            // Homework
            fatalError("URL for this case is undefined.")
        }
    }
}
