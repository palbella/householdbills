//
//  HeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/26/21.
//

import SwiftUI
import CoreData

struct PaymentUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @StateObject var ui: AppUI = AppUI()
    
    @Binding var payment: PaymentModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var save: Bool
    @Binding var delete: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
    @Binding var currencies : GetCurrencies
    
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Payment")
    
    @State var initialAmount: Double = 0
    @State var initialAmountFlag: Bool = false
    @State var transactionType: String? = ""
    @State var transactionTypeId: Int = 0
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
  
    init(payment: Binding<PaymentModel>, transaction: Binding<TransactionModel>, modal: Binding<Bool>, save: Binding<Bool>, delete: Binding<Bool>, currencies: Binding<GetCurrencies>, accounts: Binding<GetAccounts>, categories: Binding<GetCategories>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
           self._payment = payment
           self._transaction = transaction
        self._modal = modal
        self._delete = delete
        self._save = save
        self._currencies = currencies
        self._accounts = accounts
        self._categories = categories
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        self.initialAmount = payment.amount.wrappedValue
        
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
           
 
            HeaderTabTitleView(title: payment.name)
            Form {
                

                
                VStack(spacing: 0){
                    
                    let fontAmount = payment.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

                
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
                        foregroundColor: UIColor(fontAmount),
                        font: ui.subtitle,
                        textAlignment: .center,
                                maxLength: 10
                            )
                    .padding()

                   
                  
                    Toggle("Is Paid", isOn: $payment.isPaid)
                        .padding()
                    
                  
                    
                   
                  }
                
                }
            
            
            Divider()
            NavigationLink(destination:
                            PaymentSettingsView(payment: self.$payment, transaction: self.$transaction, modal: self.$modal, delete: self.$delete, currencies: $currencies, accounts: $accounts, categories: $categories)
                            .environmentObject(self.ui)
            ) {
                Text("Payment Settings")
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
                Text(payment.name)
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.payment.name != "") {
                                            self.modal = false
                                            self.save = true
                                        } else {
                                            self.toastMessasge = "Name is required"
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
//        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        
        
        }
    


    }
   



struct PaymentSettingsView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var payment: PaymentModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var delete: Bool
    
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies: GetCurrencies
    
    @ObservedObject var yn = GetYesNo()
    
    @State var isGoalDeposit: String? = "No"
    @State var isGoalDepositId = 0
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var goalsFetch: FetchedResults<Goal>
    
    @State var goals = GetGoals()
    
    @Binding var accounts : GetAccounts
    @Binding var categories : GetCategories
    
    @State private var showConfirm = false
    
    @State var accountIndex: Int = 0
    @State var accountList: [String] = []
    @State var accountSelected: String? = ""
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""
    
    @State var monthDays = GetDays()
    @State var expirationDayIndex: Int = 0
    @State var expirationDaySelected: String? = ""
    
    init (payment: Binding<PaymentModel>, transaction: Binding<TransactionModel>, modal: Binding<Bool>, delete: Binding<Bool>, currencies: Binding<GetCurrencies>, accounts: Binding<GetAccounts>, categories: Binding<GetCategories>) {
        
        self._payment = payment
        self._transaction = transaction
     self._modal = modal
     self._delete = delete
        self._accounts = accounts
        self._categories = categories
        
        self._currencies = currencies
        
     
    }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        for index in 0..<accounts.items.count {
            accountList.append(accounts.items[index].name)
            
           
            if(accounts.items[index].id == payment.account) {
                accountIndex = index
                accountSelected = accounts.items[index].name
            }
        }
        
        for index in 0..<categories.items.count {
            if(categories.items[index].id != 99) {
            categoryList.append(categories.items[index].name)
            }
            if(categories.items[index].id == payment.category) {
                categoryIndex = index
                categorySelected = categories.items[index].name
            }
        }
        
        if(self.payment.isGoal) {
            isGoalDeposit = "Yes"
        } else {
            isGoalDeposit = "No"
        }
        
        getGoals()
        
      
        expirationDayIndex = Int(payment.notificationDay)
        expirationDaySelected = monthDays.items[expirationDayIndex]
        
    }

    var body: some View {
       
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
            
        VStack(spacing: 0) {
            HeaderTabTitleView(title: payment.name)
                Form {
                    VStack(spacing: 0) {
              
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $payment.name)
                    

              
            }
                    
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
               
                 
                
       
       Divider()
  
                                Button(action: {
                                    self.showConfirm = true
                                }) {
                                    Text("Delete Payment")
                                       .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                }
                                .padding()
        
     
        }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        .onAppear {
            self.onAppear()
           
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            getGoals()
        
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            getGoals()
            }
    
}
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Payment?"), message: Text("Are you sure you want to delete this payment?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
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







//#if DEBUG
//struct accountView_Previews: PreviewProvider {
//
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//
//        AccountUpdateView(account: .constant(AccountModel()), transaction: .constant(Transaction()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//            .environmentObject(AppUI())
//            .environment(\.managedObjectContext, viewContext)
//    }
//}
//#endif




