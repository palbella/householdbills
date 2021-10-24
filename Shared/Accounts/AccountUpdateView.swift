//
//  HeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/26/21.
//

import SwiftUI
import CoreData

struct AccountUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var account: AccountModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var delete: Bool
    
    @State var isShowingCryptoNew: Bool = false
    @State var isShowingCryptoUpdate: Bool = false
    @State var deleteCrypto: Bool = false
    @State var modalCrypto: Bool = false
    @State var cryptoSelected : CryptocurrencyModel = CryptocurrencyModel()
    @State var cryptoData : CryptocurrencyData = CryptocurrencyData()
    @State var totalPricesCrypto: Double = 0
    @State var totalInvestmentsCrypto: Double = 0
    
    @State var isShowingStockNew: Bool = false
    @State var isShowingStockUpdate: Bool = false
    @State var deleteStock: Bool = false
    @State var modalStock: Bool = false
    @State var stockSelected : StockModel = StockModel()
    @State var stockData : StockData = StockData()
    @State var totalPricesStock: Double = 0
    @State var totalInvestmentsStock: Double = 0
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Account")
    
    @State var initialAmountFlag: Bool = false
    @State var transactionType: String? = ""
    @State var transactionTypeId: Int = 0
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""
  
    init(account: Binding<AccountModel>, transaction: Binding<TransactionModel>, modal: Binding<Bool>, delete: Binding<Bool>, currencies: Binding<GetCurrencies>, accounts: Binding<GetAccounts>, categories: Binding<GetCategories>) {
           self._account = account
           self._transaction = transaction
        self._modal = modal
        self._delete = delete
        self._currencies = currencies
        self._accounts = accounts
        self._categories = categories
       

        UINavigationBar.appearance().isTranslucent = false
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
        
        cryptoData.initialize(viewContext: viewContext)
        stockData.initialize(viewContext: viewContext)

    }
    
    var body: some View {
        
        
        NavigationView {
            
    
            
        VStack(spacing: 0) {
           
            if(self.account.type != "crypto" && self.account.type != "stock")
            {
           
            Form {
                

                
                VStack(spacing: 0){
                    
                    let fontAmount = account.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

                    let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                    let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
                    
                    CurrencyField(
                                "Amount",
                                value: Binding(get: {
                                    return Decimal(account.amount) as NSDecimalNumber
                                }, set: { number in
                                    var result: Double = 0
                                    if(number != nil) {
                                        result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                    }
                                    
                                    account.amount = result
                                }),
                        foregroundColor: UIColor(fontAmount),
                        font: ui.subtitle,
                        textAlignment: .center,
                                maxLength: 10
                            )
                    .padding()
                    .onChange(of: account.amount, perform: { value in
                        if(!initialAmountFlag) {
                            self.initialAmountFlag = true
                            transaction.amount = abs(transaction.initialAmount - self.account.amount)
                            if(self.account.amount < transaction.initialAmount) {
                                transaction.type = LocalizedStringKey("Expense").toString()
                                transactionType = LocalizedStringKey("Expense").toString()
                            } else {
                                transaction.type = LocalizedStringKey("Income").toString()
                                transactionType = LocalizedStringKey("Income").toString()
                            }
                          
                        } else {
                            self.initialAmountFlag = false
                        }
                        
                    })
                   
                    Divider()
                        .padding(5)
                    DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Adjustment", value: $transaction.amount)
                        .onChange(of: transaction.amount, perform: { value in
                            if(!initialAmountFlag) {
                                self.initialAmountFlag = true
                               
                                if(transaction.type == LocalizedStringKey("Expense").toString() || transaction.type == LocalizedStringKey("Transfer").toString()) {
                                    self.account.amount = transaction.initialAmount - transaction.amount
                                }
                                if(transaction.type == LocalizedStringKey("Income").toString()) {
                                    self.account.amount = transaction.initialAmount + transaction.amount
                                }
                                
                            } else {
                                self.initialAmountFlag = false
                            }
                           
                        })
                    Divider()
                    PickerInput(iconContent: "", iconColor: .blue, label: "Transaction", placeholder: LocalizedStringKey("Type").toString(), data: $transferTypes.items, value: $transactionType, index: $transactionTypeId)
                        .onChange(of: transactionType, perform: { value in
                          
                            transaction.type = $transactionType.wrappedValue!
                            if(transaction.type == LocalizedStringKey("Expense").toString() || transaction.type == LocalizedStringKey("Transfer").toString()) {
                                self.account.amount = transaction.initialAmount - transaction.amount
                            }
                            if(transaction.type == LocalizedStringKey("Income").toString()) {
                                self.account.amount = transaction.initialAmount + transaction.amount
                            }
                            if(transaction.type == LocalizedStringKey("Transfer").toString()) {
                                transaction.destinationId = accounts.items[0].id
                                accountIndex = 0
                                accountSelected = accountList[0]
                              
                            }
                        })
                   
                
                    if(transaction.type == LocalizedStringKey("Transfer").toString()) {
                        Divider()
                            .padding(5)
                    PickerInput(iconContent: "", iconColor: .blue, label: "Destination", placeholder: LocalizedStringKey("Account").toString(), data: $accountList, value: $accountSelected, index: $accountIndex)
                        .onChange(of: accountIndex, perform: { value in
                            transaction.destinationId = accounts.items[accountIndex].id
                            
                        })
                        
                    }
                    
                    Divider()
                        .padding(5)
                    PickerInput(iconContent: "", iconColor: .blue, label: "Category", placeholder: LocalizedStringKey("Category").toString(), data: $categoryList, value: $categorySelected, index: $categoryIndex)
                        .onChange(of: categoryIndex, perform: { value in
                            transaction.category = categories.items[categoryIndex + 1].id
                        })
                        .padding(.bottom, 5)
                   
                  }
                
                }
            
            }
            
            if(self.account.type == "crypto")
            {
                CryptocurrencyView(account: self.$account, cryptoSelected: self.$cryptoSelected, isShowingNew: self.$isShowingCryptoNew, isShowingUpdate: self.$isShowingCryptoUpdate,
                                   deleteCrypto: self.$deleteCrypto, modalCrypto: self.$modalCrypto, totalPrices: self.$totalPricesCrypto, totalInvestments: self.$totalInvestmentsCrypto)
                    .environmentObject(self.ui)
                        .environmentObject(self.settings)
            }
            
            if(self.account.type == "stock")
            {
                StockView(account: self.$account, stockSelected: self.$stockSelected, isShowingNew: self.$isShowingStockNew, isShowingUpdate: self.$isShowingStockUpdate,
                          deleteStock: self.$deleteStock, modalStock: self.$modalStock, totalPrices: self.$totalPricesStock, totalInvestments: self.$totalInvestmentsStock)
                    .environmentObject(self.ui)
                        .environmentObject(self.settings)
            }
            
            Divider()
            NavigationLink(destination:
                            AccountSettingsView(account: self.$account, transaction: self.$transaction, modal: self.$modal, delete: self.$delete, currencies: currencies)
                            .environmentObject(self.ui)
                               
            ) {
                Text("Account Settings")
            }
            .padding()
            .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            
               
                       }
        .navigationBarTitle("Back")
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(account.name)
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
        }
        .onAppear() {

            self.onAppear()
            
        }
        
            

            
        }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .sheet(isPresented: self.$isShowingCryptoNew, onDismiss: {
         
            if(self.$cryptoSelected.name.wrappedValue != "") {
                var crypto = self.$cryptoSelected.wrappedValue
                crypto.accountId = self.$account.wrappedValue.id
                cryptoData.addCrypto(crypto: crypto)
                                                                  }
            getTotalsCrypto()
            }) {
            CryptocurrencyAddView(crypto: self.$cryptoSelected)
            
        }
         .sheet(isPresented: self.$isShowingCryptoUpdate, onDismiss: {
                
                
                if(self.deleteCrypto) {
                    cryptoData.deleteCrypto(crypto: self.$cryptoSelected.wrappedValue)
                } else {
                    var crypto = self.$cryptoSelected.wrappedValue
                    crypto.accountId = self.$account.wrappedValue.id
                    cryptoData.updateCrypto(crypto: crypto)
                }
                getTotalsCrypto()
            }) {
              CryptocurrencyUpdateView(crypto: self.$cryptoSelected, modal: self.$isShowingCryptoUpdate, delete: self.$deleteCrypto)
         }
            .sheet(isPresented: self.$isShowingStockNew, onDismiss: {
             
                var stock = self.$stockSelected.wrappedValue
                stock.accountId = self.$account.wrappedValue.id
              
                               if(self.$stockSelected.name.wrappedValue != "") {
                                   stockData.addStock(stock: stock)
                               }
                getTotalsStock()

                }) {
                StockAddView(stock: self.$stockSelected)
                
            }
                .sheet(isPresented: self.$isShowingStockUpdate, onDismiss: {
                    
                    
                    if(self.deleteStock) {
                        stockData.deleteStock(stock: self.$stockSelected.wrappedValue)
                    } else {
                        stockData.updateStock(stock: self.$stockSelected.wrappedValue)
                    }
                    getTotalsStock()
                }) {
                  
              StockUpdateView(stock: self.$stockSelected, modal: self.$isShowingStockUpdate, delete: self.$deleteStock)
                      
                  
                    
}
        
        }
    
    private func getTotalsCrypto() {
        
        self.totalPricesCrypto = 0
        self.totalInvestmentsCrypto = 0
        let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()

        request.predicate = NSPredicate(format: "accountId = %@", self.$account.wrappedValue.id as CVarArg)

            do {
                let savedCryptos = try self.viewContext.fetch(request)
                
                for item in savedCryptos {
                    self.totalPricesCrypto = self.totalPricesCrypto + (item.price * item.amount)
                    self.totalInvestmentsCrypto = self.totalInvestmentsCrypto + (item.avgPurchase * item.amount)
                }
               
            } catch {
                print(error)
            }
        
    }
    
    private func getTotalsStock() {
        
        self.totalPricesStock = 0
        self.totalInvestmentsStock = 0
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        request.predicate = NSPredicate(format: "accountId = %@", self.$account.wrappedValue.id as CVarArg)

            do {
                let savedStocks = try self.viewContext.fetch(request)
                
                for item in savedStocks {
                    self.totalPricesStock = self.totalPricesStock + (item.price * item.amount)
                    self.totalInvestmentsStock = self.totalInvestmentsStock + (item.avgPurchase * item.amount)
                }
               
            } catch {
                print(error)
            }
        
    }


    }
   



struct AccountSettingsView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    
    @Binding var account: AccountModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var delete: Bool
    
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @State var currencies: GetCurrencies
    @ObservedObject var types = GetAccountTypes()
    
    @ObservedObject var yn = GetYesNo()
    
    @State var ignoreGoal: String? = "No"
    @State var ignoreGoalId = 0
    
    @State private var showConfirm = false

    var body: some View {
        
       
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
            
        VStack(spacing: 0) {
                Form {
                    VStack(spacing: 0) {
              
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $account.name)
                    

              
            }
                    
                    Picker("Icon", selection: $account.iconContent) {
                        ForEach(icons.items) { icon in
                            Text(icon.name).tag(icon.content)
                            }
                                }
                    .padding()
                    
                
                   
                    Picker("Color", selection: $account.iconColor) {
                        ForEach(colors.items) { color in
                            Text(color.name).tag(color.content)
                            }
                                }
                    .padding()
        
                    Picker("Currency", selection: $account.currency) {
                                    ForEach(currencies.items) { item in
                                        Text(item.name).tag(item.code)
                                        }
                                            }
                    .onChange(of: account.currency, perform: { value in
                        account.symbol = currencies.getSymbol(currency: value)
                    })
                    .padding()
                    
                    Picker("Type", selection: $account.type) {
                        ForEach(types.items) { item in
                            Text(item.name).tag(item.type)
                            }
                                }
                    .padding()
                    
                    PickerInput(iconContent: "", iconColor: .blue, label: "Ignore month available", placeholder: "Selection", data: $yn.items, value: $ignoreGoal, index: $ignoreGoalId)
                        .onChange(of: ignoreGoal, perform: { value in
                                if(value == "Yes") {
                                    self.account.ignoreGoal = true
                                }
                                else {
                                    self.account.ignoreGoal = false
                                }
                        })
                    
                   
            }
                .onAppear() {
                    if(account.ignoreGoal == true) {
                        ignoreGoal = "Yes"
                    } else {
                        ignoreGoal = "No"
                    }
                }
                 
                
       
       Divider()
  
                                Button(action: {
                                    self.showConfirm = true
                                }) {
                                    Text("Delete Account")
                                       .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                }
                                .padding()
        
     
        }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        
}
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Account?"), message: Text("Are you sure you want to delete this account?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}







//#if DEBUG
//struct accountView_Previews: PreviewProvider {
//
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//
//        AccountUpdateView(account: .constant(AccountModel()), transaction: .constant(Transaction()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//            .environmentObject(AppUI())
//            .environment(\.managedObjectContext, viewContext)
//    }
//}
//#endif




