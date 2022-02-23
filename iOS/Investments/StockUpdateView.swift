//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


struct StockUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
   
    @Binding var stock: StockModel
    
    @Binding var modal: Bool
    @Binding var save: Bool
    @Binding var delete: Bool
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    @State private var showConfirm = false
    
    init(stock: Binding<StockModel>, modal: Binding<Bool>, save: Binding<Bool>, delete: Binding<Bool>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool> ) {
        
           self._stock = stock
        self._modal = modal
        self._save = save
        self._delete = delete
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        
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
            VStack(spacing:0) {
                HeaderTabTitleView(title: stock.name)
        Form {
            
            VStack {
                
                let amountColor = stock.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                
                let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
                let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor

                NumericField(
                    "Amount", symbol: $stock.wrappedValue.symbol,
                            value: Binding(get: {
                                return Decimal(stock.amount) as NSDecimalNumber
                            }, set: { number in
                                var result: Double = 0
                                if(number != nil) {
                                    result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                }

                                stock.amount = result
                            }),
                    foregroundColor: UIColor(amountColor),
                    font: ui.subtitle,
                    textAlignment: .center
                        )
                .padding()

                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $stock.name)
                TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Symbol", value: $stock.symbol)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Price", value: $stock.price)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Average Purchase Price", value: $stock.avgPurchase)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Alert Price Above", value: $stock.notificationPriceUp)
                DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Alert Price Below", value: $stock.notificationPriceDown)
            
               
                Section(header:
                            HStack {
                                VStack{
                               
                                Text("Details")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 5)
                                    .padding(.leading, 10)
                                    .padding(.bottom, 5)
                                    .font(.system(size: 12))
                                    .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                }
                       
                               
                            }
                            .padding(.top, 15)
                          
                ) {
                    Divider()
                    VStack (spacing: 0) {
                        HStack (spacing: 0) {
                            Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)

                            VStack (spacing: 0) {

                            HStack (spacing: 0) {
                              Text("Exchange")
                            .font(.system(size: 15))
                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                        Spacer()

                            Text(self.stock.exchange).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor )
                            .font(.system(size: 15))
                                      .multilineTextAlignment(.trailing)



                            }

                             

                            }
                    }
                    .frame(maxWidth: .infinity)
                        .padding(.top, 5)
                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)

                    }
                    
                    VStack (spacing: 0) {
                        HStack (spacing: 0) {
                          Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)

                            VStack (spacing: 0) {

                            HStack (spacing: 0) {
                              Text("Dividend")
                            .font(.system(size: 15))
                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                        Spacer()

                                Text("$ " + String(format: "%.2f", self.stock.dividend)).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor )
                            .font(.system(size: 15))
                                      .multilineTextAlignment(.trailing)



                            }

                             

                            }
                    }
                    .frame(maxWidth: .infinity)
                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)

                    }
                    
                    VStack (spacing: 0) {
                        HStack (spacing: 0) {
                          Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)

                            VStack (spacing: 0) {

                            HStack (spacing: 0) {
                              Text("Dividend Percent")
                            .font(.system(size: 15))
                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                        Spacer()
                                Text("% " + String(format: "%.2f", self.stock.dividendPercent)).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor )
                            .font(.system(size: 15))
                                      .multilineTextAlignment(.trailing)



                            }

                          

                            }
                    }
                    .frame(maxWidth: .infinity)
                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)

                    }
                    .padding(.bottom, 5)
                    
                }
                
            }
            
    
      
    }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text(stock.name)
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.stock.name != "") {
                                            self.modal = false
                                            self.save = true
                                        } else {
                                            self.toastMessasge = LocalizedStringKey("Name is required").toString()
                                            self.isShowingToast = true
                                            self.toastError = true
                                        }
                                    }
                }
                                }
        }
        .onAppear() {
            self.onAppear()
        }
            
               
            
           
                Divider()
            Button(action: {
                self.showConfirm = true
            }) {
                Text("Delete Stock")
                   .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
            .padding()
            }
        
    }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
    }
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Stock?"), message: Text("Are you sure you want to delete this stock?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
}


//    #if DEBUG
//    struct StockUpdateViewView_Previews: PreviewProvider {
//
//        static var viewContext = PersistenceController.preview.container.viewContext
//
//
//        static var previews: some View {
//
//
//            StockUpdateView(stock: .constant(StockModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                    .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//        }
//    }
//    #endif
