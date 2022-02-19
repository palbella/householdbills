//
//  LoginView.swift
//  Household Bills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import LocalAuthentication


import SwiftUI

struct LogInView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
 
    @State  private var answer1: String = ""
    @State  private var answer2: String = ""
    @State  private var answer3: String = ""
    @State  private var emailAddress: String = ""
    @State  private var password: String = ""
    
    var body: some View {
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
        
    GeometryReader { geometry in
        NavigationView {
            VStack (alignment: .center){
                Spacer()
                HStack {
                    Image(systemName: "house")
                    .resizable()
                    .frame(width: 15, height: 13)
                    Text("Household Bills")
                        .font(.system(size: 12))
                        
                }.padding(.top, 30)
                .padding(.bottom, 10)
                
                Text("Log Into Your Account")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 50)
                
                
                LoginPasscodeField( handler:{ pin, result in
                    let result = pin == settings.password
                    
                    self.password = pin
                   
                    if(result) {
                        settings.loggedIn = true
                        settings.lastLogin = Date()
                    }
                    return result
                })
                

                
                 Button(action: {
                     if(self.password == settings.password) {
                         settings.loggedIn = true
                         settings.lastLogin = Date()
                     }
                 }) {
                        HStack {
                            Text("Log In")
                        }
                            .padding()
                            .frame(width: geometry.size.width - 40, height: 40)
                            .foregroundColor(Color.white)
                            .background(ui.lightPrimaryColor)
                            .cornerRadius(5)
                    }
                     .padding(.bottom, 40)
                
                Spacer()
                Divider()
                
                
                NavigationLink(destination:
                              
                    VStack {
                   
                    VStack {
                    Divider()
                        Text(settings.passwordQuestion1)
                            .padding(.top, 10)
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Answer 1", value: $answer1)
                    Divider()
                        Text(settings.passwordQuestion2)
                            .padding(.top, 10)
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Answer 2", value: $answer2)
                    Divider()
                        Text(settings.passwordQuestion3)
                            .padding(.top, 10)
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Answer 3", value: $answer3)
                    Divider()
                    }
                 
                        
                        Button(action: {
                            if(answer1 == settings.passwordAnswer1 && answer2 == settings.passwordAnswer2 && answer3 == settings.passwordAnswer3 && settings.passwordAnswer1 != ""  && settings.passwordAnswer2 != "" && settings.passwordAnswer3 != "") {
                                settings.loggedIn = true
                                settings.lastLogin = Date()
                            }
                        }) {
                               HStack {
                                   Text("Log In")
                               }
                                   .padding()
                                   .frame(width: geometry.size.width - 40, height: 40)
                                   .foregroundColor(Color.white)
                                   .background(ui.lightPrimaryColor)
                                   .cornerRadius(5)
                           }
                            .padding(.top, 20)
                   
                    }
                                .frame(height: 200)
                    
                          
                
                 
             
                              
                               
                    ) {
                    if(settings.welcome != true) {
                       
                    Text("Forgot your password?")
                    }
                }
                .padding()
                .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)

                
               
                
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: authenticate)
           
            }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
    }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        settings.loggedIn = true
                        settings.lastLogin = Date()
                    } else {
                        settings.loggedIn = false
                        settings.lastLogin = nil
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}





public struct LoginPasscodeField: View {
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    var maxDigits: Int = 6
    
    @State var pin: String = ""
    @State var showPin = false
    @State var isDisabled = false
    
    
    var handler: (String, (Bool) -> Void) -> Bool
    
    public var body: some View {
        VStack(spacing: 20) {
          
            ZStack {
                Text("Type below to introduce password")
                    .foregroundColor(ui.lightCommandFontColor)
                    .padding(.top, -50)
                    .font(.system(size: 12))
                
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
        
        return PassCodeField(text: boundPin, isFirstResponder: true)
            .frame(width: 0)
//        return  TextField("", text: boundPin, onCommit: submitPin)
      
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
            self.showPin.toggle()
        }, label: {
            self.showPin ?
                Image(systemName: "eye.slash.fill").foregroundColor(.primary).padding(.leading, 8) :
                Image(systemName: "eye.fill").foregroundColor(.primary).padding(.leading, 8)
        })
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

extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}


struct PassCodeField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

    }

    @Binding var text: String
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<PassCodeField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textColor = .clear
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
        return textField
    }

    func makeCoordinator() -> PassCodeField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PassCodeField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
        }
    }
}
