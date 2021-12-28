//
//  NewsItem.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import Foundation

struct NewsItem : Codable{
    let totalResults : Int
    let articles : [Article]
}

struct Article : Codable{
    let source : Source
    let author : String
    let title : String
    let description : String
    let url : String
    let urlToImage : String?
    let publishedAt : String
    let content : String
    
}

struct Source : Codable{
    let id : Int?
    let name : String
}
