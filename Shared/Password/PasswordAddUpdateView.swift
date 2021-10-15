//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


struct PasswordAddUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var password: PasswordModel
    
    @Binding var modal: Bool
    @Binding var action: String
    @Binding var delete: Bool?
    @State var symbol: String = ""
    @State var code: Int32 = 0
    
    @State private var showConfirm = false
    
    init(password: Binding<PasswordModel> , modal: Binding<Bool>, delete: Binding<Bool?>, action: Binding<String>) {
        
           self._password = password
        self._modal = modal
        self._delete = delete
        self._action = action
        
        
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
            VStack(spacing:0) {
        Form {
            
            VStack {
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor


                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "App", value: $password.name)
                
             
                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Password", value: $password.password)
                
                
                NumericInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Encription Code", value: $password.code, symbol: $symbol)
             
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
                Text("Passwords")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
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
            Text("Delete Password")
               .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        }
        .padding()
                }
     
        }
        
    }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        
        
    }
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Password?"), message: Text("Are you sure you want to delete this password?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}
