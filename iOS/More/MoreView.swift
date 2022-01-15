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
    
    @State var isShowingSplit: Bool = false
    @State var isShowingSettings: Bool = false
    @State var isShowingOrdering: Bool = false
    @State var isShowingCar: Bool = false
    @State var isShowingCategory: Bool = false
    @State var isShowingCurrencies: Bool = false
    @State var isShowingPassword: Bool = false
    @State var isShowingNotification: Bool = false
    @State var isShowingFeedback: Bool = false
    @State var isShowingEI: Bool = false
    @State var isShowingAPI: Bool = false
    
    @State var settingsObj: SettingsModel = SettingsModel()
    @State var api: APIModel = APIModel()
  
    @ObservedObject var apiData = APIData()
    
    @State var orderingItems : [String] = []
    
    let settingsFetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
    let currencyFetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
    
    @State var viewRefresh : Int = 0
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = CurrencyData()
    @State var currencyData = CurrencyData()
    @State var commandLeftTrigger: Bool = false
    @State var commandRightTrigger: Bool = false
    
    @Binding var showSubscribe: Bool
    @State var showSubscribeCar: Bool = false
    @State var save: Bool = false
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    @Binding var isShowingPopup: Bool
    @Binding var popupMessasge: String
    @Binding var popupTitle: String
    @Binding var popupImage: String
    
    @State private var isImporting: Bool = false
       @State private var fileContentString = ""
       @State var alertMsg = ""
       @State var showAlert = false

    func onAppear() {
        self.currencies.items = fetchCurrencies.fetch(includeNotSelected: true)
       
        
    }
    
    
    var body: some View {
        
        VStack(spacing: 0) {
        
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
                        self.settingsObj.fastApply = self.settings.fastApply
                        self.isShowingSettings = true
                        self.save = false
                    }) {
                        CardMenu(prompt: "slider.horizontal.3", title: "App Settings")
                    }
                        .sheet(isPresented: self.$isShowingSettings, onDismiss: {
                            if(self.settingsObj.fastApply || self.save) {
                            saveSettings()
                            }
                        }) {
                            SettingsView(settings: $settingsObj, currencies: $currencies, modal: $isShowingSettings, save: $save)
                            .environmentObject(self.ui)
                                .environmentObject(self.settings)
                        }
                        
                        Spacer()
                        
                    Button(action: {
                        self.settingsObj.fastApply = self.settings.fastApply
                        self.settingsObj.notificationStock = self.settings.notificationStock
                        self.settingsObj.notificationCrypto = self.settings.notificationCrypto
                        self.settingsObj.notificationPayment = self.settings.notificationPayment
                        self.settingsObj.notificationService = self.settings.notificationService
                        self.isShowingNotification = true
                        self.save = false
                    }) {
                        CardMenu(prompt: "bell", title: "Notifications")
                    }
                        .sheet(isPresented: self.$isShowingNotification, onDismiss: {
                            if(self.settingsObj.fastApply || self.save) {
                            saveNotification()
                            }
                        }) { NotificationView(settings: $settingsObj, modal: $isShowingNotification, save: $save)}
                        
                    }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                
                HStack(spacing: 0) {
                       
                    Button(action: {
                        self.save = false
                        self.isShowingCurrencies = true
                    }) {
                        CardMenu(prompt: "dollarsign.square", title: "Currency Management")
                    }
                        .sheet(isPresented: self.$isShowingCurrencies, onDismiss: {
                            if(self.settings.fastApply || self.save) {
                            saveCurrency()
                            }
                        }) {
                            CurrencyView(currencies: $currencies, viewRefresh: $viewRefresh, modal: $isShowingCurrencies, save: $save)
                                .environmentObject(self.ui)
                                    .environmentObject(self.settings)
                          
                        }
                        
                        Spacer()
                        
                    
                    Button(action: {
                        self.save = false
                        self.isShowingCar = true
                    }) {
                        CardMenu(prompt: "car", title: "Car Management")
                    }
                    .sheet(isPresented: self.$isShowingCar, onDismiss: {
                        if(self.showSubscribeCar == true) {
                            self.showSubscribe = true
                        }
                    }) { ServicesListView(showSubscribe: self.$showSubscribeCar, isShowingCar: self.$isShowingCar, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)}
                        
                    }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                    
                    HStack(spacing: 0) {
                        
                     
                        
                       
                        
                        Button(action: {
                            self.save = false
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
                                                                PasswordListView(listModal: $isShowingPassword, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                                                                .environmentObject(self.ui)
                                                                    .environmentObject(self.settings)
                                                            }
                        
                        Spacer()
                        Button(action: {
                            self.save = false
                            if(settings.subscribed) {
                            self.isShowingSplit = true
                            } else {
                                self.showSubscribe = true
                            }
                        }) {
                            CardMenu(prompt: "person.3", title: "Split Bill")
                        }
                            .sheet(isPresented: self.$isShowingSplit) {
                                SplitBillsView(modal: $isShowingSplit, save: $save)
                                    .environmentObject(self.ui)
                                        .environmentObject(self.settings)
                            }
                            
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    HStack(spacing: 0) {
                        
                        Button(action: {
                            self.save = false
                            self.isShowingOrdering = true
                        }) {
                            CardMenu(prompt: "rectangle.grid.1x2", title: "Dashboard Cards")
                        }
                            .sheet(isPresented: self.$isShowingOrdering, onDismiss: {
                                if(self.settings.fastApply || self.save) {
                                saveOrder()
                                }
                            }) {
                                OrderingView(items: $orderingItems, modal: $isShowingOrdering, save: $save )
                                .environmentObject(self.ui)
                                    .environmentObject(self.settings)
                            }
                        
                      
                        Spacer()
                        
                        Button(action: {
                            self.save = false
                            self.isShowingCategory = true
                        }) {
                            CardMenu(prompt: "line.horizontal.3.decrease.circle", title: "Categories")
                        }
                            .sheet(isPresented: self.$isShowingCategory) {
                                CategoryView(modal: $isShowingCategory, save: $save)
                                    .environmentObject(self.ui)
                                        .environmentObject(self.settings)
                            }
                        
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                
                HStack(spacing: 0) {
                    
                    Button(action: {
//                        EmailHelper.shared.send(subject: "SwiftMail", body: "Test", to: ["aaa@gmail.com"])
                        self.save = false
                        self.isShowingFeedback = true
                    }) {
                        CardMenu(prompt: "hand.thumbsup", title: "Feedback")
                    }
                        .sheet(isPresented: self.$isShowingFeedback, onDismiss: {
                            if(self.save) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    EmailHelper.shared.send(subject: "Household Bills Feedback", body: "Share with us your experience...", to: ["householdbills.app@gmail.com"])
                                }
                         
                               
                            }
                        }) {
                            FeedbackView(modal: $isShowingFeedback, save: $save )
                            .environmentObject(self.ui)
                                .environmentObject(self.settings)
                        }
                    
                  
                    Spacer()
                    
                    Button(action: {
                        self.save = false
                        self.isShowingAPI = true
                        self.api = self.apiData.get()
                    }) {
                        CardMenu(prompt: "icloud.and.arrow.down", title: "API")
                    }
                        .sheet(isPresented: self.$isShowingAPI, onDismiss: {
                            if(self.settings.fastApply || self.save) {
                                self.apiData.update(api: self.api)
                            }
                        }) {
                            APIView(modal: $isShowingAPI, save: $save, model: self.$api)
                                .environmentObject(self.ui)
                                    .environmentObject(self.settings)
                        }
                    
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                   
                HStack(spacing: 0) {
                    
                    Button(action: {
                        if(settings.subscribed) {
                            self.exportData()
                        } else {
                            self.showSubscribe = true
                        }
                        
                    }) {
                        CardMenu(prompt: "tray.and.arrow.up", title: "Export")
                    }
                    
                  
                    Spacer()
                    
                    Button(action: {
                        if(settings.subscribed) {
                            self.isImporting = true
                        } else {
                            self.showSubscribe = true
                        }
                        
                    }) {
                        CardMenu(prompt: "tray.and.arrow.down", title: "Import")
                    }
                    
                    
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .fileImporter(
                            isPresented: $isImporting,
                            allowedContentTypes: [.commaSeparatedText],
                            allowsMultipleSelection: false
                        ) { result in
                            self.importData(result: result)
                        }
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Message"), message: Text(alertMsg), dismissButton: .destructive(Text("OK"), action: {
                                
                            }))
                        })
               
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
    
    func exportData() {
        
        let task: ExportImportTask = ExportImportTask()
        
            let file_name = "householdBills.csv" // my file name
            let path = NSURL(fileURLWithPath:
            NSTemporaryDirectory()).appendingPathComponent(file_name) // Where the file    will be saved temporary in your ios device
         
        let csvHead = task.exportData(csv: "")
          
            do {
                try csvHead.write(to: path!, atomically: true, encoding: .utf8)
                let exportSheet = UIActivityViewController(activityItems: [path as Any], applicationActivities: nil)

                UIApplication.shared.windows.first?.rootViewController?.present(exportSheet, animated: true, completion: nil)

                print("Exported")
              
                self.toastMessasge = LocalizedStringKey("Data Exported").toString()
                self.isShowingToast = true
                self.toastError = false
                
            } catch {}
                                                                       
    }
    
    func importData(result: Result<[URL], Error>) {
        
        let task: ExportImportTask = ExportImportTask()
        
        do {
            guard let selectedFileURL: URL = try result.get().first else {
                alertMsg = "ERROR: Result.get() failed"
                return
                
            }
            print("selectedFileURL is \(selectedFileURL)")
            
            if selectedFileURL.startAccessingSecurityScopedResource() {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: selectedFileURL.path) {
                    print("FILE AVAILABLE")
                } else {
                    print("FILE NOT AVAILABLE")
                    self.toastMessasge = LocalizedStringKey("File Not Available").toString()
                    self.isShowingToast = true
                    self.toastError = true
                }
                
                var error: NSError?
                
                NSFileCoordinator().coordinate(
                    readingItemAt: selectedFileURL, options: .forUploading, error: &error) { url in
                    
                    do {
                        let resources = try selectedFileURL.resourceValues(forKeys:[.fileSizeKey])
                        let fileSize = resources.fileSize!
                        print ("File Size is \(fileSize)")
                    } catch {
                        print("Error: \(error)")
                        self.toastMessasge = LocalizedStringKey("Import Error").toString()
                        self.isShowingToast = true
                        self.toastError = true
                    }
                }
                
                do {
                    print("Getting Data from URL...")
                    task.importData(url: selectedFileURL)
                    self.toastMessasge = LocalizedStringKey("Data Imported").toString()
                    self.isShowingToast = true
                    self.toastError = false
                }
            } else {
                // Handle denied access
                alertMsg = "ERROR: Unable to read file contents - Access Denied"
                print(alertMsg)
                self.toastMessasge = LocalizedStringKey("Import Error").toString()
                self.isShowingToast = true
                self.toastError = true
            }
        } catch {
            // Handle failure.
            alertMsg = "ERROR: Unable to read file contents - \(error.localizedDescription)"
            print(alertMsg)
            self.toastMessasge = LocalizedStringKey("Import Error").toString()
            self.isShowingToast = true
            self.toastError = true
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
            savedSettings[0].fastApply = self.settingsObj.fastApply
            
            settings.symbol = self.settingsObj.symbol
            settings.currency = self.settingsObj.currency
            settings.currencyUpdate = self.settingsObj.currencyUpdate
            settings.unit = self.settingsObj.unit
            settings.dayChangeMonth = self.settingsObj.dayChangeMonth
            settings.showMonthBalance = self.settingsObj.showMonthBalance
            settings.fastApply = self.settingsObj.fastApply
           
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
            self.currencyData.currencyUpdate()
           
           
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
