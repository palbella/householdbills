//
//  DashboardHeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct MonthBalanceView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
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
    
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = CurrencyData()
    
    @State var goal: UUID? = nil
    @State var amount: Double = 0
    @State var modal: Bool = false
    @State var save: Bool = false
    
    @State var goalData : GoalData = GoalData()
    
    @State var goals = GetGoals()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var goalsFetch: FetchedResults<Goal>
    
    func onAppear() {
   
        self.currencies.items = fetchCurrencies.fetch()
        goalData.fetchCurrencies.items = self.currencies.items
        self.goals.items = goalData.fetch()
       
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
               

                    Button(action: {
                        self.amount = getCalc()
                        self.isShowingAdjustment = true
                    }) {
                        VStack(spacing:0) {
                           
                        Divider()
                            Spacer()

                          
                            
                            let fontColorMonth = (getCalc()) >= -0.5 ? ui.lightItemFontAmountColor: ui.lightItemNegativeFontAmountColor
                            
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
                            .onAppear() {
                                self.onAppear()
                            }
                            
                            Spacer()
                        Divider()
                      
                    }
                        .frame(height: ui.itemHeight)
                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
        //                                .padding(.bottom, 10)
                    }
                    .sheet(isPresented: self.$isShowingAdjustment, onDismiss: {
                        
                        if(settings.fastApply || self.save) {
                            if (self.goal != nil) {
                                self.goalData.upjustmentGoal(id: self.goal!, amount: self.amount, currencyFrom: settings.currency)
                                self.getTotals()
                            }
                        }

                        }) {
                            GoalAdjustmentView(goals: self.$goals, goal: self.$goal, amount: self.$amount, modal: self.$isShowingAdjustment, save: self.$save)
                                .padding(.top, 10)
                        }

                  
               
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
    
    private func getTotals()
    {
        self.totalGoals = 0
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        self.goals.items = [GoalModel]()
        
        do {
            let savedGoals =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedGoals.count {

                                let amount: Double = currencies.convert(currencyFrom: self.goalsFetch[index].currency!, currencyTo: settings.currency, value: self.goalsFetch[index].amount)
                                
                                self.totalGoals = self.totalGoals + amount
                                    }
        } catch {
           
        }

    }
}


