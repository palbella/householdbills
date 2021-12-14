//
//  Extensions.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/26/21.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



let navigationNormalHeight: CGFloat = 44
let navigationExtendHeight: CGFloat = 84

extension UINavigationBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var barHeight: CGFloat = navigationNormalHeight
    
        if size.height == navigationExtendHeight {
            barHeight = size.height
        }
    
        let newSize: CGSize = CGSize(width: self.frame.size.width, height: barHeight)
        return newSize
    }
}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}


extension UIFont {
    class func fromFont(font: Font?) -> UIFont? {
        var uiFont: UIFont? = nil
        
        if(font != nil) {
        switch font! {
        case .largeTitle:
            uiFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            uiFont = UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            uiFont = UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            uiFont = UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            uiFont = UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            uiFont = UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            uiFont = UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            uiFont = UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            uiFont = UIFont.preferredFont(forTextStyle: .footnote)
        case .body:
            fallthrough
        default:
            uiFont = UIFont.preferredFont(forTextStyle: .body)
        }
        }
        
        return uiFont
    }
}

struct CustomTextfield: UIViewRepresentable {
    @State var label: String
    @Binding var text: String
    var keyType: UIKeyboardType
    var onEditingChanged: (Bool) -> Void = {_ in }
    @State var isEditing: Bool = false
    
    @State var afterIsEditing: Bool = false
    @State var previusValue: String = ""
    
    
     var font: UIFont?
        var foregroundColor: UIColor?
        var accentColor: UIColor?
        var textAlignment: NSTextAlignment?
        var contentType: UITextContentType?

        var autocorrection: UITextAutocorrectionType = .default
        var autocapitalization: UITextAutocapitalizationType = .sentences
        var keyboardType: UIKeyboardType = .default
        var returnKeyType: UIReturnKeyType = .default

        var isSecure: Bool = false
        var isUserInteractionEnabled: Bool = true
        var clearsOnBeginEditing: Bool = false
    
    @State var maxLength: Int? = nil
    
    @State  var dynamicHeight: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize
        @Environment(\.layoutDirection)  var layoutDirection: LayoutDirection
        
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextfield
        var onEditingChanged: (Bool) -> Void
        @Binding var isEditing: Bool
        @Binding var value: String
        @Binding var maxLength: Int?
        
        init(_ parent: CustomTextfield, onEditingChanged: @escaping (Bool) -> Void, isEditing: Binding<Bool>, value: Binding<String>, maxLength: Binding<Int?>) {
            self.parent = parent
            self.onEditingChanged = onEditingChanged
            self._isEditing = isEditing
            self._maxLength = maxLength
            self._value = value
        }
                              
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            
            if((maxLength != nil) && textField.text != nil && textField.text!.count > maxLength!) {
                textField.text?.removeLast()
            }
//            self.parent.$text.wrappedValue = textField.text ?? ""
//            self.isEditing = textField.isEditing
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.onEditingChanged(textField.isEditing)
            self.isEditing = textField.isEditing
            textField.text = value
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.$text.wrappedValue = textField.text ?? ""
            self.onEditingChanged(textField.isEditing)
            self.isEditing = textField.isEditing
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, onEditingChanged: onEditingChanged, isEditing: self.$isEditing, value: $text, maxLength: $maxLength)
        }

    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
      textfield.keyboardType = keyType
//        textfield.onEditingChanged = {}
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [doneButton]
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        textfield.inputAccessoryView = toolBar
        textfield.placeholder = LocalizedStringKey(label).toString()
       textfield.textAlignment = .right
        textfield.delegate = context.coordinator
        
        textfield.text = text
        textfield.font = font
        textfield.textColor = foregroundColor
                if let textAlignment = textAlignment {
                    textfield.textAlignment = textAlignment
                }
                if let contentType = contentType {
                    textfield.textContentType = contentType
                }
                if let accentColor = accentColor {
                    textfield.tintColor = accentColor
                }

        
        return textfield
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if(isEditing != true) {
            uiView.text = text
        }
    }
    
    
    
    
}




extension CustomTextfield {
    func customFont(_ font: UIFont?) -> CustomTextfield {
        var view = self
        view.font = font
        return view
    }

    func customForegroundColor(_ color: UIColor?) -> CustomTextfield {
        var view = self
        view.foregroundColor = color
        return view
    }

//    func customAccentColor(_ accentColor: UIColor?) -> some View {
//        var view = self
//        view.accentColor = accentColor
//        return view
//    }

    func customMultilineTextAlignment(_ alignment: TextAlignment?) -> CustomTextfield {
        var view = self
        if(alignment != nil) {
        switch alignment! {
        case .leading:
            view.textAlignment = layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            view.textAlignment = layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            view.textAlignment = .center
        }
        }
        return view
    }

//    func customTextContentType(_ textContentType: UITextContentType?) -> some View {
//        var view = self
//        view.contentType = textContentType
//        return view
//    }
//
//    func customDisableAutocorrection(_ disable: Bool?) -> some View {
//        var view = self
//        if let disable = disable {
//            view.autocorrection = disable ? .no : .yes
//        } else {
//            view.autocorrection = .default
//        }
//        return view
//    }
//
//    func customAutocapitalization(_ style: UITextAutocapitalizationType) -> some View {
//        var view = self
//        view.autocapitalization = style
//        return view
//    }
//
//    func customKeyboardType(_ type: UIKeyboardType) -> some View {
//        var view = self
//        view.keyboardType = type
//        return view
//    }
//
//    func customReturnKeyType(_ type: UIReturnKeyType) -> some View {
//        var view = self
//        view.returnKeyType = type
//        return view
//    }
//
//    func customIsSecure(_ isSecure: Bool) -> some View {
//        var view = self
//        view.isSecure = isSecure
//        return view
//    }
//
//    func customClearsOnBeginEditing(_ shouldClear: Bool) -> some View {
//        var view = self
//        view.clearsOnBeginEditing = shouldClear
//        return view
//    }
//
//    func customDisabled(_ disabled: Bool) -> some View {
//        var view = self
//        view.isUserInteractionEnabled = disabled
//        return view
//    }
}



extension UIImage {

    func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = size.width + x
        let height: CGFloat = size.height + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        

        return imageWithPadding
    }
}


extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}



extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
