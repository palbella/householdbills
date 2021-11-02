//
//  PlanningBudgetView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/5/21.
//

import SwiftUI
import CoreData

struct PlanningBudgetBodyView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var delete: Bool = false
  
    
    @State var budgetSelected : BudgetModel = BudgetModel()
    
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var fetchCategories = FetchCategories()
    @ObservedObject var fetchAccounts = AccountData()

    @State var categories = GetCategories()
    @ObservedObject var budgets = GetMonthlyBudgets()
    @State var accounts = GetAccounts()
    @State var transaction : TransactionModel = TransactionModel()
    @State var monthlyBudgetData : MonthlyBudgetData = MonthlyBudgetData()
    
    @State var isPlanning : Bool = true
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var budgetsFetch: FetchedResults<MonthlyBudget>

    @Binding var totalBudgets: Double
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Section(header:
                        HStack {
                            VStack{
                                Spacer()
                            Text("BUDGETS")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                            }
                            Spacer()
                            
                            VStack {
                                Spacer()
                                Button(action: {
                                    self.budgetSelected = BudgetModel()
                                    self.budgetSelected.iconContent = "camera"
                                    self.budgetSelected.iconColor = "red"
                                    self.budgetSelected.currency = settings.currency
                                    self.budgetSelected.symbol = settings.symbol
                                    self.isShowingNew = true
                                }) {
                                    
                                    CommandButton(content: "plus.circle")
                                }
                                .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                    if(self.$budgetSelected.name.wrappedValue != "") {
                                        self.monthlyBudgetData.addBudget(budget: self.$budgetSelected.wrappedValue)
                                        getTotals()
                                    }
                                      
                                    }) {
                                    BudgetAddView(budget: self.$budgetSelected, transaction: self.$transaction, currencies: self.$currencies)
                                }
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                                .padding(.trailing, 17)
                                .padding(.bottom, 12)
                            }
                           
                        }
                      
                        
            ) {

                Divider()
                
              
                
                ForEach(self.budgetsFetch.indexed(), id: \.1.id) { index, item in
                    
                    
                                        Button(action: {
                                            self.budgetSelected = monthlyBudgetData.map(budget: item)
                                            self.delete = false
                                            self.isShowing = true
                                        }) {

                                            VStack (spacing: 0) {
                                                HStack (spacing: 0) {
                                                    Icon(content: item.iconContent!, color: getColor(color: item.iconColor!)).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                
                                                    VStack (spacing: 0) {
                                                        Spacer()
                                                    HStack (spacing: 0) {
                                                        Text(item.name!)
                                                    .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                    .font(.system(size: 15))
                                                        
                                                Spacer()
                                                        Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                    .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                    .font(.system(size: 15))

                                                        
                                                    }
                                                        Spacer()
                                                      
                                                        
                                                    }
                                            }
                                            .frame(maxWidth: .infinity)
                                           
                                                
                                              
                                            }
                                            
                                        }
                                        .sheet(isPresented: self.$isShowing, onDismiss: {
                                            
                                            if(self.delete) {
                                                monthlyBudgetData.deleteBudget(budget: self.$budgetSelected.wrappedValue)
                                                getTotals()
                                            } else {

                                                monthlyBudgetData.updateBudget(budget: self.$budgetSelected.wrappedValue)
                                                getTotals()
                                            }
                                            
                                           
                                        }) {
                                            BudgetUpdateView(budget: self.$budgetSelected, transaction: self.$transaction, modal: self.$isShowing, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, categories: $categories, isPlanning: $isPlanning)
                                            

                    
                      }
                    
                }
                                .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                
                
               
                
                Divider()
           
      
        }
        
       
     
    }
        .onAppear {
            self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
            getTotals()
        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//            getTotals()
//        
//        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//            getTotals()
//            }
       
    }
    
    func getTotals()
    {
        let fetchRequest: NSFetchRequest<MonthlyBudget> = MonthlyBudget.fetchRequest()
        self.totalBudgets = 0
        
        do {
            let savedBudgets =  try viewContext.fetch(fetchRequest)

            for index in 0..<savedBudgets.count {

                let amount: Double = currencies.convert(currencyFrom: self.budgetsFetch[index].currency!, currencyTo: settings.currency, value: self.budgetsFetch[index].amount)
                
                self.totalBudgets = self.totalBudgets + amount
                    }
        } catch {

        }

    }
    
   
   
}
