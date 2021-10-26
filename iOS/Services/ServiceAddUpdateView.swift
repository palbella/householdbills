//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


struct ServiceAddUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var service: ServiceModel
    @Binding var unit: String
    
    @Binding var modal: Bool
    @Binding var delete: Bool?
    
    @State var unitName: String = ""
    @State var monthLabel: String = ""
    
    
    init(service: Binding<ServiceModel>, unit: Binding<String> , modal: Binding<Bool>, delete: Binding<Bool?>) {
        
           self._service = service
           self._unit = unit
        self._modal = modal
        self._delete = delete
        
        
        UINavigationBar.appearance().isTranslucent = false
       }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        if(self.$unit.wrappedValue == "Km") {
            self.unitName = "Kilometers"
        } else {
            self.unitName = "Miles"
        }
    }

    var body: some View {
       
        NavigationView {
        Form {
            
            VStack {
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

             
                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $service.name)
                NumericInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Every " + self.unitName, value: $service.amount, symbol: $unit)
                NumericInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Every Months", value: $service.months, symbol: $monthLabel)

                
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
                Text("Car Service")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
        }
        .onAppear(){
            self.onAppear()

        }
        
    }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        
        
    }
    
}
