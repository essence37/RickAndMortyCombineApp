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
    let errorCharacter = Character(id: 0, name: "Ошибка загрузки данных", status: "", species: "Пожалуйста, попробуйте позже🤷🏻‍♂️", type: "", gender: "", image: "")
    
    func getTotalCharactersNumber() -> AnyPublisher<CharacterPage, Never> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.character(nil).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: CharacterPage.self, decoder: decoder)
            .replaceError(with: CharacterPage(info: PageInfo(count: 1, pages: 1, prev: nil, next: nil), results: [errorCharacter]))
//            .mapError({ error -> ErrorNetwork in
//                switch error {
//                case is URLError:
//                    return ErrorNetwork.unreachableAddress(url: Method.character(nil).url)
//                default:
//                    return ErrorNetwork.invalidResponse }
//            })
            .eraseToAnyPublisher()
        
    }
    
    func character(id: Int) -> AnyPublisher<Character, Never> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.character(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Character.self, decoder: decoder)
            .replaceError(with: errorCharacter)
            //            .catch { _ in Empty<Character, Error>() }
//            .mapError({ error -> ErrorNetwork in
//                switch error {
//                case is URLError:
//                    return ErrorNetwork.unreachableAddress(url: Method.character(id).url)
//                default:
//                    return ErrorNetwork.invalidResponse }
//            })
            .eraseToAnyPublisher()
    }
    
    func mergedCharacters(ids: [Int]) -> AnyPublisher<Character, Never> {
        precondition(!ids.isEmpty)
        
        let initialPublisher = character(id: ids[0])
        let remainder = Array(ids.dropFirst())
        
        return remainder.reduce(initialPublisher) { (combined, id) in
            return combined
                .merge(with: character(id: id))
                .eraseToAnyPublisher()
        }
    }
    
    func episode(id: Int) -> AnyPublisher<Episode, ErrorNetwork> {
        return URLSession.shared
            .dataTaskPublisher(for: Method.episode(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Episode.self, decoder: decoder)
            .mapError({ error -> ErrorNetwork in
                switch error {
                case is URLError:
                    return ErrorNetwork.unreachableAddress(url: Method.episode(id).url)
                default:
                    return ErrorNetwork.invalidResponse }
            })
            .eraseToAnyPublisher()
    }
    
    func mergedEpisodes(ids: [Int]) -> AnyPublisher<Episode, ErrorNetwork> {
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
