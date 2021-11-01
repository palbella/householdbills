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

    let lineChart = MyLineChartView()
    @State var viewContext: NSManagedObjectContext
    @Binding var showYear: Bool

    func makeUIView(context: UIViewRepresentableContext<LineChartSwiftUI>) -> MyLineChartView {
        setUpChart()
            
        return lineChart
    }

    func updateUIView(_ uiView: MyLineChartView, context: UIViewRepresentableContext<LineChartSwiftUI>) {
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
            
           
            var dataCollection :[BalanceChartModel] = []
            
            var dateComponent = DateComponents()
            
            var scope = 0
            
            if(!showYear) {
                scope = 31
            } else {
                scope = 365
            }
            
            for index in 0..<(scope - records.count) {
                dateComponent.day = -1 * (scope - records.count - index)
                var element = BalanceChartModel();
                element.balance = 0
                element.date = Calendar.current.date(byAdding: dateComponent, to: records[0].date!)
                dataCollection.append(element)
            }
            
            for object in records {
                var element = BalanceChartModel();
                element.balance = object.balance
                element.date = object.date
                dataCollection.append(element)
               
            }
            
            
            
        
//        var objects = [Obj(), Obj()]
        // (objects is defined as an array of struct with date and value)

        // Define the reference time interval
        var referenceTimeInterval: TimeInterval = 0
            if let minTimeInterval = (dataCollection.map { $0.date!.timeIntervalSince1970 }).min() {
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
            for object in dataCollection {
                let timeInterval = object.date!.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 12)

                let yValue = Double(object.balance!).rounded(toPlaces: 2)
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
//        xAxis.labelCount = 3
         xAxis.drawLabelsEnabled = true
//         xAxis.drawLimitLinesBehindDataEnabled = false
//         xAxis.avoidFirstLastClippingEnabled = false

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
        set.drawValuesEnabled = false
//        set.mode = .cubicBezier
        set.mode = .horizontalBezier
      
      
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





















@objc protocol MyChartViewDelegate {
    @objc optional func chartValueNoLongerSelected(_ chartView: MyLineChartView)
}


open class MyLineChartView: LineChartView {

    @objc weak var myChartViewDelegate: MyChartViewDelegate?

    private var touchesMoved = false

    // Haptic Feedback
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let selectionGenerator = UISelectionFeedbackGenerator()

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // This is here to prevent the UITapGesture from blocking touches moved from firing
//        if gestureRecognizer.isKind(of: NSUITapGestureRecognizer.classForCoder()){
//            return false
//        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    override open func nsuiTouchesBegan(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        impactGenerator.impactOccurred()
        selectionGenerator.prepare()
        // adds the highlight to the graph when tapped
        super.nsuiTouchesBegan(touches, withEvent: event)
        touchesMoved = false
        if let touch = touches.first {
            let h = getHighlightByTouchPoint(touch.location(in: self))

            if h === nil || h == self.lastHighlighted {
                lastHighlighted = nil
                highlightValue(nil, callDelegate: true)
            }
            else {
                lastHighlighted = h
                highlightValue(h, callDelegate: true)
            }
        }
    }

    open override func nsuiTouchesEnded(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesEnded(touches, withEvent: event)
//        myChartViewDelegate?.chartValueNoLongerSelected?(self) // remove the highlight
    }

    open override func nsuiTouchesCancelled(_ touches: Set<NSUITouch>?, withEvent event: NSUIEvent?) {
        super.nsuiTouchesCancelled(touches, withEvent: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // if a tap turns into a panGesture touches cancelled is called this prevents the highlight from being moved
            if !self.touchesMoved {
                self.myChartViewDelegate?.chartValueNoLongerSelected?(self)
            }
        }
    }

    override open func nsuiTouchesMoved(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesMoved(touches, withEvent: event)
        touchesMoved = true

        if let touch = touches.first {
            let h = getHighlightByTouchPoint(touch.location(in: self))

            if h === nil {
                lastHighlighted = nil
                highlightValue(nil, callDelegate: true)
            }
            else if h == self.lastHighlighted {
                return
            }
            else {
                lastHighlighted = h
                highlightValue(h, callDelegate: true)
                selectionGenerator.selectionChanged()
            }
        }
    }
}
