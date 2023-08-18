//
//  CoinsViewModel.swift
//  Crypto_App
//
//  Created by Dmitriy Mkrtumyan on 18.08.23.
//

import Foundation

class CoinsViewModel {
    var coins = [Coins]()

    func getRequest(completion: @escaping(Result<[Coins], Error>) -> Void) {
        var components = URLComponents(string: "https://api.coinstats.app/public/v1/coins?")
        guard let baseURL = components?.url else { return }
        
        components?.queryItems = [
            URLQueryItem(name: "skip", value: "0"),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "currency", value: "AMD")
        ]
        
        URLSession.shared.dataTask(with: baseURL) { [weak self] data, _, _ in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let coins = try decoder.decode(CoinsModel.self, from: data)
                    self?.coins = coins.coins
                    completion(.success(coins.coins))
                } catch {
                    let error = error.localizedDescription as! Error
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
