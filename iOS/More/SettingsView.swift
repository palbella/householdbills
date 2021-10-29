//
//  TransactionView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import CoreData


struct SettingsView: View {
   
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var currencies : GetCurrencies
    @ObservedObject var units = GetUnits()
    @ObservedObject var yn = GetYesNo()
    
    @Binding var settings: SettingsModel
    
    @State var showDivider = 0
    @State var symbol: String = ""
    
    @State private var showConfirm = false
    
    init(settings: Binding<SettingsModel>, currencies: Binding<GetCurrencies>) {
        self._settings = settings
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
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
        
        NavigationView {
            
        Form {
            
            Picker("Currency", selection: $settings.currency) {
                ForEach(currencies.items) { item in
                    Text(item.name).tag(item.code)
                    }
                        }
            .onChange(of: settings.currency, perform: { value in
                settings.symbol = currencies.getSymbol(currency: value)
            })
            .padding()
            
            Picker("Unit", selection: $settings.unit) {
                ForEach(units.items) { item in
                    Text(item.name).tag(item.content)
                    }
                        }
            .padding()
            
            
            NumericInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Month Balance Day", value: $settings.dayChangeMonth, symbol: $symbol)
            
            Toggle("Update Currency", isOn: $settings.currencyUpdate)
                .padding()
            
            Toggle("Show Month Balance", isOn: $settings.showMonthBalance)
                .padding()
            
            VStack {

                
                Button(action: {
                    self.showConfirm = true
                }) {
                    HStack (spacing: 0) {
                        Text("")
         
                    Text("Remove All Data")
                        .foregroundColor(labelColor)
                 

                            
                    Spacer()
                            Text(">").padding(5).padding(.leading, 5).padding(.trailing, 5)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(fontColor)

                
                        
                }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
                
               
             
                
                
                
            }
            .alert(isPresented: $showConfirm, content: { confirmChange })
            
            
//            Button(action: {
//                migration()
//            }) {
//                Text("Migration")
//                    .foregroundColor(labelColor)
//            }
        }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
        }
        .onAppear(){
            self.onAppear()
        }
        }
        
        
           
    
}
    
//    func migration() {
//        deleteAllData(entity: "Settings")
//        initialDataCards()
//    }

    
    var confirmChange: Alert {
        Alert(title: Text("Delete All Data?"), message: Text("This application needs to restart to update the configuration.\n\nDo you want to restart the application?"),
            primaryButton: .default (Text("Yes")) {
                deleteAllData(entity: "Settings")
                deleteAllData(entity: "Card")
                deleteAllData(entity: "Transaction")
                deleteAllData(entity: "Account")
                deleteAllData(entity: "Goal")
                deleteAllData(entity: "Budget")
                deleteAllData(entity: "Payment")
                deleteAllData(entity: "Car")
            deleteAllData(entity: "MonthlyBudget")
            deleteAllData(entity: "MonthlyPayment")
                deleteAllData(entity: "HistoryBudget")
                deleteAllData(entity: "HistoryPayment")
                deleteAllData(entity: "HistoryAccount")
                deleteAllData(entity: "HistoryGoal")
                deleteAllData(entity: "Month")
                deleteAllData(entity: "Category")
                deleteAllData(entity: "CarService")
                deleteAllData(entity: "CarServices")
                deleteAllData(entity: "Cryptocurrency")
            deleteAllData(entity: "Stock")
                deleteAllData(entity: "Currency")
            deleteAllData(entity: "DailyBalance")
                restartApplication ()
            },
            secondaryButton: .cancel(Text("No"))
        )
    }

    func restartApplication () {
        var localUserInfo: [AnyHashable : Any] = [:]
            localUserInfo["pushType"] = "restart"
            
            let content = UNMutableNotificationContent()
            content.title = "Configuration Update Complete"
            content.body = "Tap to reopen the application"
            content.sound = UNNotificationSound.default
            content.userInfo = localUserInfo
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)

            let identifier = "com.domain.restart"
            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            
            center.add(request)
            exit(0)

    }
    
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try viewContext.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }

}



