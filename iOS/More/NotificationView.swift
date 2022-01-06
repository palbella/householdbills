//
//  TransactionView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import CoreData


struct NotificationView: View {
   
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var settings: SettingsModel
    
    @Binding var modal: Bool
    @Binding var save: Bool
    
    init(settings: Binding<SettingsModel>, modal: Binding<Bool>, save: Binding<Bool>) {
        self._settings = settings
        self._modal = modal
        self._save = save
        
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
                
           
                    HeaderTabTitleView(title: "Notifications")
        Form {
            
            VStack {
                Toggle("Payments Expiration Day", isOn: $settings.notificationPayment)
                    .padding()
                Toggle("Car Service Required", isOn: $settings.notificationService)
                    .padding()
                Toggle("Cryptocurrency Alert price", isOn: $settings.notificationCrypto)
                    .padding()
                Toggle("Stock Alert price", isOn: $settings.notificationStock)
                    .padding()
            }
          
        }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text("Notifications")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                     
                                            self.modal = false
                                            self.save = true
                                      
                                    }
                }
                                }
        }
        .onAppear(){
            self.onAppear()
        }
        }
        }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
           
    
}
}
   

