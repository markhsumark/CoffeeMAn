//
//  CafeNewsView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import SwiftUI

struct CafeNewsView: View {
    @State private var showInfo = false
    @State private var selectArticle : Article = Article(source: Source(id: 1, name: "xxx"), author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: Date(), content: "")
    @ObservedObject var news = NewsViewModel()
    
    var body: some View {
        VStack{
            List{
                ForEach(news.articles, id: \.url) { article in
                    Section{
                        Button{
                            showInfo = true
                            selectArticle = article
                        }label:{
                            ArticleBlock(article: article)
                                
                        }
                    }header:{
                        Text(article.source.name)
                    }
                    .sheet(isPresented: $showInfo){
                        ArticleInfo(article: $selectArticle, showInfo : $showInfo)
                    }
                }
                
            }
            .listStyle(.plain)
        }
        .onAppear{
            if news.articles.isEmpty{
                news.fetchNews(keyWords: "台灣咖啡廳")
            }
        }
        .overlay{
            if news.articles.isEmpty{
                ProgressView()
            }
        }
        .refreshable {
            news.fetchNews(keyWords: "台灣咖啡廳")
        }
        .alert("沒有網路連線", isPresented: $news.showError) {
            Button("OK"){
                news.showError = false
            }
        }
    }
}

struct ArticleBlock : View{
    var article : Article
    var body : some View{
        VStack(alignment: .leading){
            ArticleImage(imageUrl: article.urlToImage)
            Text("標題:\(article.title)")
                .foregroundColor(Color.ui.newstitletext)
                .font(.title2)
                .bold()
            Text("作者:\(article.author)")
                .foregroundColor(Color.ui.newstext)
        }
        .frame(maxWidth: .infinity-50)
        .padding()
        .background(Color.ui.news.opacity(0.75))
        .cornerRadius(7)
    }
}

struct ArticleInfo : View{
    @Binding var article : Article
    @Binding var showInfo : Bool
    
    var body : some View{
        NavigationView {
            VStack(alignment: .leading){
                ArticleImage(imageUrl: article.urlToImage)
                Text("\(article.title)")
                    .foregroundColor(Color.ui.newstitletext)
                    .font(.title3)
                    .bold()
                    .padding()
                Text("\(article.publishedAt)")
                    .foregroundColor(.gray)

                Text("內容: \(article.description)")
                Link(destination: URL(string: article.url)!){
                    Rectangle()
                        .frame(width: 150, height: 40)
                        .overlay{
                            Label("新聞原始網站", systemImage: "link")
                                .foregroundColor(.white)
                        }
                        .cornerRadius(15)
                        .foregroundColor(Color.ui.orange)
                        .padding()
                }
            }
            .padding()
            .navigationBarTitle(Text("新聞資訊"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showInfo = false
            }) {
                Text("Done").bold()
            })
            
        }
    }
}
struct ArticleImage: View{
    var imageUrl : String?
    var body: some View{
        if let imageUrl = imageUrl{
            AsyncImage(url: URL(string: imageUrl)){phase in
                if let image = phase.image{
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: .infinity/2)
                }else if phase.error != nil{
                    Text("No Image")
                        .opacity(0.5)
                }else{
                    ProgressView()
                }
            }
            .scaledToFit()
            .cornerRadius(7)
        }
        else{
            Text("No Image")
                .opacity(0.5)
        }
    }
}
//
//struct CafeNewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CafeNewsView()
//    }
//}
