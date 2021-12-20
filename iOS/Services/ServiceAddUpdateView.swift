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
    @Binding var save: Bool
    @Binding var action: String
    @Binding var delete: Bool?
    
    @State var unitName: String = ""
    @State var monthLabel: String = ""
    
    @State private var showConfirm = false
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    
    init(service: Binding<ServiceModel>, unit: Binding<String> , modal: Binding<Bool>, save: Binding<Bool>, action: Binding<String>, delete: Binding<Bool?>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
        
           self._service = service
           self._unit = unit
        self._save = save
        self._modal = modal
        self._action = action
        self._delete = delete
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
        
        if(self.$unit.wrappedValue == "Km") {
            self.unitName = "Kilometers"
        } else {
            self.unitName = "Miles"
        }
    }

    var body: some View {
       
        NavigationView {
            VStack(spacing:0) {
                HeaderTabTitleView(title: "Car Service")
        Form {
            
            VStack {
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

             
                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, maxLength: 20, label: "Name", value: $service.name)
                NumericInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Every " + self.unitName, value: $service.amount, symbol: $unit)
                NumericInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Every Months", value: $service.months, symbol: $monthLabel)

                
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
                Text("Car Service")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.service.name != "") {
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
        .onAppear(){
            self.onAppear()

        }
                
                if(action == "edit") {
            Divider()
        Button(action: {
            self.showConfirm = true
        }) {
            Text("Delete Car Service")
               .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        }
        .padding()
                }
            }
        
    }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        
    }
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Car Service?"), message: Text("Are you sure you want to delete this car service?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}
