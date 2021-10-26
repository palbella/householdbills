//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


struct AccountAddView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var account: AccountModel
    @Binding var transaction: TransactionModel
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    @ObservedObject var types = GetAccountTypes()
    
    @ObservedObject var yn = GetYesNo()
    
    @State var ignoreGoal: String? = "No"
    @State var ignoreGoalId = 0
    
    init(account: Binding<AccountModel>, transaction: Binding<TransactionModel>, currencies: Binding<GetCurrencies> ) {
        
           self._account = account
           self._transaction = transaction
        self._currencies = currencies
        
        UINavigationBar.appearance().isTranslucent = false
       }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
 

    var body: some View {
        NavigationView {
        Form {
            
            VStack {
                
                let amountColor = account.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                
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
                    foregroundColor: UIColor(amountColor),
                    font: ui.subtitle,
                    textAlignment: .center,
                            maxLength: 10
                        )
                .padding()

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $account.name)
        
            

                
            }
            
            Picker("Type", selection: $account.type) {
                ForEach(types.items) { item in
                    Text(item.name).tag(item.type)
                    }
                        }
            .onChange(of: account.type, perform: { value in
                    if(value == "crypto") {
                        self.account.iconContent = "bitcoinsign.circle"
                    }
                if(value == "stock") {
                    self.account.iconContent = "stocks"
                }
                if(value == "cash") {
                    self.account.iconContent = "wallet"
                }
                    
            })
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
        .navigationBarTitle("Back")
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("New Account")
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
