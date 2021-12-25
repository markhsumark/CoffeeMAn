//
//  CafeIgViewModel.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import Foundation

class IGViewModel : ObservableObject{
    @Published var igAccountItems = IGAccountItem.self
    
    func fetchIGAccount(term:String){
        let urlString = "https://www.instagram.com/\(term)/?__a=1"
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) {data, response, error in
                if let data = data{
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode(IGAccountItem.self, from: data)
//                        DispatchQueue.main.async {
//                            self.igAccountItems = searchResponse
//                        }
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
