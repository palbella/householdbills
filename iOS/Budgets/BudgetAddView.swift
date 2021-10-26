//
//  BudgetAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/2/21.
//

import SwiftUI

struct BudgetAddView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var budget: BudgetModel
    @Binding var transaction: TransactionModel
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    
    init(budget: Binding<BudgetModel>, transaction: Binding<TransactionModel>, currencies: Binding<GetCurrencies> ) {
        
           self._budget = budget
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

                let amountColor = budget.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

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
                    foregroundColor: UIColor(amountColor),
                    font: ui.subtitle,
                    textAlignment: .center,
                            maxLength: 10
                        )

                .padding()

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $budget.name)


            }

                     

            Picker("Currency", selection: $budget.currency) {
                            ForEach(currencies.items) { item in
                                Text(item.name).tag(item.code)
                                }
                                    }
            .onChange(of: budget.currency, perform: { value in
                budget.symbol = currencies.getSymbol(currency: value)
            })
                        .padding()

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



    }
        .navigationBarTitle("Back")
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("New Budget")
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
