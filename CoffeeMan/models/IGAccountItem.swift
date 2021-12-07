//
//  IGAccountItem.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import Foundation

struct IGAccountItem: Codable{
    let seo_category_infos : Array<Array<String>>
    let graphql: Graphql
    let logging_page_id : String
}
struct Graphql : Codable{
    let user : User
}
struct User : Codable{
    let id : String
    let biography : String
    let full_name : String
    let username : String
    let edge_followed_by : Count
    let edge_follow : Count
    let highlight_reel_count : Int
    let profile_pic_url : String
    let profile_pic_url_hd : String
    let edge_owner_to_timeline_media : Post
}
struct Post : Codable{
    let count : Int
    let page_info : PageInfo
//    let edges :[Edge]
    
}
struct PageInfo : Codable{
    let has_next_page : Bool
    let end_cursor : String
}
struct Edge : Codable{
    let node : String
}
struct Count : Codable{
    let count : Int
}
