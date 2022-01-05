//
//  MultiLineText.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 1/4/22.
//

import Foundation

import SwiftUI
import UIKit


struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textField = UITextView()
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
        doneButton.tintColor = UIColor(red: 2,green: 179,blue: 0)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [doneButton]
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        textField.inputAccessoryView = toolBar
        
        textField.isScrollEnabled = true
        textField.isEditable = true
        textField.isUserInteractionEnabled = true
        
        textField.delegate = context.coordinator
        
        return textField
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextView
        @Binding var value: String
        
        init(_ parent: MultilineTextView, value: Binding<String>) {
            self.parent = parent
            self._value = value
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            value = uiView.text
                   
                }
  
      
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, value: $text)
        }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        
   
    }
    
 
}

