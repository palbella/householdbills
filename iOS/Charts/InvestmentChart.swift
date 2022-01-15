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

struct InvestmentChart: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    

    @State var items : [ChartModel]
    @Binding var modal: Bool
    @State var save: Bool = false

    
    var body: some View {
        GeometryReader { p in
            VStack(spacing: 0) {
                
                HeaderTabView(title: "Total Positions", modal: $modal, save: $save)
                HeaderTabTitleView(title: "Total Positions")
                
                Section(header:
                            VStack(spacing: 20) {
                
                    Text("POSITIONS")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                    
                              
                            
                }
                            
                          
                            
                ) {
              
                 Text("")
                    InvestmentPieChartSwiftUI(items: $items.wrappedValue, currencyTo: self.settings.currency)
                                    .frame(height: 400)
                    

                }
             
            }
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
           
        }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
    }
}


struct ChartModel {

     var id: Int32
     var name: String
    var amount: Double
    var currency: String

    init() {
        self.id = 0
        self.name = ""
        self.amount = 0
        self.currency = ""
    }
}



struct InvestmentPieChartSwiftUI: UIViewRepresentable {
    
    
    var items : [ChartModel]
    var currencyTo: String
    
    var entries: [PieChartDataEntry] = []
   
//    @Binding var category: Wine.Category
    let pieChart = PieChartView()
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        return pieChart
    }
    
    init(items: [ChartModel], currencyTo: String) {
        
        let fetchCurrencies = CurrencyData()
        let currencies = GetCurrencies()
        currencies.items = fetchCurrencies.fetch()
        
        
        self.items = items
        self.currencyTo = currencyTo
        entries = []
        
        var cats : [CategoryChartModel] = []
        
        for cat in items {
            var catChart = CategoryChartModel()
            catChart.name = cat.name
            catChart.id = cat.id
            catChart.amount = currencies.convert(currencyFrom: cat.currency, currencyTo: self.currencyTo, value: cat.amount)
            
            if(catChart.amount != 0) {
                catChart.amount = abs(catChart.amount)
                cats.append(catChart)
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
        var parent: InvestmentPieChartSwiftUI
        init(parent: InvestmentPieChartSwiftUI) {
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
        pieChart.centerText = "Positions" //category.rawValue.capitalized
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

