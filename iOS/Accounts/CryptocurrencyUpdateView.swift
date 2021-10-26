//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


struct CryptocurrencyUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var crypto: CryptocurrencyModel
    
    @Binding var modal: Bool
    @Binding var delete: Bool
    
    @State private var showConfirm = false
    
    init(crypto: Binding<CryptocurrencyModel>, modal: Binding<Bool>, delete: Binding<Bool>) {
        
           self._crypto = crypto
        self._modal = modal
        self._delete = delete
        
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
            VStack(spacing:0) {
        Form {
            
            VStack {
                
                let amountColor = crypto.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

                NumericField(
                    "Amount", symbol: $crypto.wrappedValue.symbol,
                            value: Binding(get: {
                                return Decimal(crypto.amount) as NSDecimalNumber
                            }, set: { number in
                                var result: Double = 0
                                if(number != nil) {
                                    result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                }

                                crypto.amount = result
                            }),
                    foregroundColor: UIColor(amountColor),
                    font: ui.subtitle,
                    textAlignment: .center
                        )

                .padding()

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $crypto.name)
                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Symbol", value: $crypto.symbol)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Price", value: $crypto.price)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Average Purchase Price", value: $crypto.avgPurchase)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Alert Price Above", value: $crypto.notificationPriceUp)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Alert Price Below", value: $crypto.notificationPriceDown)
            
               

                
            }
            
    
      
    }
        .navigationBarTitle("Back")
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("New Cryptocurrency")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
        }
        .onAppear() {
            self.onAppear()
        }
            
            
           
                Divider()
            Button(action: {
                self.showConfirm = true
            }) {
                Text("Delete Crypto")
                   .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
            .padding()
            }
        
    }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
    }
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Crypto?"), message: Text("Are you sure you want to delete this cryptocurrency?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}


//    #if DEBUG
//    struct CryptocurrencyUpdateViewView_Previews: PreviewProvider {
//
//        static var viewContext = PersistenceController.preview.container.viewContext
//
//
//        static var previews: some View {
//
//
//            CryptocurrencyUpdateView(crypto: .constant(CryptocurrencyModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                    .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//        }
//    }
//    #endif
