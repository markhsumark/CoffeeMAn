//
//  IGItem.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import Foundation

struct IGTagsItem : Codable{
    let data : TagsItem
}
struct TagsItem : Codable, Identifiable{
    let id : UUID
    let name : String
    let media_count : Int
    let following : Int
    let profile_pic_url : String
    let subtitle : String
    
}
