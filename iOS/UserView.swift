//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
  
  
    @State var settingsData : SettingsData = SettingsData()
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
    var body: some View {
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
     
        GeometryReader { geometry in
            NavigationView {
            VStack (alignment: .center){
                HStack {
                    Image(systemName: "house")
                    .resizable()
                    .frame(width: 15, height: 13)
                    Text("Household Bills")
                        .font(.system(size: 12))
                        
                }.padding(.top, 30)
                .padding(.bottom, 10)
                
                Text("Edit Account")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 50)
                
    //            Button(action: {
    //                print("Add photo")
    //            }) {
    //                VStack(alignment: .center) {
    //                    Text("+")
    //                    .font(.system(size: 18))
    //                    Text("Add Photo")
    //                        .font(.system(size: 10))
    //                }.padding()
    //                .frame(width: 100, height: 100)
    //                .foregroundColor(Color.white)
    //                .background(Color.blue)
    //            }
    //            .clipShape(Circle())
    //            .padding(.bottom, 10)
                
                VStack {
                    
                    CustomTextfield(label: "Name", text: $settings.name, keyType: UIKeyboardType.alphabet, textAlignment: .left,
                                    maxLength: 20)
                            .frame(width: geometry.size.width - 45, height: 50)
                            .textContentType(.emailAddress)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                            .accentColor(.red)
                            .background(colorScheme != .dark ? Color(UIColor.systemGray6): Color(UIColor.systemGray2))
                            .cornerRadius(5)
                
                    CustomTextfield(label: "Email", text: $settings.email, keyType: UIKeyboardType.alphabet, textAlignment: .left,
                                    maxLength: 20)
                        .frame(width: geometry.size.width - 45, height: 50)
                        .textContentType(.emailAddress)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        .accentColor(.red)
                        .background(colorScheme != .dark ? Color(UIColor.systemGray6): Color(UIColor.systemGray2))
                        .cornerRadius(5)
                    
                
                    AddPasscodeField( handler:{ pin, result in
                        settings.password = pin
                        return true
                    })
                }

                Text("Terms of Service and Privacy Policy")
//                    .foregroundColor(ui.lightPrimaryColor)
                    .padding(.bottom, 40)
                    .font(.system(size: 12))
                
                NavigationLink(destination:
                                VStack{
                    VStack {
                        Text("")
                            .padding(.bottom, 100)
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "questionmark.circle", iconColor: .blue, label: "Question 1", value: $settings.passwordQuestion1)
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Answer 1", value: $settings.passwordAnswer1)
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "questionmark.circle", iconColor: .blue, label: "Question 2", value: $settings.passwordQuestion2)
                   TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Answer 2", value: $settings.passwordAnswer2)
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "questionmark.circle", iconColor: .blue, label: "Question 3", value: $settings.passwordQuestion3)
                   TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Answer 3", value: $settings.passwordAnswer3)
                    }
                    .padding(.bottom, 300)
                    Spacer()
                    Text("")
                 
                }
                              
                               
                    ) {
                    Text("Settings Recovery Password")
                }
                .padding()
                .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                
                Button(action: {
                    self.settingsData.updateSettings(settings: settings)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Save Account")
                    }
                    .padding()
                    .frame(width: geometry.size.width - 40, height: 40)
                    .foregroundColor(Color.white)
                    .background(ui.lightPrimaryColor)
                    .cornerRadius(5)
                }.padding(.bottom, 40)
//                    .disabled(!(self.settings.name != "" && self.settings.email != "" && self.settings.password.count == 6))

                
                Spacer()
                
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                self.onAppear()
            }
        }
            .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        }
    }

    func saveAccount() {
        
    }

}


//#if DEBUG
//struct TransactionsBodyView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        TransactionsBodyView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//
//    }
//}
//#endif
