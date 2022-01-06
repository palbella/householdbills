//
//  PlanningBudgetView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/5/21.
//

import SwiftUI
import CoreData

struct PlanningPurchaseBodyView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var save: Bool = false
    @State var delete: Bool = false
  
    
    @State var purchaseSelected : PurchaseModel = PurchaseModel()
    
    @State var categories = GetCategories()
    
    @State var currencies = GetCurrencies()
    @State var accounts = GetAccounts ()
    @ObservedObject var fetchCurrencies = CurrencyData()
    @ObservedObject var fetchAccounts = AccountData()
    @ObservedObject var fetchCategories = FetchCategories()

    @ObservedObject var budgets = GetMonthlyPurchases()
    @State var transaction : TransactionModel = TransactionModel()
    @State var monthlyPurchaseData : MonthlyPurchaseData = MonthlyPurchaseData()
    
    @State var isPlanning : Bool = true
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var purchasesFetch: FetchedResults<MonthlyPurchase>

    @Binding var totalPurchases: Double
    
    @Binding var showSubscribe: Bool
    
    @State var totalPricesItem: Double = 0
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
  
    
    func onAppear() {
        self.currencies.items = fetchCurrencies.fetch()
        self.categories.items = fetchCategories.fetch(viewContext: viewContext)
        self.accounts.items = fetchAccounts.fetch()
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
                                        self.isShowingNew = true
                                        self.save = false
                                    } else {
                                       
                                        self.showSubscribe = true
                                    }
                                }) {
                                    
                                    CommandButton(content: "plus.circle")
                                }
                                .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                    if(self.$purchaseSelected.name.wrappedValue != "") {
                                        self.monthlyPurchaseData.addPurchase(purchase: self.$purchaseSelected.wrappedValue)
                                        getTotals()
                                    }
                                      
                                    }) {
                                    PurchaseAddView(purchase: self.$purchaseSelected, transaction: self.$transaction, currencies: self.$currencies, accounts: $accounts, categories: self.$categories, modal: self.$isShowingNew, save: self.$save, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
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
                                                self.purchaseSelected = monthlyPurchaseData.map(purchase: item)
                                                self.delete = false
                                                self.save = false
                                                self.isShowing = true
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
                                                monthlyPurchaseData.deletePurchase(purchase: self.$purchaseSelected.wrappedValue)
                                                getTotals()
                                            } else {
                                                self.$purchaseSelected.wrappedValue.amount = self.totalPricesItem
                                                monthlyPurchaseData.updatePurchase(purchase: self.$purchaseSelected.wrappedValue)
                                                getTotals()
                                            }
                                            
                                           
                                        }) {
                                            PurchaseUpdateView(purchase: self.$purchaseSelected, transaction: self.$transaction, modal: self.$isShowing, save: self.$save, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, categories: self.$categories, isPlanning: $isPlanning, totalPricesItem: self.$totalPricesItem, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                                            

                    
                      }
                    
                }
                                .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                
                
               
                
                Divider()
           
      
        }
        
       
     
    }
        .onAppear {
            self.onAppear()
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
        let fetchRequest: NSFetchRequest<MonthlyPurchase> = MonthlyPurchase.fetchRequest()
        self.totalPurchases = 0
        
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
