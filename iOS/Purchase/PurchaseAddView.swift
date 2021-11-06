//
//  PurchaseAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/2/21.
//

import SwiftUI

struct PurchaseAddView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var purchase: PurchaseModel
    @Binding var transaction: TransactionModel
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
    
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""
    
    init(purchase: Binding<PurchaseModel>, transaction: Binding<TransactionModel>, currencies: Binding<GetCurrencies> , accounts: Binding<GetAccounts>, categories: Binding<GetCategories>) {
        
           self._purchase = purchase
           self._transaction = transaction
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
        
        if(accountList.count != accounts.items.count) {
            for index in 0..<accounts.items.count {
              
                accountList.append(accounts.items[index].name)
            }
            accountIndex = 0
            accountSelected = accountList[0]
            transaction.account = accounts.items[0].name
            purchase.account = accounts.items[0].id
        }
        
        for index in 0..<categories.items.count {
            if(categories.items[index].id != 99) {
            categoryList.append(categories.items[index].name)
            }
        }
    }

    var body: some View {
        
     
        NavigationView {
        Form {

            VStack {

                let amountColor = purchase.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

                CurrencyField(
                            "Amount",
                            value: Binding(get: {
                                return Decimal(purchase.amount) as NSDecimalNumber
                            }, set: { number in
                                var result: Double = 0
                                if(number != nil) {
                                    result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                }

                                purchase.amount = result
                            }),
                    foregroundColor: UIColor(amountColor),
                    font: ui.subtitle,
                    textAlignment: .center,
                            maxLength: 10
                        )

                .padding()

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $purchase.name)


            }

                     

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



    }
        .navigationBarTitle("Back")
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("New Purchase")
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
    }
}
