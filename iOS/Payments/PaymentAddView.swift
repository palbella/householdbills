//
//  PaymentAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/2/21.
//

import SwiftUI
import CoreData

struct PaymentAddView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var payment: PaymentModel
    @Binding var transaction: TransactionModel
    @Binding var currencies : GetCurrencies
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @ObservedObject var yn = GetYesNo()
    
    @State var isGoalDeposit: String? = "No"
    @State var isGoalDepositId = 0
    
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var goalsFetch: FetchedResults<Goal>
    
    @State var goals = GetGoals()
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""
    
    @State var monthDays = GetDays()
    @State var expirationDayIndex: Int = 0
    @State var expirationDaySelected: String? = ""
    
    init(payment: Binding<PaymentModel>, transaction: Binding<TransactionModel>, currencies: Binding<GetCurrencies>, accounts: Binding<GetAccounts>, categories: Binding<GetCategories>) {
        
           self._payment = payment
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
            payment.account = accounts.items[0].id
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
                
                let amountColor = payment.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

                CurrencyField(
                            "Amount",
                            value: Binding(get: {
                                return Decimal(payment.amount) as NSDecimalNumber
                            }, set: { number in
                                var result: Double = 0
                                if(number != nil) {
                                    result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                }

                                payment.amount = result
                            }),
                    foregroundColor: UIColor(amountColor),
                    font: ui.subtitle,
                    textAlignment: .center,
                            maxLength: 10
                        )
                .padding()

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $payment.name)
        
            
                
            }
            
        

            Picker("Currency", selection: $payment.currency) {
                            ForEach(currencies.items) { item in
                                Text(item.name).tag(item.code)
                                }
                                    }
            .onChange(of: payment.currency, perform: { value in
                payment.symbol = currencies.getSymbol(currency: value)
            })
                        .padding()
            
            PickerInput(iconContent: "", iconColor: .blue, label: "Account", placeholder: "Account", data: $accountList, value: $accountSelected, index: $accountIndex)
                .onChange(of: accountIndex, perform: { value in
                    payment.account = accounts.items[accountIndex].id
                })
           
           
            PickerInput(iconContent: "", iconColor: .blue, label: "Category", placeholder: "Category", data: $categoryList, value: $categorySelected, index: $categoryIndex)
                .onChange(of: categoryIndex, perform: { value in
                    payment.category = categories.items[categoryIndex + 1].id
                })
                .padding(.bottom, 5)

            
            PickerInput(iconContent: "", iconColor: .blue, label: "Notification Day", placeholder: "Day", data: $monthDays.items, value: $expirationDaySelected, index: $expirationDayIndex)
                .onChange(of: expirationDayIndex, perform: { value in
                    if(expirationDaySelected != nil) {
                    payment.notificationDay = Int32(expirationDayIndex)
                    }
                })
                .padding(.bottom, 5)
           
            
            Picker("Icon", selection: $payment.iconContent) {
                ForEach(icons.items) { icon in
                    Text(icon.name).tag(icon.content)
                    }
                        }
            .padding()
            
        
           
            Picker("Color", selection: $payment.iconColor) {
                ForEach(colors.items) { color in
                    Text(color.name).tag(color.content)
                    }
                        }
            .padding()
            
            
            PickerInput(iconContent: "", iconColor: .blue, label: "Is goal deposit", placeholder: "Selection", data: $yn.items, value: $isGoalDeposit, index: $isGoalDepositId)
                .onChange(of: isGoalDeposit, perform: { value in
                        if(value == "Yes") {
                            self.payment.isGoal = true
                        }
                        else {
                            self.payment.isGoal = false
                        }
                })
            
            if($isGoalDeposit.wrappedValue == "Yes") {
                Picker("Goal", selection: $payment.goalId) {
                    ForEach($goals.items.wrappedValue) { item in
                        Text(item.name).tag(item.id as UUID?)
                        }
                            }
                .padding()
            }
            
    
      
    }
        .navigationBarTitle("Back")
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("New Payment")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
        }
        .onAppear {
            getGoals()
            self.onAppear()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            getGoals()
        
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            getGoals()
            }
     
    }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
    }
    
    private func getGoals()
    {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        self.goals.items = [GoalModel]()
        
        do {
            let savedGoals =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedGoals.count {
                                self.goals.items.append(mapGoal(goal: self.goalsFetch[index]))
                                    }
        } catch {
           
        }

    }
    
    private func mapGoal(goal: Goal) -> GoalModel
    {
        var goalModel = GoalModel()
        
        goalModel.id = goal.id!
        goalModel.name = goal.name ?? ""
        goalModel.symbol = goal.symbol ?? ""
        goalModel.amount = goal.amount
        goalModel.target = goal.target
        goalModel.iconColor = goal.iconColor ?? ""
        goalModel.iconContent = goal.iconContent ?? ""

        return goalModel
    }
    
   
}
