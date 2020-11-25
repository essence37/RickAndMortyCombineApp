//
//  CharacterPage.swift
//  RickAndMortyCombineApp
//
//  Created by Пазин Даниил on 22.11.2020.
//

import Foundation

public struct CharacterPage: Codable {
    
    public var info: PageInfo
    public var results: [Character]
    
    public init(info: PageInfo, results: [Character]) {
        self.info = info
        self.results = results
    }
}
