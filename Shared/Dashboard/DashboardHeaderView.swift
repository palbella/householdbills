//
//  DashboardHeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct TopBar: View {
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var offset: CGFloat
    @Binding var maxHeight: CGFloat
    
    @Binding var totalAccounts: Double
    @Binding var totalGoalAccounts: Double
    @Binding var totalGoals: Double
    @Binding var totalPayments: Double
    @Binding var totalBudgets: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    
    @Binding var hideData: Bool
    
    func onAppear() {
   
       
    }
    
    var body: some View {
        
        let fontColorAccounts = self.totalAccounts >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
        
        let fontColorMonth = (self.totalGoalAccounts - self.totalGoals - self.totalBudgets - self.totalPayments) >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
        
        
        
        VStack(alignment: .center, spacing: 0) {
            
          
            Spacer()
            
            VStack {
                
               
                HStack {
                    Spacer()
                    VStack{
                    Image(systemName: "chevron.up.circle.fill")
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                        .font(.system(size: 25))
                        .padding(5)
                        VStack(alignment: .center){
                            Text("Incomes")
                                .font(.system(size: 10))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                            
                            if(!self.hideData) {
                                Text(settings.symbol + " " + String(incomes))
                                    .font(.system(size: 25))
                                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                            } else {
                                Text(settings.symbol + "---")
                                    .font(.system(size: 25))
                                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                            }
                            
                        }
                 
                    }
                    Spacer()
                    VStack{
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .foregroundColor(fontColorMonth)
                        .font(.system(size: 25))
                        .padding(5)
                        VStack(alignment: .center){
                            Text("Available Balance")
                                .font(.system(size: 10))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                            
                            
                            if(!self.hideData) {
                                Text(settings.symbol + " ")
                                    .font(.system(size: 25))
                                    .foregroundColor(fontColorMonth) +
                                Text("\((self.totalGoalAccounts - self.totalGoals - self.totalBudgets - self.totalPayments), specifier: "%.2f")")
                                    .font(.system(size: 25))
                                    .foregroundColor(fontColorMonth)
                            } else {
                                Text(settings.symbol + " ")
                                    .font(.system(size: 25))
                                    .foregroundColor(fontColorMonth) +
                                Text("---")
                                    .font(.system(size: 25))
                                    .foregroundColor(fontColorMonth)
                            }
                            
                           
                        }
                 
                    }
                    Spacer()
                       
                    VStack{
                    Image(systemName: "chevron.down.circle.fill")
                        .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                        .font(.system(size: 25))
                        .padding(5)
                        VStack(alignment: .center){
                            Text("Expenses")
                                .font(.system(size: 10))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                            if(!self.hideData) {
                            Text(settings.symbol + " " + String(expenses))
                                .font(.system(size: 25))
                                .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                            } else {
                                Text(settings.symbol + "---")
                                    .font(.system(size: 25))
                                    .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                            }
                        }
                       
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                .opacity(Double(getOpacityFast()))
                
              
                Button(action: {
                    self.hideData.toggle()
                }) {
                    
                    Image(systemName: "eye.fill")
                        .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                        .font(.system(size: 20))
                        .padding(5)
                        .opacity(Double(getOpacityMedium()))
                }
                
                    
                Text("Accounts Balance")
                    .font(.system(size: 10))
                    .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                    .opacity(Double(getOpacitySlow()))
                
                HStack(spacing: 0) {
                Text(settings.symbol + " ")
                    .foregroundColor(fontColorAccounts)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .opacity(Double(getOpacitySlow()))
                    
                    if(!self.hideData) {
                Text("\((self.totalAccounts), specifier: "%.2f")")
                    .foregroundColor(fontColorAccounts)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .opacity(Double(getOpacitySlow()))
                    } else {
                        Text("---")
                            .foregroundColor(fontColorAccounts)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .opacity(Double(getOpacitySlow()))
                    }
                }
            }
     

        
         
        }
        .padding(.bottom)
    }
    
    func getOpacitySlow() -> CGFloat {
        
        let progress = -offset / (maxHeight - ui.headerHeight + 50)
        
        let opacity = 1 - progress
        
        return offset < 0 ? opacity: 1
    }
    
    func getOpacityMedium() -> CGFloat {
        
        let progress = (-offset) / (maxHeight - 2 * ui.headerHeight)
        
        let opacity = 1 - progress
        
        return offset < 0 ? opacity: 1
    }
    
    func getOpacityFast() -> CGFloat {
        
        let progress = -offset / 20
        
        let opacity = 1 - progress
        
        return offset < 0 ? opacity: 1
    }
}


//#if DEBUG
//struct TopBarView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        GeometryReader { proxy in
//   
//            DashboardView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//        }
//    }
//}
//#endif
