//
//  CoffeeManWidget.swift
//  CoffeeManWidget
//
//  Created by 徐易中 on 2022/1/16.
//

import WidgetKit
import SwiftUI

struct coffeeType{
    static let imgName : [String] = [  "americano",
                                       "cappuccino",
                                       "caramelMacciato",
                                       "conPanna",
                                       "espresso",
                                       "irish",
                                       "latte",
                                       "Mocha",
                                       "viennese"
    ]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imgName: "latte")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), imgName: "latte")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for offset in 0 ..< 9 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: 10 * offset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, imgName: coffeeType.imgName.randomElement()!)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imgName: String
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
        CoffeeManWidgetEntryView(entry: SimpleEntry(date: Date(), imgName: coffeeType.imgName[0]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


struct smallWidget : View{
    var entry : Provider.Entry
    var body: some View{
        ZStack{
            Image(entry.imgName)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .topLeading, content: {
                    VStack{
                        Text("Coffee Man")
                            .foregroundColor(Color.ui.orange)
                            .font(.system(.body,design: .monospaced))
                            .padding(.leading, 10)
                        Text("咖啡人")
                            .font(.system(size:10))
                        
                    }
                })
        }
    }
}
struct mediumWidget:View{
    var entry : Provider.Entry
    var body: some View{
        HStack{
            smallWidget(entry: entry)
            Divider()
            Text("woooooooooord")
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
