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
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var account: AccountModel
   
    @State var deleteCrypto: Bool = false
    @State var modalCrypto: Bool = false
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    
    @State var isShowingToast: Bool = false
    @State var toastMessasge: String = ""
    @State var cryptoSelected : CryptocurrencyModel = CryptocurrencyModel()
    
    @State var totalPrices: Double = 0
    @State var totalInvestments: Double = 0
    
    public let predicate: NSPredicate
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var cryptoFetch: FetchRequest<Cryptocurrency>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var cryptoFetchResult: FetchedResults<Cryptocurrency>
    
//    @State var market: [CryptocurrencyMarketModel] = []
    
    init(account: Binding<AccountModel> ) {
        
        self._account = account
        
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
                                        self.cryptoSelected = CryptocurrencyModel()
                                        self.isShowingNew = true
                                    }) {
                                        
                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                     
                                      
                                                       if(self.$cryptoSelected.name.wrappedValue != "") {
                                                        addCrypto(crypto: self.$cryptoSelected.wrappedValue)
                                                       }
                                            

                                        }) {
                                        CryptocurrencyAddView(crypto: self.$cryptoSelected)
                                        
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
                                                                    self.cryptoSelected = map(crypto: item)
                                                                      self.deleteCrypto = false
                                                                      self.isShowing = true
                                                                  }) {
                                                                      
                                                                      VStack (spacing: 0) {
                                                                          HStack (spacing: 0) {
                                                                            Icon(content: "bitcoinsign.circle", color: Color.yellow).padding(5).padding(.leading, 5).padding(.trailing, 5)

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
                                                                  .sheet(isPresented: self.$isShowing, onDismiss: {
                                                                      
                                                                      
                                                                      if(self.deleteCrypto) {
                                                                          deleteCrypto(crypto: self.$cryptoSelected.wrappedValue)
                                                                      } else {
                                                                          updateCrypto(crypto: self.$cryptoSelected.wrappedValue)
                                                                      }

                                                                  }) {
                                                                    
                                                                    CryptocurrencyUpdateView(crypto: self.$cryptoSelected, modal: self.$isShowing, delete: self.$deleteCrypto)
                                                                        
                                                                    
                                                                      
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
                                    .padding(.top, 15)
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
    
    private func addCrypto(crypto: CryptocurrencyModel)
    {
      
            withAnimation {
             
                let newCrypto = Cryptocurrency(context: viewContext)
                newCrypto.id = UUID()
                newCrypto.accountId = self.$account.wrappedValue.id
                newCrypto.name = crypto.name
                newCrypto.amount = crypto.amount
                newCrypto.symbol = crypto.symbol
                newCrypto.avgPurchase = crypto.avgPurchase
                newCrypto.price = crypto.price
                newCrypto.notificated = false
                newCrypto.notificationPriceUp = crypto.notificationPriceUp
                newCrypto.notificationPriceDown = crypto.notificationPriceDown

      SaveContext()
            }
        GetMarketCriptocurrencies(viewContext: viewContext).run()
        getTotals()

    }
    
    private func updateCrypto(crypto: CryptocurrencyModel)
    {
      
          
        do {
                let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", crypto.id as CVarArg)
                
                let savedCrypto = try  self.viewContext.fetch(request)[0]
                
            savedCrypto.name = crypto.name
            savedCrypto.accountId = self.$account.wrappedValue.id
            savedCrypto.amount = crypto.amount
            savedCrypto.symbol = crypto.symbol
            savedCrypto.amount = crypto.amount
            savedCrypto.avgPurchase = crypto.avgPurchase
            savedCrypto.price = crypto.price
            savedCrypto.notificated = false
            savedCrypto.notificationPriceUp = crypto.notificationPriceUp
            savedCrypto.notificationPriceDown = crypto.notificationPriceDown
            
        } catch {
            print(error)
        }

      SaveContext()
        GetMarketCriptocurrencies(viewContext: viewContext).run()
        getTotals()

    }
    
    private func deleteCrypto(crypto: CryptocurrencyModel)
    {
            withAnimation {
                
                let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", crypto.id as CVarArg)

                    do {
                        let savedCryptos = try  self.viewContext.fetch(request)
                        
                        for crypto in savedCryptos {
                            self.viewContext.delete(crypto)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
SaveContext()
        GetMarketCriptocurrencies(viewContext: viewContext).run()
        getTotals()
       
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    private func map(crypto: Cryptocurrency) -> CryptocurrencyModel
    {
        var cryptoModel = CryptocurrencyModel()
        
        cryptoModel.id = crypto.id!
        cryptoModel.name = crypto.name ?? ""
        cryptoModel.symbol = crypto.symbol ?? ""
        cryptoModel.amount = crypto.amount
        cryptoModel.accountId = crypto.accountId!
        cryptoModel.avgPurchase = crypto.avgPurchase
        cryptoModel.price = crypto.price
        cryptoModel.notificated = crypto.notificated
        cryptoModel.notificationPriceUp = crypto.notificationPriceUp
        cryptoModel.notificationPriceDown = crypto.notificationPriceDown

        return cryptoModel
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
