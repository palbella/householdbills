//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


struct InvestmentAddView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var account: AccountModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var save: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    @ObservedObject var types = GetInvestmentTypes()
    
    @ObservedObject var yn = GetYesNo()
    
    @State var ignoreGoal: String? = "No"
    @State var ignoreGoalId = 0
    
    @State var groups = GetGroups()
    @State var groupIndex: Int = 0
    @State var groupSelected: String? = ""
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(account: Binding<AccountModel>, transaction: Binding<TransactionModel>, currencies: Binding<GetCurrencies>, modal: Binding<Bool>, save: Binding<Bool>,
    isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
        
           self._account = account
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
            
            HeaderTabTitleView(title: "New Account")
        Form {
            
            VStack {
                
                let amountColor = account.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

                CurrencyField(
                            "Amount", symbol: self.$account.wrappedValue.symbol,
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
            
            PickerInput(iconContent: "", iconColor: .blue, label: "Group", placeholder: "Group", data: $groups.items, value: $groupSelected, index: $groupIndex)
                .onChange(of: groupIndex, perform: { value in
                    if(groupSelected != nil) {
                        account.group = groupSelected!
                    }
                })
                .padding(.bottom, 5)
            
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
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text("New Account")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.account.name != "") {
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
