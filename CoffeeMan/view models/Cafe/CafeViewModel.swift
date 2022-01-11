//
//  CafeViewItem.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import Foundation

class CafeViewModel: ObservableObject{
//https://cafenomad.tw/developers/docs/v1.2
//    資料來源


    @Published var cafeItems = [CafeItem]()
    func fetchCafe(term:String){
        let urlString = "https://cafenomad.tw/api/v1.2/cafes/\(term)"
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) {data, response, error in
                if let data = data{
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode([CafeItem].self, from: data)
                        DispatchQueue.main.async {
                            self.cafeItems = searchResponse
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }.resume()
        }
        print("start")
    }
}

enum APIManager {

    case placeApi

    var apiKey: String {
        switch self {
        case .placeApi:
            guard let token = Keys.GooglePlaceAPIKey else {
                               assertionFailure("Please fill the place API Key in Keys.swift")
                               return "api_key_not_found"
                           }
                           return token
        }
    }
}

class PlaceViewModel: ObservableObject{
//https://developers.google.com/maps/documentation/places/web-service/overview
//https://medium.com/彼得潘的試煉-勇者的-100-道-swift-ios-app-謎題/串接-places-api-抓取附近的店家資訊和照片-fa1a0c1bb475
//    資料來源
//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=25.0338,121.5646&radius=1000&keyword=牛排&language=zh-TW&key=123456
    let basicNearUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    var location = "25.0338,121.5646"
    var name = "cafe"
    
    let Key : APIManager = APIManager.placeApi
    
        
    @Published var cafeItems = [CafeItem]()
    func fetchCafe(term:String){
        let urlString = basicNearUrl + "location=" + location + "&radius=1000&keyword=" + name + "&language=zh-TW&key=" + Key.apiKey + "&sensor=true"
        if let url = URL(string: urlString){
            
            URLSession.shared.dataTask(with: url) {data, response, error in
                if let data = data, let content = String(data: data, encoding: .utf8) {
                    print(content)
                }
//                if let data = data{
//                    do{
//
//                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .iso8601
////                        let searchResponse = try decoder.decode([CafeItem].self, from: data)
////                        DispatchQueue.main.async {
////                            self.cafeItems = searchResponse
////                        }
//                    }
//                    catch{
//                        print(error)
//                    }
//                }
            }.resume()
        }
        print("start")
    }
}
