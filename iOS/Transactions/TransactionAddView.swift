//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI

struct TransactionsAddView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
  
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @State var currencies = GetCurrencies ()
    @State var accounts = GetAccounts ()
    @State var categories = GetCategories ()
    @State var budgets = GetBudgets ()
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Account")
 
    @Binding var accountId : UUID
    @Binding var transaction : TransactionModel
    
    @State var initialAmountFlag: Bool = false
    @State var transactionType: String? = LocalizedStringKey("Expense").toString()
    @State var transactionTypeId: Int = 0
    @State var accountIndex: Int = 0
    @State var destinationIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    @State var destinationSelected: String? = ""
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""
    @State var budgetIndex: Int = 0
    @State var budgetList: [String] = []
    @State var budgetSelected: String? = ""
    
    @ObservedObject var fetchAccounts = AccountData()
    @ObservedObject var fetchCategories = FetchCategories()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var budgetData = BudgetData()
    
    
    func onAppear() {
        
        self.budgets.items = budgetData.fetch()
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.categories.items = fetchCategories.fetch(viewContext: viewContext)
        self.accounts.items = fetchAccounts.fetch()
        self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
        
        for index in 0..<accounts.items.count {
            accountList.append(accounts.items[index].name)
        }
        
        categoryList = []
        for index in 0..<categories.items.count {
            if(categories.items[index].id != 99) {
            categoryList.append(categories.items[index].name)
            }
        }
        
        budgetList = ["None"]
        for index in 0..<budgets.items.count {
            budgetList.append(budgets.items[index].name)
        }
        
        transaction.iconColor = "blue"
        transaction.iconContent = "pencil"
        
        transactionType = LocalizedStringKey("Expense").toString()
        transaction.type = LocalizedStringKey("Expense").toString()
        
        accountId = accounts.items[0].id
        accountIndex = 0
        accountSelected = accountList[0]
        transaction.account = accounts.items[0].name
        
        transaction.destinationId = accounts.items[0].id
        accountIndex = 0
        accountSelected = accountList[0]
        
        transaction.currency = accounts.items[0].currency
    }
    
    var body: some View {
        
      
        NavigationView {
            
    
  
           
            Form {
                

                
                VStack(spacing: 0){
                    

                    let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                    let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
                    
                   
                 
                    DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Amount", value: $transaction.amount)
                     
                    Divider()
                    
                  
                    
                    PickerInput(iconContent: "", iconColor: .blue, label: "Transaction", placeholder: "Type", data: $transferTypes.items, value: $transactionType, index: $transactionTypeId)
                        .onChange(of: transactionType, perform: { value in
                          
                            transaction.type = $transactionType.wrappedValue!
                       
                            if(transaction.type == LocalizedStringKey("Transfer").toString()) {
                                transaction.destinationId = accounts.items[0].id
                                destinationIndex = 0
                                destinationSelected = accountList[0]
                            }
                        })
                    
                    Divider()
                        .padding(.top, 5)
                    
                    if(transaction.type != LocalizedStringKey("Transfer").toString()) {
                    Picker("Currency", selection: $transaction.currency) {
                                    ForEach(currencies.items) { item in
                                        Text(item.name).tag(item.code)
                                        }
                                            }
                    .onChange(of: transaction.currency, perform: { value in
                        transaction.symbol = currencies.getSymbol(currency: value)
                    })
                                .padding()
                    
                    Divider()
                    }
                    
                    
                    VStack(spacing: 0) {
                    PickerInput(iconContent: "", iconColor: .blue, label: "Account", placeholder: "Account", data: $accountList, value: $accountSelected, index: $accountIndex)
                        .onChange(of: accountIndex, perform: { value in
                            transaction.destinationId = accounts.items[accountIndex].id
                            transaction.account = accounts.items[accountIndex].name
                        })
                        Divider()
                        .padding(.top, 5)
                    
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Description", value: $transaction.name)
                    Divider()
                   
                
                    if(transaction.type == LocalizedStringKey("Transfer").toString()) {
                      
                    PickerInput(iconContent: "", iconColor: .blue, label: "Destination", placeholder: "Account", data: $accountList, value: $destinationSelected, index: $accountIndex)
                        .onChange(of: accountIndex, perform: { value in
                            transaction.destinationId = accounts.items[destinationIndex].id
                            
                        })
                        Divider()
                    }
                    
                 
                    PickerInput(iconContent: "", iconColor: .blue, label: "Category", placeholder: "Category", data: $categoryList, value: $categorySelected, index: $categoryIndex)
                        .onChange(of: categoryIndex, perform: { value in
                            transaction.category = categories.items[categoryIndex + 1].id
                            transaction.iconContent = categories.items[categoryIndex + 1].iconContent
                            transaction.iconColor = categories.items[categoryIndex + 1].iconColor
                        })
                        .padding(.bottom, 5)
                        
                    if(transaction.type == LocalizedStringKey("Expense").toString() && budgetList.count > 0) {
                        Divider()
                            .padding(5)
                        PickerInput(iconContent: "", iconColor: .blue, label: "Budget", placeholder: LocalizedStringKey("Budget").toString(), data: $budgetList, value: $budgetSelected, index: $budgetIndex)
                            .onChange(of: budgetIndex, perform: { value in
                                transaction.budget = budgets.items[budgetIndex - 1].id
                            })
                            .padding(.bottom, 5)
                        }
                   
                  }
                }
                
                }
            .navigationBarTitle("Back")
            .background(NavigationConfigurator { nc in
                let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                            nc.navigationBar.barTintColor = UIColor(color)
                        })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Transaction")
                        .font(ui.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            .onAppear() {

                self.onAppear()
                
            }

            
               
                       }
      
        
            
        
            
        
//        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        
        
        }


}


//#if DEBUG
//struct TransactionsBodyView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        TransactionsBodyView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//
//    }
//}
//#endif
