//
//  CoffeeManWidget.swift
//  CoffeeManWidget
//
//  Created by 徐易中 on 2022/1/16.
//

import WidgetKit
import SwiftUI
import Foundation

struct coffeeType{
    static let imgName : [String] = [  "Americano",
                                       "Cappuccino",
                                       "Mocha",
                                       "conPanna",
                                       "Espresso",
                                       "Irish",
                                       "Latte",
                                       "Macchiato",
                                       "Guayoyo"
    ]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imgName: "Latte", coffee: coffee(title: "Latte", description: "description", ingredients: ["ingredients1", "ingredients2"]))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), imgName: "Latte", coffee: coffee(title: "Latte", description: "description", ingredients: ["ingredients1", "ingredients2"]))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        var coffees : [coffee]?
        URLSession.shared.dataTask(with: URL(string: "https://api.sampleapis.com/coffee/hot")!){data, response, error in
            if let data = data{
                do{
                    print(data)
                    let decorder = JSONDecoder()
                    decorder.dateDecodingStrategy = .iso8601
                    let result = try decorder.decode([coffee].self, from: data)
                    coffees = result
                }catch{
                    print(error)
                }
            }
            
            //            let entryDate = Calendar.current.date(byAdding: .minute, value: 10 * offset, to: currentDate)!
            var coffee = coffees?.randomElement()!
            while coffee?.title == ""{
                coffee = coffees?.randomElement()!
            }
            let entry = SimpleEntry(date: currentDate, imgName: coffee!.title, coffee: coffee!)
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }.resume()
        
        
    }
}
struct coffee: Codable{
    let title : String
    let description : String
    let ingredients : [String]
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let imgName: String
    let coffee: coffee
}

struct CoffeeManWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    var formatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            smallWidget(entry: entry)
        case .systemMedium:
            mediumWidget(entry: entry)
        default:
            Text("")
        }
        
        
        
    }
}

@main
struct CoffeeManWidget: Widget {
    let kind: String = "CoffeeManWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CoffeeManWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Coffee Man Widget")
        .description("This is an Coffee Man's!!!!! widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct CoffeeManWidget_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeManWidgetEntryView(entry: SimpleEntry(date: Date(), imgName: coffeeType.imgName[0], coffee: coffee(title: "coffee", description: "description", ingredients: ["ingredients"])))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


struct smallWidget : View{
    var entry : Provider.Entry
    var body: some View{
        ZStack{
            if #available(iOSApplicationExtension 15.0, *) {
                Image(entry.imgName)
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .topLeading, content: {
                        VStack{
                            Text("Coffee Man")
                                .foregroundColor(Color.ui.orange)
                                .font(.system(size: 10,design: .monospaced))
                                .padding(.leading, 10)
                            Text("咖啡人")
                                .font(.system(size:7))
                            
                        }
                    })
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
struct mediumWidget:View{
    var entry : Provider.Entry
    var body: some View{
        HStack{
            smallWidget(entry: entry)
            Divider()
            VStack(alignment: .leading, spacing: 2){
                Text("\(entry.coffee.title)")
                    .font(.system(size: 20))
                    .foregroundColor(Color.ui.orange)
                    .bold()
                Divider()
                Text("ingredients:")
                    .font(.system(size: 15))
                ForEach(entry.coffee.ingredients.indices){i in
                    Text("\(entry.coffee.ingredients[i])")
                        .font(.system(size: 10))
                }
            }
        }
    }
}


extension Color {
    static let ui = Color.UI()
    
    struct UI {
        let orange = Color("orange")
        //        let titletext = Color("titletext")
        //        let text = Color("text")
        //        let news = Color("news")
        //        let newstext = Color("newtext")
        //        let newstitletext = Color("newtitletext")
        //        let map = Color("map")
    }
}
