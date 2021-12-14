//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


struct CarAddView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var car: CarModel
    @Binding var modal: Bool
    @Binding var save: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @ObservedObject var units = GetUnits()
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(car: Binding<CarModel>, modal: Binding<Bool>, save: Binding<Bool>,
         isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool> ) {
        
           self._car = car
        self._modal = modal
        self._save = save
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
            
            HeaderTabTitleView(title: "New Car")
        Form {
            
            VStack {
                
                let amountColor = car.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

                NumericField(
                    "Amount", symbol: car.symbol, 
                            value: Binding(get: {
                                return Decimal(car.amount) as NSDecimalNumber
                            }, set: { number in
                                var result: Double = 0
                                if(number != nil) {
                                    result = Double(truncating: number!.int32Value as NSNumber).truncate(places: 0)
                                }

                                car.amount = Int32(result)
                            }),
                    foregroundColor: UIColor(amountColor),
                    font: ui.subtitle,
                    textAlignment: .center
                        )
                .padding()

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $car.name)
        
            

                
            }
            
                        Picker("Icon", selection: $car.iconContent) {
                            ForEach(icons.items) { icon in
                                Text(icon.name).tag(icon.content)
                                }
                                    }
                        .padding()
                        
                    
                       
                        Picker("Color", selection: $car.iconColor) {
                            ForEach(colors.items) { color in
                                Text(color.name).tag(color.content)
                                }
                                    }
                        .padding()
            
            Picker("Unit", selection: $car.symbol) {
                ForEach(units.items) { item in
                    Text(item.name).tag(item.content)
                    }
                        }
            .padding()
            
    
      
    }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text("New Car")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.car.name != "") {
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
        
    }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        
    }
    
}
