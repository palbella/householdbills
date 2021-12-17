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
    @Binding var save: Bool
    @Binding var action: String
    @Binding var delete: Bool?
    @State var symbol: String = ""
    @State var code: Int32 = 0
    
    @State private var showConfirm = false
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(password: Binding<PasswordModel> , modal: Binding<Bool>, save: Binding<Bool>, delete: Binding<Bool?>, action: Binding<String>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
        
           self._password = password
        self._modal = modal
        self._save = save
        self._delete = delete
        self._action = action
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
            VStack(spacing:0) {
                HeaderTabTitleView(title: "Passwords")
        Form {
            
            VStack {
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor


                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "App", value: $password.name)
                
             
                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Password", value: $password.password)
                
                
                PinInput(label: "Encription Code", value: $password.code)
             
            }
            .buttonStyle(BorderlessButtonStyle())

      
    }
      
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text("Password")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.password.code != "" && self.password.name != "" && self.password.password != "") {
                                            self.modal = false
                                            self.save = true
                                        } else {
                                            self.toastMessasge = "Name, Password and Code is required"
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
            Text("Delete Password")
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
        Alert(title: Text("Delete Password?"), message: Text("Are you sure you want to delete this password?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}
