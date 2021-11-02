//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct PurchaseListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowingPurchasePlanning: Bool = false
    @State var isShowingNewPurchasePlanning: Bool = false
    @State var delete: Bool = false
   
    
    @State var purchaseSelected : PurchaseModel = PurchaseModel()
    @State var transaction : TransactionModel = TransactionModel()
    
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var transactionData = TransactionData()
    @ObservedObject var fetchCategories = FetchCategories()
    @ObservedObject var fetchAccounts = AccountData()

    @State var purchaseData : PurchaseData = PurchaseData()
    
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Purchase")
    
    @ObservedObject var purchases = GetPurchases()
    @State var categories = GetCategories()
    @State var accounts = GetAccounts()
    
    @State var isPlanning : Bool = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var purchasesFetch: FetchedResults<Purchase>

    @Binding var totalPurchases: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    @Binding var hideData: Bool
    
    @Binding var showSubscribe: Bool
    
    func onAppear() {
        
        self.categories.items = fetchCategories.fetch(viewContext: viewContext)
        self.accounts.items = fetchAccounts.fetch()
        self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
        getTotals()
    }
    
    var body: some View {
        
            VStack(spacing: 0) {

                Section(header:
                            HStack {
                                VStack{
                                    Spacer()
                                Text("PURCHASES")
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
                                        if(settings.subscribed || self.purchasesFetch.count < 1) {
                                        self.purchaseSelected = PurchaseModel()
                                        self.transaction = TransactionModel()
                                        self.purchaseSelected.iconContent = "cart"
                                        self.purchaseSelected.iconColor = "red"
                                        self.purchaseSelected.currency = settings.currency
                                        self.purchaseSelected.symbol = settings.symbol
                                        self.isShowingNewPurchasePlanning = true
                                        } else {
                                           
                                            self.showSubscribe = true
                                        }
                                    }) {

                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNewPurchasePlanning, onDismiss: {
                                    
                                        
                                        if(self.$purchaseSelected.name.wrappedValue != "") {
                                            self.transaction.name =  self.transferTypes.names[0]
                                            self.transaction.account = self.$purchaseSelected.name.wrappedValue
                                            self.transaction.amount = self.$purchaseSelected.amount.wrappedValue
                                            self.transaction.symbol = self.$purchaseSelected.symbol.wrappedValue
                                            self.transaction.iconContent = self.$purchaseSelected.iconContent.wrappedValue
                                            self.transaction.iconColor = self.$purchaseSelected.iconColor.wrappedValue
                                            self.transaction.timestamp = Date()
                                            saveTransaction(transaction: self.transaction)
                                            purchaseData.addPurchase(purchase: self.$purchaseSelected.wrappedValue)
                                            getTotals()
                                        }

                                        }) {
                                        PurchaseAddView(purchase: self.$purchaseSelected, transaction: self.$transaction, currencies: self.$currencies)
                                    }
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 17)
                                    .padding(.bottom, 12)
                                }

                            }


                ) {

                    Divider()

                

                    ForEach(self.purchasesFetch.indexed(), id: \.1.id) { index, item in


                                            Button(action: {
                                                if(settings.subscribed || index < 1) {
                                                    self.purchaseSelected = purchaseData.map(purchase: item)
                                                self.transaction = TransactionModel()
                                                self.transaction.type = LocalizedStringKey("Purchase Adjustment").toString()
                                                self.transaction.initialAmount = self.$purchaseSelected.amount.wrappedValue
                                                self.transaction.category = 1
                                                self.delete = false
                                                self.isShowingPurchasePlanning = true
                                                } else {
                                                   
                                                    self.showSubscribe = true
                                                }
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
                                                            if(!self.hideData) {
                                                                Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                            .font(.system(size: 15))
                                                            } else {
                                                                Text(item.symbol! + "---").padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                            .font(.system(size: 15))
                                                            }
                                                            


                                                        }
                                                            Spacer()
                                                           

                                                        }
                                                }
                                                .frame(maxWidth: .infinity)



                                                }

                                            }
                                            .sheet(isPresented: self.$isShowingPurchasePlanning, onDismiss: {
                                           

                                                if(self.delete) {
                                                    self.transaction.name =  self.transferTypes.names[1]
                                                    self.transaction.account = self.$purchaseSelected.name.wrappedValue
                                                    self.transaction.amount = self.$purchaseSelected.amount.wrappedValue
                                                    self.transaction.symbol = self.$purchaseSelected.symbol.wrappedValue
                                                    self.transaction.iconContent = self.$purchaseSelected.iconContent.wrappedValue
                                                    self.transaction.iconColor = self.$purchaseSelected.iconColor.wrappedValue
                                                    self.transaction.timestamp = Date()
                                                    saveTransaction(transaction: self.transaction)
                                                    purchaseData.deletePurchase(purchase: self.$purchaseSelected.wrappedValue)
                                                    getTotals()
                                                } else {
                                                    if(self.$transaction.amount.wrappedValue > 0 && (self.$transaction.type.wrappedValue == LocalizedStringKey("Expense").toString() || self.$transaction.type.wrappedValue == LocalizedStringKey("Income").toString())) {
                                                        self.transaction.name =  self.transferTypes.names[2]
                                                        self.transaction.account = self.$purchaseSelected.name.wrappedValue
                                                        self.transaction.amount = self.$transaction.amount.wrappedValue
                                                        if(transaction.type == LocalizedStringKey("Expense").toString()) {
                                                            self.$transaction.amount.wrappedValue = self.$transaction.amount.wrappedValue * -1
                                                        }
                                                        self.transaction.symbol = self.$purchaseSelected.symbol.wrappedValue
                                                        self.transaction.iconContent = self.$purchaseSelected.iconContent.wrappedValue
                                                        self.transaction.iconColor = self.$purchaseSelected.iconColor.wrappedValue
                                                        self.transaction.timestamp = Date()
                                                        saveTransaction(transaction: self.transaction)
                                                        
                                                        purchaseData.accountAdjustment(destination: self.$transaction.destinationId.wrappedValue, amount: self.$transaction.amount.wrappedValue)
                                                        
                                                    }
                                                    purchaseData.updatePurchase(purchase: self.$purchaseSelected.wrappedValue)
                                                    getTotals()
                                                }


                                            }) {
                                               PurchaseUpdateView(purchase: self.$purchaseSelected, transaction: self.$transaction, modal: self.$isShowingPurchasePlanning, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, isPlanning: $isPlanning)
                                                .environmentObject(self.ui)



                          }

                    }
                                    .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)


                   

                    Divider()


            }



        }
            .onAppear {
                self.onAppear()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                getTotals()

            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                getTotals()
                }
//            .onReceive(timer) { _ in
//                getpurchases()
//                       self.now = Date()
//                   }
          
        
     
    }
    
    private func saveTransaction(transaction: TransactionModel)
    {
      
            withAnimation {
               
                self.transactionData.addTransactions(transaction: transaction)
                self.expenses = abs(transactionData.fetchExpenses())
                self.incomes = transactionData.fetchIncomes()
            }
        getTotals()
    }
    
    private func getTotals()
    {
        self.totalPurchases = 0
        let fetchRequest: NSFetchRequest<Purchase> = Purchase.fetchRequest()
        self.purchases.items = [PurchaseModel]()
        
        do {
            let savedPurchases =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedPurchases.count {

                                let amount: Double = currencies.convert(currencyFrom: self.purchasesFetch[index].currency!, currencyTo: settings.currency, value: self.purchasesFetch[index].amount)
                                
                                self.totalPurchases = self.totalPurchases + amount
                                    }
        } catch {
           
        }

    }
    
   
}


//#if DEBUG
//struct PurchasesDashboardView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        PurchasesView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//
//    }
//}
//#endif

