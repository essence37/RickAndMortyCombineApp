//
//  Episode.swift
//  RickAndMortyCombineApp
//
//  Created by Пазин Даниил on 25.11.2020.
//

import Foundation

public struct Episode: Codable {
    
    public var id: Int64
    public var name: String
    public var episode: String
    public var characters: [String]
    public var url: String
    public var created: String
    
    public init(id: Int64, name: String, episode: String, characters: [String], url: String, created: String) {
        self.id = id
        self.name = name
        self.episode = episode
        self.characters = characters
        self.url = url
        self.created = created
    }
}
