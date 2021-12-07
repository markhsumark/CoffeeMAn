//
//  CafeItem.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import Foundation

struct CafeItem: Codable{
    let id : String
    let name: String
    let wifi: Float
    let city: String
    let seat: Float?
    let tasty: Float
    let cheap: Float
    let music: Float
    let url: String
    let address: String
    let open_time : String
    let mrt : String
}
