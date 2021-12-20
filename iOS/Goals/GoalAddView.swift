//
//  GoalAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/2/21.
//

import SwiftUI

struct GoalAddView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var goal: GoalModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var save: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(goal: Binding<GoalModel>, transaction: Binding<TransactionModel>, currencies: Binding<GetCurrencies>, modal: Binding<Bool>, save: Binding<Bool>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool> ) {
        
           self._goal = goal
           self._transaction = transaction
        self._currencies = currencies
        self._modal = modal
        self._save = save
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        
        UINavigationBar.appearance().isTranslucent = false
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
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
            VStack(spacing: 0) {
            
            HeaderTabTitleView(title: "New Goal")
        Form {
        VStack {
            
            let amountColor = goal.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
            
            let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
            let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

            CurrencyField(
                        "Amount",
                        value: Binding(get: {
                            return Decimal(goal.amount) as NSDecimalNumber
                        }, set: { number in
                            var result: Double = 0
                            if(number != nil) {
                                result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                            }

                            goal.amount = result
                        }),
                foregroundColor: UIColor(amountColor),
                font: ui.subtitle,
                textAlignment: .center,
                        maxLength: 10
                    )
            .padding()

            TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $goal.name)
            Divider()
            DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Goal amount", value: $goal.target)
            
     
            
        }
            
         

            Picker("Currency", selection: $goal.currency) {
                            ForEach(currencies.items) { item in
                                Text(item.name).tag(item.code)
                                }
                                    }
            .onChange(of: goal.currency, perform: { value in
                goal.symbol = currencies.getSymbol(currency: value)
            })
                        .padding()
            
            Picker("Icon", selection: $goal.iconContent) {
                ForEach(icons.items) { icon in
                    Text(icon.name).tag(icon.content)
                    }
                        }
            .padding()
            
        
           
            Picker("Color", selection: $goal.iconColor) {
                ForEach(colors.items) { color in
                    Text(color.name).tag(color.content)
                    }
                        }
            .padding()
      
    }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text("New Goal")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.goal.name != "") {
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
        
    }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
    }
}
