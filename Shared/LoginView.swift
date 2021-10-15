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
    
//    @State  private var emailAddress: String = ""
    @State  private var password: String = ""
    
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
                
                Text("Log Into Your Account")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 50)
                
                
                PasscodeField( handler:{ pin, result in
                    let result = pin == settings.password
                   
                    if(result) {
                        settings.loggedIn = true
                        settings.lastLogin = Date()
                    }
                    return result
                })
                

                
                 Button(action: {
                    self.settings.loggedIn = true
                 }) {
                        HStack {
                            Text("Log In")
                        }
                            .padding()
                            .frame(width: geometry.size.width - 40, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(5)
                    }
                     .padding(.bottom, 40)
                
                Divider()
                
                Button(action: {
                        print("Take to forget password VC")
                        }) {
                        Text("Forgot your password?")
                }
                
                Spacer()
                
            }
            .onAppear(perform: authenticate)
            .padding(.bottom, 90)
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





public struct PasscodeField: View {
    
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
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
