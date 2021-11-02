//
//  TransactionView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import CoreData


struct PurchaseUpdateView: View {
  
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @StateObject var ui: AppUI = AppUI()
    
    @Binding var purchase: PurchaseModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var delete: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    @Binding var accounts : GetAccounts
 
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Purchase")
    
    @State var initialAmount: Double = 0
    @State var initialAmountFlag: Bool = false
    @State var transactionType: String? = ""
    @State var transactionTypeId: Int = 0
    
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    
    @State var isShowingItemNew: Bool = false
    @State var isShowingItemUpdate: Bool = false
    @State var deleteItem: Bool = false
    @State var modalItem: Bool = false
    @State var itemSelected : PurchaseItemModel = PurchaseItemModel()
//    @State var itemData : CryptocurrencyData = CryptocurrencyData()
    @State var totalPricesItem: Double = 0
  

    
    @Binding var isPlanning : Bool
    
    init(purchase: Binding<PurchaseModel>, transaction: Binding<TransactionModel>, modal: Binding<Bool>, delete: Binding<Bool>, currencies: Binding<GetCurrencies>, accounts: Binding<GetAccounts>, isPlanning: Binding<Bool>) {
           self._purchase = purchase
           self._transaction = transaction
        self._modal = modal
        self._delete = delete
        self._currencies = currencies
        self._accounts = accounts
        self._isPlanning = isPlanning
        self.initialAmount = purchase.amount.wrappedValue
        
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
        
     
    }
    
    var body: some View {
        
        NavigationView {
            
    
            
        VStack(spacing: 0) {
           
 
           
            PurchaseItemView(purchase: self.$purchase, itemSelected: self.$itemSelected, isShowingNew: self.$isShowingItemNew, isShowingUpdate: self.$isShowingItemUpdate,
                             deleteItem: self.$deleteItem, modalItem: self.$modalItem, totalPrices: self.$totalPricesItem)
                .environmentObject(self.ui)
                    .environmentObject(self.settings)
            
            
            
            
            
            Divider()
            NavigationLink(destination:
                            PurchaseSettingsView(purchase: self.$purchase, transaction: self.$transaction, modal: self.$modal, delete: self.$delete, currencies: currencies)
                            .environmentObject(self.ui)
            ) {
                Text("Purchase Settings")
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
                Text(purchase.name)
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
        }
        .onAppear() {
            self.onAppear()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
            

            
        }
//        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        
        
           
    
}
    

}



struct PurchaseSettingsView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    @Binding var purchase: PurchaseModel
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
                Form {
                    VStack(spacing: 0) {
              
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $purchase.name)
                    

              
            }
                    
                    Picker("Icon", selection: $purchase.iconContent) {
                        ForEach(icons.items) { icon in
                            Text(icon.name).tag(icon.content)
                            }
                                }
                    .padding()
                    
                
                   
                    Picker("Color", selection: $purchase.iconColor) {
                        ForEach(colors.items) { color in
                            Text(color.name).tag(color.content)
                            }
                                }
                    .padding()
        
                    Picker("Currency", selection: $purchase.currency) {
                                    ForEach(currencies.items) { item in
                                        Text(item.name).tag(item.code)
                                        }
                                            }
                    .onChange(of: purchase.currency, perform: { value in
                        purchase.symbol = currencies.getSymbol(currency: value)
                    })
                                .padding()
                    
                   
            }
               
                 
                
       
       Divider()
  
                                Button(action: {
                                    self.showConfirm = true
                                }) {
                                    Text("Delete Purchase")
                                       .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                }
                                .padding()
        
     
        }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
           
    
}
    var confirmDelete: Alert {
        Alert(title: Text("Delete Purchase?"), message: Text("Are you sure you want to delete this purchase?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}


