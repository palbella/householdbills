//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct TermsView: View {
    @EnvironmentObject var ui: AppUI
    @Environment(\.presentationMode) var presentationMode
  
    @Binding var back: Bool
    @State var save: Bool = false
    
    func onAppear() {
   
    }
    
    var body: some View {
        
        
            VStack {
                HeaderTabView(title: "Goal Planning", modal: $back, save: $save)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        Text("aaaa sdigjhslkg").foregroundColor(ui.lightPrimaryColor)
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                    Text("aaaa sdigjhslkg jslkgjslkgjslkd gjslkdg jslkg jsdlkgjglskdgjlksdgjsdkl jgkls jgklsd jlsdk jslkdgj dlkgsjglkgjglsk jslkgjslk sjkldg jkdsl jklsd jg")
                   
                    }
                }
            }
            .onAppear() {
                self.onAppear()
               
            }
            .background(ui.lightBackgroundColor)
        }
       
     
        
        
       

}
