//
//  TransactionView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import CoreData


struct BudgetUpdateView: View {
  
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @StateObject var ui: AppUI = AppUI()
    
    @Binding var budget: BudgetModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var save: Bool
    @Binding var delete: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Budget")
    
    @State var initialAmount: Double = 0
    @State var initialAmountFlag: Bool = false
    @State var transactionType: String? = ""
    @State var transactionTypeId: Int = 0
    
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""
    
    @Binding var isPlanning : Bool
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(budget: Binding<BudgetModel>, transaction: Binding<TransactionModel>, modal: Binding<Bool>, save: Binding<Bool>, delete: Binding<Bool>, currencies: Binding<GetCurrencies>, accounts: Binding<GetAccounts>, categories: Binding<GetCategories>, isPlanning: Binding<Bool> , isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
           self._budget = budget
           self._transaction = transaction
        self._modal = modal
        self._delete = delete
        self._save = save
        self._currencies = currencies
        self._categories = categories
        self._accounts = accounts
        self._isPlanning = isPlanning
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        self.initialAmount = budget.amount.wrappedValue
        
        UINavigationBar.appearance().isTranslucent = false
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
       }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        transactionType = transaction.type
        
        for index in 0..<accounts.items.count {
            accountList.append(accounts.items[index].name)
        }
        
        for index in 0..<categories.items.count {
            if(categories.items[index].id != 99) {
            categoryList.append(categories.items[index].name)
            }
        }
    }
    
    var body: some View {
        
        NavigationView {
            
    
            
        VStack(spacing: 0) {
           
            HeaderTabTitleView(title: budget.name)
           
            Form {
                

                
                VStack(spacing: 0){
                    
                    let fontAmount = budget.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

                    let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                    let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
                    
                    CurrencyField(
                                "Amount",
                                value: Binding(get: {
                                    return Decimal(budget.amount) as NSDecimalNumber
                                }, set: { number in
                                    var result: Double = 0
                                    if(number != nil) {
                                        result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                    }
                                    
                                    budget.amount = result
                                }), 
                        foregroundColor: UIColor(fontAmount),
                        font: ui.subtitle,
                        textAlignment: .center,
                                maxLength: 10
                            )
                        .padding()
                        .onChange(of: budget.amount, perform: { value in
                            if(!isPlanning) {
                            if(!initialAmountFlag) {
                                self.initialAmountFlag = true
                                transaction.amount = abs(transaction.initialAmount - self.budget.amount)
                                if(self.budget.amount < transaction.initialAmount) {
                                    transaction.type = LocalizedStringKey("Expense").toString()
                                    transactionType = LocalizedStringKey("Expense").toString()
                                } else {
                                    transaction.type = LocalizedStringKey("Income").toString()
                                    transactionType = LocalizedStringKey("Income").toString()
                                }
                             
                            } else {
                                self.initialAmountFlag = false
                            }
                            }
                            
                        })
                   
                    if(!isPlanning) {
                    Divider()
                        .padding(5)
                    DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Adjustment", value: $transaction.amount)
                        .onChange(of: transaction.amount, perform: { value in
                            if(!initialAmountFlag) {
                                self.initialAmountFlag = true
                              
                                if(transaction.type == LocalizedStringKey("Expense").toString() || transaction.type == LocalizedStringKey("Budget Adjustment").toString()) {
                                    self.budget.amount = transaction.initialAmount - transaction.amount
                                }
                                if(transaction.type == LocalizedStringKey("Income").toString()) {
                                    self.budget.amount = transaction.initialAmount + transaction.amount
                                }
                                
                            } else {
                                self.initialAmountFlag = false
                            }
                           
                        })
                    Divider()
                    
                    PickerInput(iconContent: "", iconColor: .blue, label: "Transaction", placeholder: "Type", data: $transferTypes.items, value: $transactionType, index: $transactionTypeId)
                        .onChange(of: transactionType, perform: { value in
                           
                            transaction.type = $transactionType.wrappedValue!
                            if(transaction.type == LocalizedStringKey("Expense").toString() || transaction.type == LocalizedStringKey("Budget Adjustment").toString()) {
                                self.budget.amount = transaction.initialAmount - transaction.amount
                                transaction.destinationId = accounts.items[0].id
                                accountIndex = 0
                                accountSelected = accountList[0]
                            }
                            if(transaction.type == LocalizedStringKey("Income").toString()) {
                                self.budget.amount = transaction.initialAmount + transaction.amount
                                transaction.destinationId = accounts.items[0].id
                                accountIndex = 0
                                accountSelected = accountList[0]
                            }
                            if(transaction.type == LocalizedStringKey("Budget Adjustment").toString()) {
                                self.budget.amount = transaction.initialAmount - transaction.amount
                            }
                        })
                    
                    
                    if(transaction.type == LocalizedStringKey("Expense").toString() || transaction.type == LocalizedStringKey("Income").toString()) {
                        Divider()
                            .padding(5)
                    PickerInput(iconContent: "", iconColor: .blue, label: "Account", placeholder: "Account", data: $accountList, value: $accountSelected, index: $accountIndex)
                        .onChange(of: accountIndex, perform: { value in
                            transaction.destinationId = accounts.items[accountIndex].id
                            
                        })
                        
                    }
                    
                    
                    Divider()
                        .padding(5)
                    PickerInput(iconContent: "", iconColor: .blue, label: "Category", placeholder: "Category", data: $categoryList, value: $categorySelected, index: $categoryIndex)
                        .onChange(of: categoryIndex, perform: { value in
                            transaction.category = categories.items[categoryIndex + 1].id
                        })
                        .padding(.bottom, 5)
                    }
                  
                   
                  }
                
                }
            
            
            Divider()
            NavigationLink(destination:
                            BudgetSettingsView(budget: self.$budget, transaction: self.$transaction, modal: self.$modal, delete: self.$delete, currencies: currencies)
                            .environmentObject(self.ui)
            ) {
                Text("Budget Settings")
            }
            .padding()
            .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            
               
                       }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text(budget.name)
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.budget.name != "") {
                                            self.modal = false
                                            self.save = true
                                        } else {
                                            self.toastMessasge = "Name is required"
                                            self.isShowingToast = true
                                            self.toastError = true
                                        }
                                    }
                }
                                }
        }
        .onAppear() {
            self.onAppear()
        }
            

            
        }
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        
        
           
    
}
    

}



struct BudgetSettingsView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    @Binding var budget: BudgetModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var delete: Bool
    
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @State var currencies: GetCurrencies
    
    @State private var showConfirm = false

    var body: some View {
       
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
            
        VStack(spacing: 0) {
            
            HeaderTabTitleView(title: budget.name)
            
                Form {
                    VStack(spacing: 0) {
              
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $budget.name)
                    

              
            }
                    
                    Picker("Icon", selection: $budget.iconContent) {
                        ForEach(icons.items) { icon in
                            Text(icon.name).tag(icon.content)
                            }
                                }
                    .padding()
                    
                
                   
                    Picker("Color", selection: $budget.iconColor) {
                        ForEach(colors.items) { color in
                            Text(color.name).tag(color.content)
                            }
                                }
                    .padding()
        
                    Picker("Currency", selection: $budget.currency) {
                                    ForEach(currencies.items) { item in
                                        Text(item.name).tag(item.code)
                                        }
                                            }
                    .onChange(of: budget.currency, perform: { value in
                        budget.symbol = currencies.getSymbol(currency: value)
                    })
                                .padding()
                    
                   
            }
               
                 
                
       
       Divider()
  
                                Button(action: {
                                    self.showConfirm = true
                                }) {
                                    Text("Delete Budget")
                                       .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                }
                                .padding()
        
     
        }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        
           
    
}
    var confirmDelete: Alert {
        Alert(title: Text("Delete Budget?"), message: Text("Are you sure you want to delete this budget?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}


