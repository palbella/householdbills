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

struct BalanceChart: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    @State var showYear: Bool = true
    @State var refresh: Bool = false
    
    var body: some View {
        GeometryReader { p in
            VStack(spacing: 0) {
                
                Section(header:
                            VStack(spacing: 0) {
                
                                Text("ANUAL BALANCE")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                    
                                    Divider()
                              
                            
                }
                            
                          
                            
                ) {
                    HStack(spacing: 0) {
                    Text("")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 8)
                    .background(colorScheme != .dark ? ui.lightDashboardHeadColor: ui.darkItemBackgroundColor)
                  
                    if(!refresh) {
                LineChartSwiftUI(viewContext: viewContext, showYear: $showYear)
                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                        .onDisappear(){
                            refresh = false
                        }
                    }
                        
                    
                    
                 
                    //use frame to change the graph size within your SwiftUI view
//                    .frame(width: p.size.width, height: p.size.height/5, alignment: .center)
                }
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button(action: {
                        self.showYear = false
                        self.refresh = true
                    }) {
                            Text("1M")
                                .frame(minWidth: 60)
                                .font(.system(size: 12))
                                .background(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .padding(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor, lineWidth: 1 )
                                )
                    }
                    .padding()
                    Spacer()
                    Button(action: {
                        self.showYear = true
                        self.refresh = true
                    }) {
                            Text("1Y")
                                .frame(minWidth: 60)
                                .font(.system(size: 12))
                                .background(colorScheme != .dark ? ui.darkCommandFontColor: ui.darkCommandFontColor)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .padding(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(colorScheme != .dark ? ui.darkCommandFontColor: ui.darkCommandFontColor, lineWidth: 1 )
                                )
                    }
                    .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(colorScheme != .dark ? Color.white: ui.darkItemBackgroundColor)
                .padding(.bottom, 20)
                Spacer()
            }
        }
    }
}

struct LineChartSwiftUI: UIViewRepresentable {

    let lineChart = LineChartView()
    @State var viewContext: NSManagedObjectContext
    @Binding var showYear: Bool

    func makeUIView(context: UIViewRepresentableContext<LineChartSwiftUI>) -> LineChartView {
        setUpChart()
            
        return lineChart
    }

    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<LineChartSwiftUI>) {
        setUpChart()
    }

    
  
    
    func setUpChart() {
        
       

        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentDay: String = String(Date().get(.day))
        let currentMonth: String = String(Date().get(.month))
        let currentYear: Int = Int(Date().get(.year))
        var previousYear: String = String(currentYear - 1)
        var previousMonth: Int = Date().get(.month) - 1
        var startDate:NSDate = dateFormatter.date(from: previousYear + "-" + currentMonth + "-" + currentDay)! as NSDate
       
        if(!showYear) {
            previousYear = String(currentYear)
            if(previousMonth == 0) {
                previousMonth = 12
                previousYear = String(currentYear - 1)
            startDate = dateFormatter.date(from: previousYear + "-" + String(previousMonth) + "-" + currentDay)! as NSDate
            }
        }

        
        do {
        let request: NSFetchRequest<DailyBalance> = DailyBalance.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "%@ <= date", argumentArray: [startDate])
        let records = try viewContext.fetch(request)
        
//        var objects = [Obj(), Obj()]
        // (objects is defined as an array of struct with date and value)

        // Define the reference time interval
        var referenceTimeInterval: TimeInterval = 0
            if let minTimeInterval = (records.map { $0.date!.timeIntervalSince1970 }).min() {
                referenceTimeInterval = minTimeInterval
            }


            // Define chart xValues formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.locale = Locale.current

            let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)



            // Define chart entries
//            var entries = [ChartDataEntry]()
            var values: [Double] = []
            var sessions: [Double] = []
            var datas: [String] = []
//            var sessions: [Int] = []
//            var sessionValue = 0
            for object in records {
                let timeInterval = object.date!.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 12)

                let yValue = object.balance
                sessions.append(xValue)
                values.append(yValue)
                let formatter1 = DateFormatter()
                formatter1.dateStyle = .short
             
                datas.append(formatter1.string(from: object.date!) + ": " + String(yValue))
            }
        
        
        lineChart.noDataText = "No Data Available"
            let dataSets = [getLineChartDataSet(records: values, sessions: sessions, datas: datas)]
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChart.data = data
        
//        lineChart.backgroundColor = .white
//        lineChart.gridBackgroundColor = .white
//        lineChart.drawGridBackgroundEnabled = false
                
        lineChart.drawBordersEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.chartDescription.enabled = false
//        lineChart.xAxis.drawAxisLineEnabled = false
//        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.pinchZoomEnabled = false
        
        lineChart.dragEnabled = false
        lineChart.setScaleEnabled(false)
                
        lineChart.legend.enabled = false
                
        lineChart.xAxis.enabled = true
        lineChart.xAxis.labelPosition = .bottom
        
        lineChart.rightYAxisRenderer.axis.enabled = false
            lineChart.leftYAxisRenderer.axis.enabled = false
            
            lineChart.highlightPerDragEnabled = true
            lineChart.highlightPerTapEnabled = true
            
//            lineChart.highlightValue(x: 2.0, dataSetIndex: 0)
//            lineChart.maxHighlightDistance = 0.1
         
//            lineChart.delegate = lineChart
        
        let xAxis = lineChart.xAxis
         xAxis.labelPosition = .bottom
        xAxis.labelCount = datas.count
         xAxis.drawLabelsEnabled = true
         xAxis.drawLimitLinesBehindDataEnabled = false
         xAxis.avoidFirstLastClippingEnabled = true

         // Set the x values date formatter
//         let xValuesNumberFormatter = ChartXAxisFormatter()
//        xValuesNumberFormatter.dateFormatter = dayNumberAndShortNameFormatter // e.g. "wed 26"
        xAxis.valueFormatter = xValuesNumberFormatter
            
//            let marker = ChartMarker()
//            marker.chartView = lineChart
//
//            lineChart.marker = marker
            
            let marker = PillMarker(color: .white, font: UIFont.boldSystemFont(ofSize: 14), textColor: .black)
            lineChart.marker = marker
            
//            var highlight : [Highlight] = []
//            var x = Highlight(x: 2, y: 2, dataSetIndex: 0)
//            highlight.append(x)
//            lineChart.highlightValues(highlight);
        
        } catch {
            
        }
    }
    
  

    func getChartDataPoints(sessions: [Double], accuracy: [Double], datas: [String]) -> [ChartDataEntry] {
        var dataPoints: [ChartDataEntry] = []
        for count in (0..<sessions.count) {
            dataPoints.append(ChartDataEntry.init(x: Double(sessions[count]), y: accuracy[count], data: datas[count]))
        }
        return dataPoints
    }

    func getLineChartDataSet(records: [Double], sessions: [Double], datas: [String]) -> LineChartDataSet {
        let dataPoints = getChartDataPoints(sessions: sessions, accuracy: records, datas: datas)
        let set = LineChartDataSet(entries: dataPoints, label: "DataSet")
        set.lineWidth = 2.5
        set.circleRadius = 4
        set.circleHoleRadius = 2

        let color = UIColor(red: 2,green: 179,blue: 0)
        set.setColor(color)
        set.setCircleColor(color)
//
//        set.axisDependency = .left
//                set.drawCirclesEnabled = false
//                set.lineWidth = 2
//                set.circleRadius = 3
//                set.fillAlpha = 1
//                set.drawFilledEnabled = false
//                set.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1) //line
////                set.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
//                set.drawCircleHoleEnabled = false
//                set.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
//                    return CGFloat(self.lineChart.leftAxis.axisMinimum)
//                }



//        set.colors = [NSUIColor.red]
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = true
        set.mode = .cubicBezier // add this line
      
      
        return set
    }
    
 
}


class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?

    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}


extension ChartXAxisFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }

        let date = Date(timeIntervalSince1970: value * 3600 * 12 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }

}





class ChartMarker: MarkerView {
    var text = ""

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        text = entry.data != nil ? entry.data as! String: "" //String(entry.x) + " - " + String(entry.y)
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        var drawAttributes = [NSAttributedString.Key : Any]()
        drawAttributes[.font] = UIFont.systemFont(ofSize: 15)
        drawAttributes[.foregroundColor] = UIColor.white
        drawAttributes[.backgroundColor] = UIColor.darkGray

        self.bounds.size = (" \(text) " as NSString).size(withAttributes: drawAttributes)
        self.offset = CGPoint(x: 0, y: -self.bounds.size.height - 2)

        let offset = self.offsetForDrawing(atPoint: point)

        drawText(text: " \(text) " as NSString, rect: CGRect(origin: CGPoint(x: point.x + offset.x, y: point.y + offset.y), size: self.bounds.size), withAttributes: drawAttributes)
    }

    func drawText(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x + (rect.size.width - size.width) / 2.0, y: rect.origin.y + (rect.size.height - size.height) / 2.0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    }
}


class PillMarker: MarkerImage {

    private (set) var color: UIColor
    private (set) var font: UIFont
    private (set) var textColor: UIColor
    private var labelText: String = ""
    private var attrs: [NSAttributedString.Key: AnyObject]!
    

    static let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.unitsStyle = .short
        return f
    }()

    init(color: UIColor, font: UIFont, textColor: UIColor) {
        self.color = color
        self.font = font
        self.textColor = textColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrs = [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor, .baselineOffset: NSNumber(value: -4)]
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        // custom padding around text
        let labelWidth = labelText.size(withAttributes: attrs).width + 10
        // if you modify labelHeigh you will have to tweak baselineOffset in attrs
        let labelHeight = labelText.size(withAttributes: attrs).height + 4

        // place pill above the marker, centered along x
        var rectangle = CGRect(x: point.x - 60, y: point.y + 20, width: labelWidth, height: labelHeight)
        rectangle.origin.x -= rectangle.width / 2.0
        let spacing: CGFloat = 20
        rectangle.origin.y -= rectangle.height + spacing

        // rounded rect
        let clipPath = UIBezierPath(roundedRect: rectangle, cornerRadius: 6.0).cgPath
        context.addPath(clipPath)
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.closePath()
        context.drawPath(using: .fillStroke)

        // add the text
        labelText.draw(with: rectangle, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        labelText = entry.data != nil ? entry.data as! String: ""
    }

    private func customString(_ value: Double) -> String {
        let formattedString = PillMarker.formatter.string(from: TimeInterval(value))!
        // using this to convert the left axis values formatting, ie 2 min
        return "\(formattedString)"
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    }
    
}
