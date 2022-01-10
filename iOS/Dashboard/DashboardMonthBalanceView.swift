//
//  DashboardHeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct MonthBalanceView: View {
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
    @State var isShowingBalance: Bool = false
    @State var isShowingAdjustment: Bool = false
    
    @Binding var totalAccounts: Double
    @Binding var totalGoalAccounts: Double
    @Binding var totalGoals: Double
    @Binding var totalPayments: Double
    @Binding var totalBudgets: Double
    @Binding var totalPurchases: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    @Binding var hideData: Bool
//    @State var incomeCalculation: Double = 0
    
    @State var goal: UUID? = nil
    @State var amount: Double = 0
    @State var modal: Bool = false
    @State var save: Bool = false
    
    
    @State var goals = GetGoals()
    
    func onAppear() {
   

       
    }
    
    var body: some View {
        
        if(self.totalGoals > 0) {
        VStack {
            Section(header:
                        HStack {
                VStack (spacing: 0){
                               
                            Text("MONTH AVAILABLE BALANCE")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
            }
                    Spacer()
                    
                    VStack {
                        Spacer()
                        Button(action: {
    
                            self.isShowingBalance = true
                        }) {
                            
                            CommandButton(content: "info.circle")
                        }
                        .sheet(isPresented: self.$isShowingBalance, onDismiss: {

                            }) {
                                
                                VStack (alignment: .center, spacing: 0) {
                                    
                                    Text("What is the Available Month Balance?")
                                        .padding(.bottom, 30)
                                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                        .font(.system(size: 25))
                                        .multilineTextAlignment(.center)
                                    
                                    Text("TOTAL BALANCE ACCOUNT")
                                        .font(.footnote)
                                        .padding(1)
                                    
                                    Text("(\((self.totalGoalAccounts), specifier: "%.2f"))")
                                        .font(.footnote)
                                        .padding(1)
                                }
                                    
                                    VStack(alignment: .center, spacing: 0) {
                                        
                                        Text("+")
                                            .padding(1)
                                    
                                    Text("MONTLY ESTIMATED INCOME")
                                            .font(.footnote)
                                            .padding(1)
                                        
                                        Text("(\((settings.estimatedMontlyIncomes), specifier: "%.2f"))")
                                            .font(.footnote)
                                            .padding(1)
                                       
                                        
                                    }
                                    
                                VStack(alignment: .center, spacing: 0) {
                                    Text("-")
                                            .padding(1)
                                    
                                    Text("ACQUIRED MONTHLY INCOME")
                                        .font(.footnote)
                                        .padding(1)
                                    
                                    Text("(\((self.incomes > settings.estimatedMontlyIncomes ? settings.estimatedMontlyIncomes : self.incomes), specifier: "%.2f"))")
                                   .font(.footnote)
                                        .padding(1)
                                }
                                    
                                VStack(alignment: .center, spacing: 0) {
                                    Text("-")
                                            .padding(1)
                                    
                                    Text("GOALS")
                                        .font(.footnote)
                                        .padding(1)
                                
                              
                                    Text("(\((self.totalGoals), specifier: "%.2f"))")
                                        .font(.footnote)
                                    .padding(1)
                                }
                                
                                VStack(alignment: .center, spacing: 0) {
                                    Text("-")
                                            .padding(1)
                                    
                                    Text("PAYMENTS")
                                        .font(.footnote)
                                        .padding(1)
                                    
                                  
                                    Text("(\((self.totalPayments), specifier: "%.2f"))")
                                        .font(.footnote)
                                        .padding(1)
                                }
                                 
                                VStack(alignment: .center, spacing: 0) {
                                    Text("-")
                                            .padding(1)
                                    
                                    Text("BUDGETS")
                                        .font(.footnote)
                                        .padding(1)
                                    
                                 
                                    Text("(\((self.totalBudgets), specifier: "%.2f"))")
                                        .font(.footnote)
                                        .padding(1)
                                }
                                
                                VStack(alignment: .center, spacing: 0) {
                                    Text("-")
                                            .padding(1)
                                    
                                    Text("PURCHASES")
                                        .font(.footnote)
                                        .padding(1)
                                    
                               
                                    Text("(\((self.totalPurchases), specifier: "%.2f"))")
                                        .font(.footnote)
                                        .padding(1)
                                }
                                    
                                    
                                    Text("It represents the money available to spend in the month without compromising goals")
                                        .padding()
                                        .multilineTextAlignment(.center)

                                
                            
                        }
                        .frame(width: 15, height: 15)
                        .padding(.leading, 10)
                        .padding(.trailing, 17)
                        .padding(.bottom, 2)
                    }
            }
                        
            ) {
                VStack(spacing:0) {
                   
                Divider()
                    Spacer()

                  
                    
                    let fontColorMonth = (getCalc()) >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

                    Button(action: {
                        self.amount = getCalc()
                        self.isShowingAdjustment = true
                    }) {
                            VStack(alignment: .center){
                                
                                if(!self.hideData) {
                                    Text(settings.symbol + " ")
                                        .font(.system(size: 18))
                                        .foregroundColor(fontColorMonth) +
                                    Text("\((getCalc()), specifier: "%.2f")")
                                        .font(.system(size: 18))
                                        .foregroundColor(fontColorMonth)
                                } else {
                                    Text(settings.symbol + " ")
                                        .font(.system(size: 18))
                                        .foregroundColor(fontColorMonth) +
                                    Text("---")
                                        .font(.system(size: 18))
                                        .foregroundColor(fontColorMonth)
                                }
                                
                               
                            }
                    }
                    .sheet(isPresented: self.$isShowingAdjustment, onDismiss: {

                        }) {
                            GoalAdjustmentView(goals: self.$goals, goal: self.$goal, amount: self.$amount, modal: self.$isShowingAdjustment, save: self.$save)
                                .padding(.top, 10)
                        }

                    Spacer()
                Divider()
              
            }
                .frame(height: ui.itemHeight)
                .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
//                                .padding(.bottom, 10)
               
            }

        }
        .padding(.top, 10)
        } else {
            VStack(spacing: 0) {
                
            }
        }
       
    }
    
    func getCalc() -> Double {
        
        var incomeCalculation = settings.estimatedMontlyIncomes
        if(self.incomes < settings.estimatedMontlyIncomes) {

            incomeCalculation = self.incomes
        }
        
        return self.totalGoalAccounts + settings.estimatedMontlyIncomes - incomeCalculation - self.totalPurchases - self.totalGoals - self.totalBudgets - self.totalPayments
    }
}


