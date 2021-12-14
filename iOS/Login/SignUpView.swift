//
//  SignUpView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/10/21.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var settings: UserSettings
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
   
    
    @State var emailAddress: String = ""
    @State var name: String = ""
    @State var password: String = ""
    
    var disableForm: Bool {
        !(self.name != "" && self.emailAddress != "" && self.password.count == 6)
    }
    
    var body: some View {

    GeometryReader { geometry in
        VStack (alignment: .center){
            HStack {
                Image(systemName: "house")
                .resizable()
                .frame(width: 15, height: 13)
                Text("Household Bills")
                    .font(.system(size: 12))
                    
            }.padding(.top, 30)
            .padding(.bottom, 10)
            
            Text("Create an Account")
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
                CustomTextfield(label: "Name", text: $name, keyType: UIKeyboardType.alphabet, textAlignment: .left,
                                maxLength: 20)
                        .frame(width: geometry.size.width - 45, height: 50)
                        .textContentType(.emailAddress)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        .accentColor(.red)
                        .background(colorScheme != .dark ? Color(UIColor.systemGray6): Color(UIColor.systemGray2))
                        .cornerRadius(5)
            
                CustomTextfield(label: "Email", text: $emailAddress, keyType: UIKeyboardType.alphabet, textAlignment: .left,
                                maxLength: 20)
                    .frame(width: geometry.size.width - 45, height: 50)
                    .textContentType(.emailAddress)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    .accentColor(.red)
                    .background(colorScheme != .dark ? Color(UIColor.systemGray6): Color(UIColor.systemGray2))
                    .cornerRadius(5)
                
            
                PasscodeField( handler:{ pin, result in
                    password = pin
                    return true
                })
                    .padding(.top, 20)
                    .padding(.bottom, 20)
            }

            Text("Terms of Service and Privacy Policy")
                .foregroundColor(ui.lightPrimaryColor)
                .padding(.bottom, 40)
                .font(.system(size: 12))
            
         
            
            Button(action: {
               
                    InitialData(viewContext: viewContext).run(password: password, name: name, email: emailAddress)
                settings.name = name
                settings.password = password
                settings.email = emailAddress
                settings.showMonthBalance = true
                    settings.welcome = false
                
            }) {
                HStack {
                    Text("Create Account")
                }
                .padding()
                .frame(width: geometry.size.width - 40, height: 40)
                .foregroundColor(Color.white)
                .background(ui.lightPrimaryColor)
                .cornerRadius(5)
            }.padding(.bottom, 40)
                .disabled(disableForm)

            
            Spacer()
            
        }
    }
    }
    
}
