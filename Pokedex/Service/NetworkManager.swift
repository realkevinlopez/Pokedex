//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Kevin Lopez on 5/7/22.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchPokemonData(nextPokemon: Int, completion: @escaping (Result<PokeAPI, Error>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=30&offset=\(nextPokemon)") else {
            print("error with url")
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            do {
                let pageResult = try JSONDecoder().decode(PokeAPI.self, from: data)
                completion(.success(pageResult))
            } catch {
                completion(.failure(NetworkError.decodeError("\(error)")))
            }
        }.resume()
    }
    
    func fetchAPokemon(urlPath: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        guard let url = URL(string: "\(urlPath)") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            do {
                let pageResult = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pageResult))
            } catch {
                completion(.failure(NetworkError.decodeError("\(error)")))
            }
        }.resume()
    }
    
    func fetchImageData(imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(imagePath)") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
}
