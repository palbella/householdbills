//
//  PurchaseAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/2/21.
//

import SwiftUI

struct PurchaseItemAddView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var name: String
    @Binding var amount: Decimal
    @Binding var price: Double
    @Binding var modal: Bool
    @Binding var save: Bool
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    @State var symbol: String = ""
    
    init(name: Binding<String>, amount: Binding<Decimal>, price: Binding<Double> , modal: Binding<Bool>, save: Binding<Bool>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
        
           self._name = name
           self._amount = amount
        self._price = price
        self._modal = modal
        self._save = save
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        
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
            VStack(spacing: 0) {
            
            HeaderTabTitleView(title: "New Purchase")
        Form {

            VStack {

       

                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

            

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $name)
                
                Divider()
                    .padding(5)
                DecimalInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Amount", value: $amount, symbol: self.$symbol)
                Divider()
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Price", value: $price)

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
                Text("New Purchase")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.name != "") {
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

    }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
    }
}
