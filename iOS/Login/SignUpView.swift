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
    @State var showTerms = false
    
    @State var isShowingToast: Bool = false
    @State var toastMessasge: String = ""
    @State var toastError: Bool = false
    @State var agreeTerms: Bool = false
    
    var disableForm: Bool {
        !(self.name != "" && self.emailAddress != "" && self.password.count == 6)
    }
    
    var body: some View {
        if(!showTerms) {
    GeometryReader { geometry in
        VStack (alignment: .center){
            HStack {
                Image(systemName: "house")
                .resizable()
                .frame(width: 15, height: 13)
                Text("Household Bills")
                    .font(.system(size: 12))
                    
            }.padding(.top, 20)
            .padding(.bottom, 10)
            
            Text("Create an Account")
                .font(.title)
                .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                .padding(.bottom, 40)
            
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

            Button(action: {
                self.showTerms = true
            }) {
                Text("Terms of Service and Privacy Policy")
                    .foregroundColor(ui.lightPrimaryColor)
                    .padding(.bottom, 40)
                    .font(.system(size: 12))
            }
            HStack {
                Spacer()
                if(self.agreeTerms != true) {
                    Icon(content: "multiply", color: Color.red)
                        .padding(.bottom, 15)
                } else {
                    Icon(content: "checkmark", color: Color.green)
                        .padding(.bottom, 15)
                }
                Button(action: {
                    self.agreeTerms = !self.agreeTerms
                }) {
                    Text("Agree Terms & Policy")
                        .foregroundColor(colorScheme != .dark ? Color.black : Color.white)
                        .font(.system(size: 15))
                        .padding(.bottom, 15)
                }
                Spacer()
            }
         
            
         
            
            Button(action: {
                if(self.agreeTerms == true) {
                if(password != "" && name != "" && emailAddress != "") {
                    InitialData(viewContext: viewContext).run(password: password, name: name, email: emailAddress)
                settings.name = name
                settings.password = password
                settings.email = emailAddress
                settings.showMonthBalance = true
                    settings.welcome = false
                } else {
                    self.toastMessasge = LocalizedStringKey("Name, Email and Password is required").toString()
                    self.isShowingToast = true
                    self.toastError = true
                }
                } else {
                    self.toastMessasge = "Agree Terms and Policies"
                    self.isShowingToast = true
                    self.toastError = true
                }
                
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
           

            
            Spacer()
            
        }
    }
    .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        } else {
            TermsView(back: self.$showTerms)
        }
    }
    
}
