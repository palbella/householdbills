//
//  BalanceChart.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/26/21.
//

import SwiftUI
import Charts
import Foundation
import CoreData

struct TransactionChart: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    

    @Binding var items : [TransactionModel]
    @Binding var categories : [CategoryModel]
    @Binding var modal: Bool
    @State var save: Bool = false

    
    var body: some View {
        GeometryReader { p in
            VStack(spacing: 0) {
                
                HeaderTabView(title: "Month Expenses", modal: $modal, save: $save)
                HeaderTabTitleView(title: "Month Expenses")
                
                Section(header:
                            VStack(spacing: 20) {
                
                    Text("CATEGORIES")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                    
                              
                            
                }
                            
                          
                            
                ) {
              
                 Text("")
                    PieChartSwiftUI(categories: $categories.wrappedValue, items: $items.wrappedValue, currencyTo: self.settings.currency)
                                    .frame(height: 400)
                    
//                                Picker(selection: $category, label: Text("Category")) {
//                                    Text("Variety").tag(Wine.Category.variety)
//                                    Text("Winery").tag(Wine.Category.winery)
//                                }
//                                .pickerStyle(SegmentedPickerStyle())

                }
             
            }
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
           
        }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
    }
}


struct CategoryChartModel {

     var id: Int32
     var name: String
    var amount: Double

    init() {
        self.id = 0
        self.name = ""
        self.amount = 0
    }
}

struct PieChartSwiftUI: UIViewRepresentable {
    
    var categories : [CategoryModel]
    var items : [TransactionModel]
    var currencyTo: String
    
    var entries: [PieChartDataEntry] = []
   
//    @Binding var category: Wine.Category
    let pieChart = PieChartView()
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        return pieChart
    }
    
    init(categories: [CategoryModel], items: [TransactionModel], currencyTo: String) {
        
        let fetchCurrencies = CurrencyData()
        let currencies = GetCurrencies()
        currencies.items = fetchCurrencies.fetch()
        
        
        self.items = items
        self.categories = categories
        self.currencyTo = currencyTo
        entries = []
        
        var cats : [CategoryChartModel] = []
        
        for cat in categories {
            var catChart = CategoryChartModel()
            catChart.name = cat.name
            catChart.id = cat.id
            for item in items {
                if(item.category == cat.id) {
                    if(item.amount < 0) {
                        catChart.amount = catChart.amount + currencies.convert(currencyFrom: item.currency, currencyTo: self.currencyTo, value: item.amount)
                    }
                }
            }
            if(catChart.amount != 0) {
                catChart.amount = abs(catChart.amount)
                if(catChart.id != 99) {
                cats.append(catChart)
                }
            }
        }
        
        for c in cats {
            entries.append(PieChartDataEntry.init(value: c.amount, label: c.name))
        }
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = ChartColorTemplates.colorful()
        let pieChartData = PieChartData(dataSet: dataSet)
        uiView.data = pieChartData
        configureChart(uiView)
        formatCenter(uiView)
        formatDescription(uiView.chartDescription)
        formatLegend(uiView.legend)
        formatDataSet(dataSet)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: PieChartSwiftUI
        init(parent: PieChartSwiftUI) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let labelText = entry.value(forKey: "label")! as! String
            let num = Int(entry.value(forKey: "value")! as! Double)
            parent.pieChart.centerText = """
                \(labelText)
                \(num)
                """
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func configureChart( _ pieChart: PieChartView) {
        pieChart.rotationEnabled = false
        pieChart.animate(xAxisDuration: 0.5, easingOption: .easeInOutCirc)
        pieChart.drawEntryLabelsEnabled = false
        pieChart.highlightValue(x: -1, dataSetIndex: 0, callDelegate: false)
    }
    
    func formatCenter(_ pieChart: PieChartView) {
        pieChart.holeColor = UIColor.systemBackground
        pieChart.centerText = "Expenses" //category.rawValue.capitalized
        pieChart.centerTextRadiusPercent = 0.95
    }
    
    func formatDescription( _ description: Description) {
//        description.text = category.rawValue.capitalized
        description.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func formatLegend(_ legend: Legend) {
        legend.enabled = false
    }
    
    func formatDataSet(_ dataSet: ChartDataSet) {
        dataSet.drawValuesEnabled = false
    }
}

//
//struct PieChartValues {
//    enum Category: String {
//        case variety, winery
//    }
//    var category: Category
//    var value:Double
//    var label:String
//
//    static func entriesForWines(_ wines: [PieChartValues]) -> [PieChartDataEntry] {
//        let requestedWines = wines.filter {$0.category == category}
//        return requestedWines.map { PieChartDataEntry(value: $0.value, label: $0.label)}
//    }
//    static var allWines:[PieChartValues] {
//        [
//            PieChartValues(category: .variety, value: 6, label: "Chardonnay"),
//            PieChartValues(category: .variety, value: 2, label: "Merlot"),
//            PieChartValues(category: .variety, value: 5, label: "Pinot Gris"),
//            PieChartValues(category: .variety, value: 7, label: "Gewürtztraminer"),
//            PieChartValues(category: .variety, value: 12, label: "Red Blend"),
//            PieChartValues(category: .variety, value: 10, label: "White Blend"),
//            PieChartValues(category: .variety, value: 3, label: "Sauvingnon Blanc"),
//            PieChartValues(category: .variety, value: 6, label: "Cabernet Franc"),
//
//        ]
//    }
//}
