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
                
            
                AddPasscodeField( handler:{ pin, result in
                    password = pin
                    return true
                })
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

public struct AddPasscodeField: View {
    
    var maxDigits: Int = 6
    var label = ""
    
    @State var pin: String = ""
    @State var showPin = false
    @State var isDisabled = false
    
    
    var handler: (String, (Bool) -> Void) -> Bool
    
    public var body: some View {
        VStack(spacing: 20) {
            Text(label).font(.title)
            ZStack {
                pinDots
                backgroundField
            }
            showPinStack
        }
        
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 20, weight: .thin, design: .default))
                Spacer()
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
//        return TextField("", text: boundPin, isFirstResponder: true)
//            .frame(width: 0)
        return  TextField("", text: boundPin, onCommit: submitPin)
      
      // Introspect library can used to make the textField become first resonder on appearing
      // if you decide to add the pod 'Introspect' and import it, comment #50 to #53 and uncomment #55 to #61
      
           .accentColor(.clear)
           .foregroundColor(.clear)
           .keyboardType(.numberPad)
           .disabled(isDisabled)
      

    }
    
    private var showPinStack: some View {
        HStack {
            Spacer()
            if !pin.isEmpty {
                showPinButton
            }
        }
        .frame(height: 40)
        .padding([.trailing])
    }
    
    private var showPinButton: some View {
        HStack {
            Spacer()
            Button(action: {
                pin = ""
                isDisabled = false
            }, label: {
                    Image(systemName: "trash.fill").foregroundColor(.primary)

            }).padding(.trailing, 8)
                .padding(.leading, 12)
         
        Button(action: {
            self.showPin.toggle()
        }, label: {
            self.showPin ?
                Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
                Image(systemName: "eye.fill").foregroundColor(.primary)
        }).padding(.leading, 8)
            Spacer()
        }
     
    }
    
    
    private func submitPin() {
        guard !pin.isEmpty else {
            showPin = false
            return
        }
        
        if pin.count == maxDigits {
            isDisabled = true
            
            let result = handler(pin) { isSuccess in
               
            }
            if(!result) {
            pin = ""
            isDisabled = false
            }
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "circle"
        }
        
        if self.showPin {
            return self.pin.digits[index].numberString + ".circle"
        }
        
        return "circle.fill"
    }
}



