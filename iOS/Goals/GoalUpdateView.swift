//
//  HeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/26/21.
//

import SwiftUI


struct GoalUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var goal: GoalModel
    @Binding var transaction: TransactionModel
    @Binding var modal: Bool
    @Binding var save: Bool
    @Binding var delete: Bool
    
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @Binding var currencies : GetCurrencies
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Goal")
    
    @State var initialAmount: Double = 0
    @State var initialAmountFlag: Bool = false
    @State var transactionType: String? = ""
    @State var transactionTypeId: Int = 0
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(goal: Binding<GoalModel>, transaction: Binding<TransactionModel>, modal: Binding<Bool>, save: Binding<Bool>, delete: Binding<Bool>, currencies: Binding<GetCurrencies>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
        
        self._goal = goal
        self._transaction = transaction
     self._modal = modal
        self._save = save
     self._delete = delete
     self._currencies = currencies
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
           
            HeaderTabTitleView(title: goal.name)
            Form {
                VStack{
                    
                    let fontAmount = goal.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

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
                        foregroundColor: UIColor(fontAmount),
                        font: ui.subtitle,
                        textAlignment: .center,
                                maxLength: 10
                            )
                    .padding()
                   
                    Divider()
                    
                
                    DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Goal amount", value: $goal.target)
         
                    Divider()
                      
                    
                    let percent = goal.amount < goal.target ? goal.amount * 100 / goal.target: 100
                    ProgressView("", value: percent, total: 100)
                    .font(.system(size: 10))
                    .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray): ui.darkCommandFontColor)
                    .padding(.bottom, 10)
                   
                  }
                
                    
                   
                   
                }
            
            
            Divider()
            NavigationLink(destination:
                            GoalSettingsView(goal: self.$goal, transaction: self.$transaction, modal: self.$modal, delete: self.$delete, currencies: currencies)
                            .environmentObject(self.ui)
            ) {
                Text("Goal Settings")
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
                Text(goal.name)
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
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        

        
        
        }
    


    }
   



struct GoalSettingsView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    @Binding var goal: GoalModel
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
            
            HeaderTabTitleView(title: goal.name)
                Form {
                    VStack(spacing: 0) {
              
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $goal.name)
                    

              
            }
                    
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
        
                    Picker("Currency", selection: $goal.currency) {
                                    ForEach(currencies.items) { item in
                                        Text(item.name).tag(item.code)
                                        }
                                            }
                    .onChange(of: goal.currency, perform: { value in
                        goal.symbol = currencies.getSymbol(currency: value)
                    })
                                .padding()
                    
                   
            }
               
                 
                
       
       Divider()
  
                                Button(action: {
                                    self.showConfirm = true
                                }) {
                                    Text("Delete Goal")
                                       .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                }
                                .padding()
        
     
        }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        
    }
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Goal?"), message: Text("Are you sure you want to delete this goal?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
}





//#if DEBUG
//struct goalView_Previews: PreviewProvider {
//    @Binding var goalSelected : Goal
//    @Binding var transaction : Transaction
//
//    static var previews: some View {
//
//
//        GoalView(goal: .constant(Goal()), transaction: .constant(Transaction())).environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif





