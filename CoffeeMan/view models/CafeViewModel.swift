//
//  CafeViewItem.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import Foundation

class CafeViewModel: ObservableObject{
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
