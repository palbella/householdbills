//
//  PasscodeField.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 12/13/21.
//

import Foundation
import SwiftUI


public struct PasscodeField: View {
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
    var maxDigits: Int = 6
    
    @State var label: String = LocalizedStringKey("Type below to introduce password").toString()
    @State var pin: String = ""
    @State var showPin = false
    @State var isDisabled = false
    
    
    var handler: (String, (Bool) -> Void) -> Bool
    
    public var body: some View {
        VStack(spacing: 20) {
            Text(label)
                .foregroundColor(ui.lightCommandFontColor)
                .font(.system(size: 12))
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
//        .frame(height: 40)
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



