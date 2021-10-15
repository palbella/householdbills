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
    

    
    init(settings: Binding<SettingsModel>) {
        self._settings = settings
        
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
        
   
        
        NavigationView {
            
        Form {
            
            VStack {
                Toggle("Payments Expiration Day", isOn: $settings.notificationPayment)
                    .padding()
                Toggle("Car Service Required", isOn: $settings.notificationService)
                    .padding()
                Toggle("Cryptocurrency Alert price", isOn: $settings.notificationCrypto)
                    .padding()
//                Toggle("Is Paid", isOn: $settings.notificationStock)
//                    .padding()
            }
          
        }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Notifications")
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
}
   

