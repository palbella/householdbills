//
//  DashboardView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import Combine
import CoreData



struct DashboardView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    //var topEdge: CGFloat = 0
    @State var  maxHeight = UIScreen.main.bounds.height / 3.3

    @State var offset: CGFloat = 0
   
    @State var totalAccounts: Double = 0
    @State var totalGoalAccounts: Double = 0
    @State var totalGoals: Double = 0
    @State var totalPayments: Double = 0
    @State var totalBudgets: Double = 0
    @State var incomes: Double = 0
    @State var expenses: Double = 0
    
    @State var hideData: Bool = false
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var showUser: Bool
    @Binding var showSubscribe: Bool
  
    
    @State var currentMonthName: String = ""
    @ObservedObject var fetchTransactions = FetchTransactions()
    
  
    
    func onAppear() {
        
        self.expenses = abs(fetchTransactions.fetchExpenses(viewContext: viewContext))
        self.incomes = fetchTransactions.fetchIncomes(viewContext: viewContext)
       
    }

    var body: some View {

        let fontColorAccounts = self.totalAccounts >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
        
        let fontColorMonth = (self.totalGoalAccounts - self.totalGoals - self.totalBudgets - self.totalPayments) >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
        

            VStack(spacing: 0) {
            
            GeometryReader { proxy in
                
              
                    VStack(spacing: 0) {
                     
                        Spacer()

                            HStack(spacing: 0) {
                                Button(action: {
                                    self.showUser = true
                                }) {
                                Image(systemName: "person.circle")
                                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                    .font(.system(size: 20))
                                    .padding()
                                    .frame(width: 95)
                                    .padding(.trailing, 5)
                                }
                                Spacer()
                                
                                VStack {
                                    
                                    HStack(spacing: 0) {
                                        Text(settings.symbol + " ").font(.system(size: 10))
                                            .foregroundColor(fontColorMonth)
                                            .opacity(Double(getHeaderOpacity()))
                                        
                                        if(!self.hideData) {
                                            Text("\((self.totalGoalAccounts - self.totalGoals - self.totalBudgets - self.totalPayments), specifier: "%.2f")")
                                                .font(.system(size: 10))
                                                .foregroundColor(fontColorMonth)
                                                .opacity(Double(getHeaderOpacity()))
                                        } else {
                                            Text(settings.symbol + "---")
                                                .font(.system(size: 10))
                                                .foregroundColor(fontColorMonth)
                                                .opacity(Double(getHeaderOpacity()))
                                        }
                                        
                                       
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text(settings.symbol + " ")
                                            .foregroundColor(fontColorAccounts)
                                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                            .opacity(Double(getHeaderOpacity()))
                                        
                                        if(!self.hideData) {
                                            Text("\((self.totalAccounts), specifier: "%.2f")")
                                            .foregroundColor(fontColorAccounts)
                                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                            .opacity(Double(getHeaderOpacity()))
                                        } else {
                                            Text(settings.symbol + "---")
                                            .foregroundColor(fontColorAccounts)
                                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                            .opacity(Double(getHeaderOpacity()))
                                        }
                                        
                                       
                                    }
                                }
                              
                                Spacer()
                                Text(currentMonthName)
                                    .font(.system(size: 14))
                                    .padding()
                                    .foregroundColor(fontColorMonth)
                                    .frame(width: 95)
                            }


                        .frame(maxWidth: .infinity)
                      
                          Divider()
                            .opacity(getHeaderLineOpacity())
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(getHeadColor())
                   
                

            }
            .frame(height: ui.headerHeight)
            .zIndex(1)

        ScrollView(.vertical, showsIndicators: false) {

            VStack (spacing: 15 ) {


                    let customShape = ZStack() {

                        RoundedRectangle(cornerRadius: getCornerRadius())
                            .strokeBorder(colorScheme != .dark ? Color(UIColor.systemGray3): Color(UIColor(red: 69,green: 69,blue: 69)),lineWidth: 0.3)
                                   .background(RoundedRectangle(cornerRadius: getCornerRadius()).foregroundColor(getHeadColor()))

                        VStack{
                            RoundedRectangle(cornerRadius: 0)
                                .fill(getHeadColor())
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: 50)

                            Spacer()
                        }

                    }


                    TopBar(offset: $offset, maxHeight: $maxHeight, totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, totalGoals: self.$totalGoals, totalPayments: self.$totalPayments, totalBudgets: self.$totalBudgets, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData)
                    .frame(maxWidth: .infinity)
                        .background(customShape)
                       

                VStack(spacing: 15 ) {

                    DashboardBodyView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, totalGoals: self.$totalGoals, totalPayments: self.$totalPayments, totalBudgets: self.$totalBudgets, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, currentMonthName: $currentMonthName)

                }


            }
            .modifier(OffsetModifier(offset: $offset))
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)

        }
        .coordinateSpace(name: "SCROLL")
        .navigationBarHidden(true)
        .background(getHeadColor())
                
            }
            .ignoresSafeArea()
            .edgesIgnoringSafeArea([.top, .bottom])
            .onAppear() {
                self.onAppear()
            }


    }
    
    
    func getHeaderLineOpacity() -> Double {
        
        let opacity = -Double(offset) > Double(ui.headerHeight) + 110 ? 1: 0
        
        return Double(opacity)
    }
    
    func getHeaderOpacity() -> Double {
        
        let progress = (-offset - ui.headerHeight * 1.5) / 99
        
        let opacity = getHeaderLineOpacity() != 1 ? progress : 1
        
        return Double(opacity)
    }
    
    func getOpacity() -> CGFloat {
        
        let progress = -offset / 99
        
        let opacity = progress
        
        return opacity
    }

    func getOffset() -> CGFloat {

        var calcOffset = -offset - ui.headerHeight

        calcOffset = -calcOffset > maxHeight + offset ? maxHeight + offset: calcOffset

        return calcOffset
    }

    func getHeaderHeight() -> CGFloat {

        let topHeight = maxHeight + offset

        var result =  topHeight > (100) ? topHeight : (100)

        result = result - ui.headerHeight
        
        result = result < ui.headerHeight ? ui.headerHeight: result
        
        return result
    }

    func getCornerRadius() -> CGFloat {

        let progress = -offset / (maxHeight - (100))

        let value = 1 - progress

        let radius = value * 30

        let result =  offset < 0 ? radius : 35

        return result
    }

    func getHeadColor() -> Color {

        var color = colorScheme != .dark ? ui.lightDashboardHeadColor: ui.darkDashboardHeadColor

        let progress = getHeaderLineOpacity()

        if colorScheme == .dark {
            if progress == 1 {
                color = Color.black
            }
        }

        return color
    }

}





struct CustomCorner: Shape {

    var corners: UIRectCorner
    var radius: CGFloat
    var insetAmount: CGFloat = 0

    func path (in rect: CGRect) -> Path {

        let size = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: size)

        return Path(path.cgPath)
    }
}


struct OffsetModifier: ViewModifier {

    @Binding var offset: CGFloat

    func body (content: Content) -> some View {

       content
        .overlay(

            GeometryReader { proxy -> Color in

                let minY = proxy.frame(in: .named("SCROLL")).minY

                DispatchQueue.main.async {
                    self.offset = minY
                }

                return Color.clear

            }

            ,alignment: .top
        )
    }
}



//#if DEBUG
//struct DashboardView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        GeometryReader { proxy in
//    //let topEdge = proxy.safeAreaInsets.top
//            DashboardView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//        }
//    }
//}
//#endif
