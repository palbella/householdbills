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
    @Binding var save: Bool
    @Binding var delete: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
 
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Purchase")
    
    @State var initialAmount: Double = 0
    @State var initialAmountFlag: Bool = false
    @State var transactionType: String? = ""
    @State var transactionTypeId: Int = 0
    
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    

    @Binding var totalPricesItem: Double
    @Binding var isPlanning : Bool
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(purchase: Binding<PurchaseModel>, transaction: Binding<TransactionModel>, modal: Binding<Bool>, save: Binding<Bool>, delete: Binding<Bool>, currencies: Binding<GetCurrencies>, accounts: Binding<GetAccounts>, categories: Binding<GetCategories>, isPlanning: Binding<Bool>, totalPricesItem: Binding<Double>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
           self._purchase = purchase
           self._transaction = transaction
        self._modal = modal
        self._save = save
        self._delete = delete
        self._currencies = currencies
        self._accounts = accounts
        self._isPlanning = isPlanning
        self._totalPricesItem = totalPricesItem
        self._categories = categories
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        self.initialAmount = purchase.amount.wrappedValue
        
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
        
     
    }
    
    var body: some View {
        
        NavigationView {
            
    
            
        VStack(spacing: 0) {
           
            HeaderTabTitleView(title: purchase.name)
           
            PurchaseItemView(purchase: self.$purchase, totalPrices: self.$totalPricesItem, isPlanning: self.$isPlanning)
                .environmentObject(self.ui)
                    .environmentObject(self.settings)
            
            
            
            
            
            Divider()
            NavigationLink(destination:
                            PurchaseSettingsView(purchase: self.$purchase, transaction: self.$transaction, modal: self.$modal, delete: self.$delete, currencies: currencies, accounts: self.$accounts, categories: self.$categories)
                            .environmentObject(self.ui)
            ) {
                Text("Purchase Settings")
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
                Text(purchase.name)
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.purchase.name != "") {
                                            self.modal = false
                                            self.save = true
                                        } else {
                                            self.toastMessasge = LocalizedStringKey("Name is required").toString()
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
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        .navigationViewStyle(StackNavigationViewStyle())
    
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
    
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
    
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        for index in 0..<accounts.items.count {
            accountList.append(accounts.items[index].name)
            
           
            if(accounts.items[index].id == purchase.account) {
                accountIndex = index
                accountSelected = accounts.items[index].name
            }
        }
        
        for index in 0..<categories.items.count {
            if(categories.items[index].id != 99) {
            categoryList.append(categories.items[index].name)
            }
            if(categories.items[index].id == purchase.category) {
                categoryIndex = index
                categorySelected = categories.items[index].name
            }
        }
        
 
        
    }

    var body: some View {
       
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
            
        VStack(spacing: 0) {
            HeaderTabTitleView(title: purchase.name)
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
                    
                    PickerInput(iconContent: "", iconColor: .blue, label: "Account", placeholder: "Account", data: $accountList, value: $accountSelected, index: $accountIndex)
                        .onChange(of: accountIndex, perform: { value in
                            purchase.account = accounts.items[accountIndex].id
                        
                        })
                    
                    PickerInput(iconContent: "", iconColor: .blue, label: "Category", placeholder: "Category", data: $categoryList, value: $categorySelected, index: $categoryIndex)
                        .onChange(of: categoryIndex, perform: { value in
                            purchase.category = categories.items[categoryIndex + 1].id
                        })
                        .padding(.bottom, 5)
                   
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
        .onAppear {
            self.onAppear()
           
        }
    
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


