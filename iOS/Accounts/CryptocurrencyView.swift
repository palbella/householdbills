//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct CryptocurrencyView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var account: AccountModel
   
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    
    @Binding var isShowing: Bool
    @Binding var isShowingNew: Bool
    @Binding var deleteCrypto: Bool
    @Binding var modalCrypto: Bool
    
    @Binding var cryptoSelected : CryptocurrencyModel
    
    @Binding var totalPrices: Double
    @Binding var totalInvestments: Double
    
    @State var cryptoData : CryptocurrencyData = CryptocurrencyData()
    
    public let predicate: NSPredicate

    var cryptoFetch: FetchRequest<Cryptocurrency>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var cryptoFetchResult: FetchedResults<Cryptocurrency>
    
    @Binding var showSubscribe: Bool
    @Binding var modalMain: Bool
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(account: Binding<AccountModel>, cryptoSelected: Binding<CryptocurrencyModel>, isShowingNew: Binding<Bool>, isShowingUpdate: Binding<Bool>, deleteCrypto: Binding<Bool>, modalCrypto: Binding<Bool>, totalPrices: Binding<Double>, totalInvestments: Binding<Double>, showSubscribe: Binding<Bool>, modalMain: Binding<Bool>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool> ) {
        
        self._account = account
        self._cryptoSelected = cryptoSelected
        self._isShowingNew = isShowingNew
        self._isShowing = isShowingUpdate
        self._deleteCrypto = deleteCrypto
        self._modalCrypto = modalCrypto
        self._totalInvestments = totalInvestments
        self._totalPrices = totalPrices
        self._showSubscribe = showSubscribe
        self._modalMain = modalMain
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        
        UINavigationBar.appearance().isTranslucent = false
        
        
        predicate = NSPredicate(format: "accountId == %@", self._account.wrappedValue.id as CVarArg)
        cryptoFetch = FetchRequest<Cryptocurrency>(entity: Cryptocurrency.entity(), sortDescriptors: [], predicate: predicate)
       }
    
 

    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                Section(header:
                            HStack {
                                VStack{
                                  
                                Text("Cryptocurrencies")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                }
                                Spacer()
                                
                                VStack {
                                   
                                    Button(action: {
                                        if(settings.subscribed || self.cryptoFetchResult.count < 1) {
                                        self.cryptoSelected = CryptocurrencyModel()
                                        self.isShowingNew = true
                                        } else {
                                            self.toastMessasge = "Please, Subscribe for more items"
                                            self.isShowingToast = true
                                            self.toastError = true
                                        }
                                    }) {
                                        
                                        CommandButton(content: "plus.circle")
                                    }
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 17)
                                    .padding(.bottom, 12)
                                }
                               
                            }
                          
                            
                ) {

                    Divider()
                    
                
                    
                   
                    ForEach(self.cryptoFetchResult.indexed(), id: \.1.id) { index, item in
                                 
                        if(item.accountId == self.$account.wrappedValue.id) {
                           
                                              
                                              let fontColor = item.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                                              
                                                                  Button(action: {
                                                                      self.cryptoSelected = cryptoData.map(crypto: item)
                                                                      self.deleteCrypto = false
                                                                      self.isShowing = true
                                                                  }) {
                                                                      
                                                                      VStack (spacing: 0) {
                                                                          HStack (spacing: 0) {
                                                                            Icon(content: "bitcoinsign.circle", color: Color.yellow).padding(8).padding(.leading, 5).padding(.trailing, 5)

                                                                              VStack (spacing: 0) {
                                                                                  
                                                                              HStack (spacing: 0) {
                                                                                Text(item.name!)
                                                                              .font(.system(size: 15))
                                                                              .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                                                
                                                                                Spacer()
                                                                                
                                                                                Text(self.account.symbol + " " + String(item.price))
                                                                              .font(.system(size: 12))
                                                                                    .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor )
                                                                             

                                                                          
                                                                                VStack(alignment: .trailing, spacing: 0) {
                                                                                    Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
                                                                                        .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                                              .font(.system(size: 13))
                                                                                        .multilineTextAlignment(.trailing)

                                                                                   
                                                                                    Text(self.account.symbol + " " + String(format: "%.2f", (item.price * item.amount))).padding(.leading, 5).padding(.trailing, 5).padding(.bottom, 5)
                                                                                  .foregroundColor(fontColor)
                                                                                        .multilineTextAlignment(.trailing)
                                                                                  .font(.system(size: 10))
                                                                                }
                                                                                .frame(width: 180, alignment: .trailing)
                                                                              }
                                                                                  
                                                                               

                                                                              }
                                                                      }
                                                                          .frame(maxWidth: .infinity)

                                                                      }
                                                                      
                                                                  }
                                          
                        }
                                          }
                                                          .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                          
                    
                 
                    
                 
                    
          
            }
            
                Section(header:
                            HStack {
                                VStack{
                               
                                Text("Details")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 35)
                                    .padding(.leading, 10)
                                    .padding(.bottom, 5)
                                    .font(.system(size: 12))
                                    .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                }
                       
                               
                            }
                          
                ) {
                    Divider()
                    VStack (spacing: 0) {
                        HStack (spacing: 0) {
                            Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)

                            VStack (spacing: 0) {
                                
                            HStack (spacing: 0) {
                              Text("Total Investment")
                            .font(.system(size: 15))
                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                        Spacer()
                                
                            Text(self.account.symbol + " " + String(format: "%.2f", (self.totalInvestments))).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
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
                              Text("Total")
                            .font(.system(size: 15))
                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                        Spacer()
                                
                                  Text(self.account.symbol + " " + String(format: "%.2f", (self.totalPrices))).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
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
                              Text("Profits")
                            .font(.system(size: 15))
                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                        Spacer()
                                Text(self.account.symbol + " " + String(format: "%.2f", (self.totalPrices - self.totalInvestments))).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor )
                            .font(.system(size: 15))
                                      .multilineTextAlignment(.trailing)

                        
                              
                            }
                                
                             

                            }
                    }
                    .frame(maxWidth: .infinity)
                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                       
                    }
                  
                    
                }
                Spacer()
         
        }
            .padding(.top, 40)
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .onAppear() {
                GetMarketCriptocurrencies(viewContext: viewContext).run()
                getTotals()
                        }
        }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
       
    }
    
    
    private func getTotals() {
        
        self.totalPrices = 0
        self.totalInvestments = 0
        let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()

        request.predicate = NSPredicate(format: "accountId = %@", self.$account.wrappedValue.id as CVarArg)

            do {
                let savedCryptos = try self.viewContext.fetch(request)
                
                for item in savedCryptos {
                    self.totalPrices = self.totalPrices + (item.price * item.amount)
                    self.totalInvestments = self.totalInvestments + (item.avgPurchase * item.amount)
                }
               
            } catch {
                print(error)
            }
        
    }
    
  

    

    
  
    
}


//#if DEBUG
//struct CryptoView_Previews: PreviewProvider {
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//        CryptocurrencyView(account: .constant(AccountModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//    }
//}
//#endif
