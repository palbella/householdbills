//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct CategoryView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var categoryFetchResult: FetchedResults<Category>
    

    
    init() {
    
        UINavigationBar.appearance().isTranslucent = false
      
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

            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                Section(header:
                            HStack {
                                VStack{
                                  
                                Text("Categories")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                }
                                Spacer()
                                
                                VStack {
                                }
                               
                            }
                          
                            
                ) {

                    Divider()
               
                    
                   
                    ForEach(self.categoryFetchResult.indexed(), id: \.1.id) { index, item in

                        if(item.id != 99) {

                        VStack (spacing: 0) {
                            HStack (spacing: 0) {
                                Icon(content: item.iconContent!, color: getColor(color: item.iconColor!)).padding(5).padding(.leading, 5).padding(.trailing, 5)

                                VStack (spacing: 0) {

                                HStack (spacing: 0) {
                                  Text(LocalizedStringKey(item.name!))
                                .font(.system(size: 15))
                                .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                                  Spacer()


                                }

                                   

                                }
                        }
                        .frame(maxWidth: .infinity)

                        }
                        }

                                          }
                                                          .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)

                    
                 
                    
          
            }
            
         
                Spacer()
         
        }
            .padding(.top, 40)
        
        }
            .navigationBarTitle("Back")
            .background(NavigationConfigurator { nc in
                let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                            nc.navigationBar.barTintColor = UIColor(color)
                        })
            .navigationBarTitleDisplayMode(.inline)
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Category Management")
                        .font(ui.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            .onAppear(){
                self.onAppear()
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
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
