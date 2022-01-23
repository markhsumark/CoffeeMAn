//
//  NewsViewModel.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import Foundation


//範例API: https://newsapi.org/v2/everything?q=網美咖啡廳&sortBy=publishedAt&apiKey=YOUR_API_KEY
class NewsViewModel: ObservableObject{
    let basicUrl = "https://newsapi.org/v2/everything?"
    let searchKey = "q="
    let SortByTimeUrl = "&sortBy=publishedAt"
    let key : APIManager = APIManager.newsApi
    @Published var articles = [Article]()
    @Published var showError : Bool = false

    func fetchNews(keyWords : String){
        let urlKey = "&apiKey=" + key.apiKey
        let urlString = basicUrl + searchKey + keyWords + SortByTimeUrl + urlKey
            
        if let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string : urlStr){
            do {
                let data = try Data(contentsOf: url)
                if let content = String(data: data, encoding: .utf8) {
                    print(content)
                }
            } catch {
                print(error)
            }
            URLSession.shared.dataTask(with: url) { data, urlResponse, error in
                if let data = data{
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode(NewsItem.self, from: data)
                        DispatchQueue.main.async {
                            self.articles = searchResponse.articles

                        }
                    }
                    catch{
                        self.showError = true
                        print(error)
                    }
                }else{
                    self.showError = true
                }
            }.resume()
        }
        print("get cafe news")
    }
}
