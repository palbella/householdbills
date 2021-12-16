//
//  HouseholdBillsApp.swift
//  Shared
//
//  Created by Pablo Albella on 8/15/21.
//
import SwiftUI
import Combine
import CoreData
import UserNotifications


class UserSettings: ObservableObject {
    @Published var loggedIn : Bool = false
    @Published var welcome : Bool = true
    @Published var subscribed : Bool = true
    @Published var navigateNowToLogIn: Bool = false
    @Published var navigateNowToSignup: Bool = false
    @Published var currencyUpdate: Bool = false
    @Published var fastApply: Bool = false
    @Published var lastLogin: Date? = nil
    @Published var currency: String = "USD"
    @Published var symbol: String = "$"
    @Published var unit: String = "Km"
    @Published var password : String = "kdhfkjsfhkjoweuyrowujxvn"
    @Published var name : String = ""
    @Published var email : String = ""
    @Published var estimatedMontlyIncomes: Double = 0
    @Published var dayChangeMonth: Int32 = 28
    @Published var notificationStock: Bool = false
    @Published var notificationCrypto: Bool = false
    @Published var notificationService: Bool = false
    @Published var notificationPayment: Bool = false
    @Published var showMonthBalance: Bool = false
    @Published var passwordQuestion1 : String = ""
    @Published var passwordQuestion2 : String = ""
    @Published var passwordQuestion3 : String = ""
    @Published var passwordAnswer1 : String = ""
    @Published var passwordAnswer2 : String = ""
    @Published var passwordAnswer3 : String = ""
}

class AppUI: ObservableObject {
    @Published var lightBackgroundColor : Color = Color(UIColor.systemGray6) //Color(UIColor(red: 252,green: 252,blue: 252))
    @Published var darkBackgroundColor : Color = Color(UIColor.systemBackground)
    @Published var lightDashboardHeadColor : Color = Color.white //Color(UIColor(red: 1,green: 80,blue: 80))
    @Published var darkDashboardHeadColor : Color = Color(UIColor.systemGray6)
    @Published var lightItemBackgroundColor : Color = Color.white
    @Published var darkItemBackgroundColor : Color = Color(UIColor.systemGray6)
    @Published var lightItemFontColor : Color = Color.black
    @Published var darkItemFontColor : Color = Color(UIColor.white)
    @Published var lightFieldFontColor : Color = Color(UIColor.systemGray)
    @Published var darkFieldFontColor : Color = Color(UIColor.systemGray)
    @Published var lightItemFontAmountColor : Color = Color(UIColor(red: 2,green: 179,blue: 0)) //  Color(UIColor(red: 1,green: 80,blue: 50))
    @Published var darkItemFontAmountColor : Color = Color(UIColor(red: 2,green: 179,blue: 0))
    @Published var lightItemNegativeFontAmountColor : Color = Color.red
    @Published var darkItemNegativeFontAmountColor : Color = Color.red
    @Published var lightFontColor : Color = Color(UIColor(red: 2,green: 179,blue: 0))
    @Published var darkFontColor : Color = Color(UIColor(red: 2,green: 179,blue: 0))
    @Published var lightPrimaryColor : Color = Color(UIColor(red: 2,green: 179,blue: 0))
    @Published var darkPrimaryColor : Color = Color(UIColor(red: 2,green: 179,blue: 0))
    @Published var lightMainBackgroundColor : Color = Color.white
    @Published var darkMainBackgroundColor : Color = Color(UIColor.black)
    @Published var lightCommandFontColor : Color = Color(UIColor.systemGray)
    @Published var darkCommandFontColor : Color = Color(UIColor.systemGray)
    @Published var headerHeight: CGFloat = 100
    @Published var itemHeight: CGFloat = 40
    @Published var title: Font = Font.system(size: 20)
    @Published var subtitle: Font = .title2 // Font.system(size: 50, weight: .bold)
}



@main
struct HouseholdBillsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Environment(\.colorScheme) var colorScheme
    
   let persistenceController = PersistenceController.shared
    let settings = UserSettings()
    let appUI = AppUI()
    
    
    let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
   


    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(settings)
                .environmentObject(appUI)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    dataStart()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    dataStart()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    dataStart()
                    }
        }
        
    }
    
    
    func dataStart() {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        }


        do {
        let savedSettings =  try persistenceController.container.viewContext.fetch(fetchRequest)

            if(savedSettings.count == 0) {
                self.settings.welcome = true
            } else {
              
                self.settings.welcome = false
                self.settings.password = savedSettings[0].password!
                self.settings.symbol = savedSettings[0].symbol!
                self.settings.currency = savedSettings[0].currency!
                self.settings.currencyUpdate = savedSettings[0].currencyUpdate
                self.settings.name = savedSettings[0].name!
                self.settings.email = savedSettings[0].email!
                self.settings.unit = savedSettings[0].unit!
                self.settings.estimatedMontlyIncomes = savedSettings[0].monthIncome
                self.settings.fastApply = savedSettings[0].fastApply
//                self.settings.subscribed = savedSettings[0].subscribed
                self.settings.dayChangeMonth = savedSettings[0].dayChangeMonth
                self.settings.showMonthBalance = savedSettings[0].showMonthBalance
                self.settings.notificationStock = savedSettings[0].notificationStock
                self.settings.notificationCrypto = savedSettings[0].notificationCrypto
                self.settings.notificationPayment = savedSettings[0].notificationPayment
                self.settings.notificationService = savedSettings[0].notificationService
                
                self.settings.passwordQuestion1 = savedSettings[0].passwordQuestion1 ?? ""
                self.settings.passwordQuestion2 = savedSettings[0].passwordQuestion2 ?? ""
                self.settings.passwordQuestion3 = savedSettings[0].passwordQuestion3 ?? ""
                self.settings.passwordAnswer1 = savedSettings[0].passwordAnswer1 ?? ""
                self.settings.passwordAnswer2 = savedSettings[0].passwordAnswer2 ?? ""
                self.settings.passwordAnswer3 = savedSettings[0].passwordAnswer3 ?? ""

            }

            runTasks() // If subscribe
            

        } catch {
        }
    }


    func runTasks() {
        BackgroundThreadTask().scheduleAppRefresh()
        DailyBalanceTask(viewContext: persistenceController.container.viewContext, settings: settings).run()
        GetCarAlerts(viewContext: persistenceController.container.viewContext).run()
        GetMarketCriptocurrencies(viewContext: persistenceController.container.viewContext).run()
        GetMarketStocks(viewContext: persistenceController.container.viewContext).run()
        if(settings.currencyUpdate == true) {
        CurrencyTask(viewContext: persistenceController.container.viewContext).run()
        }
    }


}


struct StartView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var appUI: AppUI

    var body: some View {
        if (settings.welcome) {
            return AnyView(WelcomeView())
        } else {
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .minute, value: -30, to: Date())
            if (settings.loggedIn && settings.lastLogin != nil && settings.lastLogin! > date!){
                return AnyView(MainView())
            }else {
                return AnyView(LogInView())
            }
        }
       
    }
}

//#if DEBUG
//struct StartView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        StartView()
//            .environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif
