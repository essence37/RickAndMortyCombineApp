//
//  APIClient.swift
//  RickAndMortyCombineApp
//
//  Created by Пазин Даниил on 22.11.2020.
//

import Foundation
import Combine

struct APIClient {
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "APIClient", qos: .default, attributes: .concurrent)
    
    func getTotalCharactersNumber() -> AnyPublisher<CharacterPage, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.character(nil).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: CharacterPage.self, decoder: decoder)
            .mapError({ error -> Error in
                switch error {
                case is URLError:
                    return Error.unreachableAddress(url: Method.character(nil).url)
                default:
                    return Error.invalidResponse }
            })
            .eraseToAnyPublisher()
        
    }
    
    func character(id: Int) -> AnyPublisher<Character, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.character(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Character.self, decoder: decoder)
            //            .catch { _ in Empty<Character, Error>() }
            .mapError({ error -> Error in
                switch error {
                case is URLError:
                    return Error.unreachableAddress(url: Method.character(id).url)
                default:
                    return Error.invalidResponse }
            })
            .eraseToAnyPublisher()
    }
    
    func mergedCharacters(ids: [Int]) -> AnyPublisher<Character, Error> {
        precondition(!ids.isEmpty)
        
        let initialPublisher = character(id: ids[0])
        let remainder = Array(ids.dropFirst())
        
        return remainder.reduce(initialPublisher) { (combined, id) in
            return combined
                .merge(with: character(id: id))
                .eraseToAnyPublisher()
        }
    }
    
    func episode(id: Int) -> AnyPublisher<Episode, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.episode(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Episode.self, decoder: decoder)
            .mapError({ error -> Error in
                switch error {
                case is URLError:
                    return Error.unreachableAddress(url: Method.episode(id).url)
                default:
                    return Error.invalidResponse }
            })
            .eraseToAnyPublisher()
    }
    
    func mergedEpisodes(ids: [Int]) -> AnyPublisher<Episode, Error> {
        precondition(!ids.isEmpty)
        
        let initialPublisher = episode(id: ids[0])
        let remainder = Array(ids.dropFirst())
        
        return remainder.reduce(initialPublisher) { (combined, id) in
            return combined
                .merge(with: episode(id: id))
                .eraseToAnyPublisher()
        }
    }
    
}
