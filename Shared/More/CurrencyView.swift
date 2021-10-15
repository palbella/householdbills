//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct CurrencyView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
    
    
    @Binding var currencies : GetCurrencies
    @Binding var viewRefresh : Int
    
    
    init(currencies: Binding<GetCurrencies>, viewRefresh: Binding<Int>) {
        self._currencies = currencies
        self._viewRefresh = viewRefresh

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
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
        
        NavigationView {

            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                Section(header:
                            HStack {
                                VStack{
                                  
                                Text("Dolar Conversion Rate")
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
                    
                   
                   
                    ForEach(self.currencies.items.indexed(), id: \.1.id) { index, item in

                        var iconColor = self.currencies.items[index].selected == true ? Color.blue: Color.gray

                        VStack (spacing: 0) {

                            
                            HStack (spacing: 0) {
                                
                                Button(action: {
                                    self.currencies.items[index].selected.toggle()
                                    self.viewRefresh = self.viewRefresh + 1
                                    iconColor = self.currencies.items[index].selected == true ? Color.blue: Color.gray
                                }) {
                                Icon(content: "dollarsign.circle", color: iconColor).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                }
                                Text(String(viewRefresh))
                                    .frame(width: 0)
                               
                                  
                             
                                Text(item.name)
                                .foregroundColor(labelColor)
                                .frame(width: 200, alignment: .leading)
                                Spacer()
                               
                                CustomTextfield(label: "", text: self.$currencies.items[index].symbol, keyType: UIKeyboardType.alphabet, textAlignment: .left, maxLength: 3)
                                    .foregroundColor(labelColor)
                                

                                if(index != 0) {
                                CurrencyField(
                                            "Amount",
                                            value: Binding(get: {
                                                return self.$currencies.items[index].rate.wrappedValue as NSNumber
                                            }, set: { number in
                                                var result: Double = 0
                                                if(number != nil) {
                                                    result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                                }
                                                
                                                self.$currencies.items[index].rate.wrappedValue = result
                                            }
                                            ),
                                        foregroundColor: UIColor(fontColor),
                                            maxLength: 10
                                        ).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                }

                                
                        }
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            

                        }
                        


                                          }
                                           .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)

                    
                
                 
                    
          
            }
              
            
         
                Spacer()
                
         
        }
            .padding(.top, 40)
            .navigationBarTitle("Back")
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .background(NavigationConfigurator { nc in
                let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                            nc.navigationBar.barTintColor = UIColor(color)
                        })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Currency Management")
                        .font(ui.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            .onAppear() {
                self.onAppear()
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
            .frame(maxWidth: .infinity)
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            
    }
//        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
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
