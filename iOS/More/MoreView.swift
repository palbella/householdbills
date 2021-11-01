//
//  TransactionView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import CoreData

struct MoreView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingSettings: Bool = false
    @State var isShowingOrdering: Bool = false
    @State var isShowingCar: Bool = false
    @State var isShowingCategory: Bool = false
    @State var isShowingCurrencies: Bool = false
    @State var isShowingPassword: Bool = false
    @State var isShowingNotification: Bool = false
    
    @State var settingsObj: SettingsModel = SettingsModel()
    
    @State var orderingItems : [String] = []
    
    let settingsFetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
    let currencyFetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
    
    @State var viewRefresh : Int = 0
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @State var commandLeftTrigger: Bool = false
    @State var commandRightTrigger: Bool = false
    
    @Binding var showSubscribe: Bool
    @State var showSubscribeCar: Bool = false
    

    func onAppear() {
        self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext, includeNotSelected: true)
        //                    EmailHelper.shared.send(subject: "SwiftMail", body: "Test", to: ["wpablow@gmail.com"])
    }
    
    
    var body: some View {
        
        VStack {
        
        GeometryReader { proxy in
            
            HeaderView(title: "More Tools", commandLeft: "", commandRight: "", commandLeftTrigger: $commandLeftTrigger, commandRightTrigger: $commandRightTrigger)
           
            
        }
        .frame(height: 40)
        .offset(y: 0)
        .zIndex(1)
        
            ScrollView(.vertical, showsIndicators: false) {
                    
                HStack(spacing: 0) {
                       
                    Button(action: {
                        self.settingsObj.currency = self.settings.currency
                        self.settingsObj.currencyUpdate = self.settings.currencyUpdate
                        self.settingsObj.unit = self.settings.unit
                        self.settingsObj.symbol = self.settings.symbol
                        self.settingsObj.dayChangeMonth = self.settings.dayChangeMonth
                        self.settingsObj.showMonthBalance = self.settings.showMonthBalance
                        self.isShowingSettings = true
                    }) {
                        CardMenu(prompt: "slider.horizontal.3", title: "App Settings")
                    }
                        .sheet(isPresented: self.$isShowingSettings, onDismiss: {
                            
                            saveSettings()
                            
                        }) {
                            SettingsView(settings: $settingsObj, currencies: $currencies)
                            .environmentObject(self.ui)
                                .environmentObject(self.settings)
                        }
                        
                        Spacer()
                        
                    Button(action: {
                        self.isShowingCar = true
                    }) {
                        CardMenu(prompt: "car", title: "Car Management")
                    }
                    .sheet(isPresented: self.$isShowingCar, onDismiss: {
                        if(self.showSubscribeCar == true) {
                            self.showSubscribe = true
                        }
                    }) { ServicesListView(showSubscribe: self.$showSubscribeCar, isShowingCar: self.$isShowingCar)}
                        
                    }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                
                HStack(spacing: 0) {
                       
                    Button(action: {
                       
                        self.isShowingCurrencies = true
                    }) {
                        CardMenu(prompt: "dollarsign.square", title: "Currency Management")
                    }
                        .sheet(isPresented: self.$isShowingCurrencies, onDismiss: {
                            
                            saveCurrency()
                            
                        }) {
                            CurrencyView(currencies: $currencies, viewRefresh: $viewRefresh)
                            .environmentObject(self.ui)
                                .environmentObject(self.settings)
                        }
                        
                        Spacer()
                        
                    Button(action: {
                        self.settingsObj.notificationStock = self.settings.notificationStock
                        self.settingsObj.notificationCrypto = self.settings.notificationCrypto
                        self.settingsObj.notificationPayment = self.settings.notificationPayment
                        self.settingsObj.notificationService = self.settings.notificationService
                        self.isShowingNotification = true
                    }) {
                        CardMenu(prompt: "bell", title: "Notifications")
                    }
                        .sheet(isPresented: self.$isShowingNotification, onDismiss: {
                            
                            saveNotification()
                            
                        }) { NotificationView(settings: $settingsObj)}
                        
                    }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                    
                    HStack(spacing: 0) {
                        
                     
                        
                       
                        
                        Button(action: {
                            if(settings.subscribed) {
                            self.isShowingPassword = true
                            } else {
                                self.showSubscribe = true
                            }
                        }) {
                            CardMenu(prompt: "pencil.and.ellipsis.rectangle", title: "Passwords Encryption")
                        }
                            .sheet(isPresented: self.$isShowingPassword, onDismiss: {
                                
                             
                                                                
                                                            }) {
                                                                PasswordListView()
                                                                .environmentObject(self.ui)
                                                                    .environmentObject(self.settings)
                                                            }
                        
                        Spacer()
                        Button(action: {
                          
                            if(settings.subscribed) {
                            self.isShowing = true
                            } else {
                                self.showSubscribe = true
                            }
                        }) {
                            CardMenu(prompt: "person.3", title: "Split Bill")
                        }
                            .sheet(isPresented: self.$isShowing) { SplitBillsView()}
                            
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    HStack(spacing: 0) {
                        
                        Button(action: {
                            self.isShowingOrdering = true
                        }) {
                            CardMenu(prompt: "rectangle.grid.1x2", title: "Dashboard Cards")
                        }
                            .sheet(isPresented: self.$isShowingOrdering, onDismiss: {
                                
                                saveOrder()
                                
                            }) {
                                OrderingView(items: $orderingItems )
                                .environmentObject(self.ui)
                                    .environmentObject(self.settings)
                            }
                        
                      
                        Spacer()
                        
                        Button(action: {
                            self.isShowingCategory = true
                        }) {
                            CardMenu(prompt: "line.horizontal.3.decrease.circle", title: "Categories")
                        }
                            .sheet(isPresented: self.$isShowingCategory) { CategoryView()}
                        
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                   
               
            }
            .padding(.top, 80)
            
            
            Divider()
        }
        .ignoresSafeArea()
        .edgesIgnoringSafeArea([.top, .bottom])
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        .onAppear() {
            self.onAppear()
        }
          
    
}
    private func saveSettings() {
        
        do {
        let savedSettings =  try viewContext.fetch(settingsFetchRequest)
            
            savedSettings[0].symbol = self.settingsObj.symbol
            savedSettings[0].currency = self.settingsObj.currency
            savedSettings[0].currencyUpdate = self.settingsObj.currencyUpdate
            savedSettings[0].unit = self.settingsObj.unit
            savedSettings[0].dayChangeMonth = self.settingsObj.dayChangeMonth
            savedSettings[0].showMonthBalance = self.settingsObj.showMonthBalance
            
            settings.symbol = self.settingsObj.symbol
            settings.currency = self.settingsObj.currency
            settings.currencyUpdate = self.settingsObj.currencyUpdate
            settings.unit = self.settingsObj.unit
            settings.dayChangeMonth = self.settingsObj.dayChangeMonth
            settings.showMonthBalance = self.settingsObj.showMonthBalance
            
           
            SaveContext()
           
        } catch {
        }
        
    }
    
    private func saveNotification() {
        
        do {
        let savedSettings =  try viewContext.fetch(settingsFetchRequest)
            
            savedSettings[0].notificationStock = self.settingsObj.notificationStock
            savedSettings[0].notificationCrypto = self.settingsObj.notificationCrypto
            savedSettings[0].notificationService = self.settingsObj.notificationService
            savedSettings[0].notificationPayment = self.settingsObj.notificationPayment
            
            settings.notificationStock = self.settingsObj.notificationStock
            settings.notificationCrypto = self.settingsObj.notificationCrypto
            settings.notificationService = self.settingsObj.notificationService
            settings.notificationPayment = self.settingsObj.notificationPayment
            
            SaveContext()
           
        } catch {
        }
        
    }
    
    func saveCurrency() {
        do {
        let savedCurrencies =  try viewContext.fetch(currencyFetchRequest)
            
            for i in 0..<currencies.items.count {
            for index in 0..<savedCurrencies.count {
                let currency = savedCurrencies[index]
                if(currencies.items[i].id == currency.id) {
                currency.rate = currencies.items[i].rate
                    currency.symbol = currencies.items[i].symbol
                    currency.selected = currencies.items[i].selected
                    
                    SaveContext()
                }
            }
            }
            
           
           
        } catch {
        }
    }
    
    private func saveOrder() {
        
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        do {
            let savedCards =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedCards.count {
                                let card = savedCards[index]
                               var order = 0
                                
                                for i in 0..<orderingItems.count {
                                    let cardName = self.orderingItems[i]
                                    if(cardName == card.name) {
                                        order = i
                                    }
                                        }
                                
                                card.order = Int32(order)
                                
                                SaveContext()
                                
                                
                                    }
        } catch {
           
        }
        
    
       
        
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
}

struct CardMenu: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
    let prompt: String
    let title: String

    var body: some View {
          
            
            ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                            .clipped()
                            .shadow(color: colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor,radius: 1, x: 0, y: 0)
                            .padding()

                        VStack {
                            Image(systemName: prompt)
                                .font(ui.title)
                                .padding()
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)

                            Text(LocalizedStringKey(title))
                                .font(.system(size: 15))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                .padding(.bottom, 20)
                        }

                        .frame(width: 150, height: 150)
                        .multilineTextAlignment(.center)
                    }

        
    }
}



//#if DEBUG
//struct MoreView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        MoreView().environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif
