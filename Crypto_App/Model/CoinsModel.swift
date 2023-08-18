//
//  CoinsModel.swift
//  Crypto_App
//
//  Created by Dmitriy Mkrtumyan on 18.08.23.
//

import Foundation

struct CoinsModel: Codable {
    let coins: [Coins]
}

struct Coins: Codable {
    let id: String
    let icon: URL
    let name: String
    let price: Double
    let rank: Int
}

/*
 {
   "coins": [
     {
       "id": "bitcoin",
       "icon": "https://api.coin-stats.com/api/files/812fde17aea65fbb9f1fd8a478547bde/f3738cc5df5f59afb57111d67d951170_1.png",
       "name": "Bitcoin",
       "symbol": "BTC",
       "rank": 1,
       "price": 6362.74960614
     }
   ]
 }
 */
