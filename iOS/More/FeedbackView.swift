//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct FeedbackView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
    
    
    @Binding var modal: Bool
    @Binding var save: Bool
    
    init(modal: Binding<Bool>, save: Binding<Bool>) {
    
        self._modal = modal
        self._save = save
        UINavigationBar.appearance().isTranslucent = false
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
       }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        
    }
    
 

    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                
           
                    HeaderTabTitleView(title: "Feedback")
            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    Button(action: {
                        self.save = false
                        self.modal = false
                    }) {
                        CardMenu(prompt: "hand.thumbsup", title: "I like it")
                    }
                    
                    
                  
                    Spacer()
                    
                    Button(action: {
                        self.save = true
                        self.modal = false
                    }) {
                        CardMenu(prompt: "hand.thumbsdown", title: "I have an issue")
                    }
                      
                    
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
            
            
         
                Spacer()
         
        }
            .padding(.top, 0)
        
        }
           
            .background(NavigationConfigurator { nc in
                let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                            nc.navigationBar.barTintColor = UIColor(color)
                        })
            .navigationBarTitleDisplayMode(.inline)
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if(settings.fastApply == true) {
                    Text("Feedback")
                        .font(ui.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                  
                    if(settings.fastApply != true) {
                      
                                        Button("Done") {
                                         
                                                self.modal = false
                                                self.save = true
                                          
                                        }
                    }
                                    }
            }
            .onAppear(){
                self.onAppear()
            }
          
            }
        
    }
//    .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
    .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
       
    }
    
    
    
}


//#if DEBUG
//struct ServiceView_Previews: PreviewProvider {
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//        ServicecurrencyView(account: .constant(AccountModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//    }
//}
//#endif
