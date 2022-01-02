//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct StockView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var account: AccountModel
   
    @Binding var deleteStock: Bool
    @Binding var modalStock: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    
    @Binding var isShowing: Bool
    @Binding var isShowingNew: Bool
    
    @State var stockData : StockData = StockData()
    
    @Binding var stockSelected : StockModel
    
    @Binding var totalPrices: Double
    @Binding var totalInvestments: Double
    
    public let predicate: NSPredicate

    var stockFetch: FetchRequest<Stock>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var stockFetchResult: FetchedResults<Stock>
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    init(account: Binding<AccountModel>, stockSelected: Binding<StockModel>, isShowingNew: Binding<Bool>, isShowingUpdate: Binding<Bool>, deleteStock: Binding<Bool>, modalStock: Binding<Bool>, totalPrices: Binding<Double>, totalInvestments: Binding<Double>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
        
        self._account = account
        self._stockSelected = stockSelected
        self._isShowingNew = isShowingNew
        self._isShowing = isShowingUpdate
        self._deleteStock = deleteStock
        self._modalStock = modalStock
        self._totalInvestments = totalInvestments
        self._totalPrices = totalPrices
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        
        UINavigationBar.appearance().isTranslucent = false
        
        predicate = NSPredicate(format: "accountId = %@", self._account.wrappedValue.id as CVarArg)
        stockFetch = FetchRequest<Stock>(entity: Stock.entity(), sortDescriptors: [], predicate: predicate)
       }
    
 

    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                Section(header:
                            HStack {
                                VStack{
                                  
                                Text("Stocks")
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
                                        if(settings.subscribed || self.stockFetchResult.count < 1) {
                                        self.stockSelected = StockModel()
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
                    
               
                    
                   
                    ForEach(self.stockFetchResult.indexed(), id: \.1.id) { index, item in
                             
                        if(item.accountId == self.$account.wrappedValue.id) {
                           
                                              
                                              let fontColor = item.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                                              
                                                                  Button(action: {
                                                                      self.stockSelected = stockData.map(stock: item)
                                                                      self.deleteStock = false
                                                                      self.isShowing = true
                                                                  }) {
                                                                      
                                                                      VStack (spacing: 0) {
                                                                          HStack (spacing: 0) {
                                                                            Icon(content: "stocks", color: Color.yellow).padding(8).padding(.leading, 5).padding(.trailing, 5)

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
                                    .padding(.top, 15)
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
            
                getTotals()
                        }
        }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
       
    }
    
   
    private func getTotals() {
        
        self.totalPrices = 0
        self.totalInvestments = 0
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        request.predicate = NSPredicate(format: "accountId = %@", self.$account.wrappedValue.id as CVarArg)

            do {
                let savedStocks = try self.viewContext.fetch(request)
                
                for item in savedStocks {
                    self.totalPrices = self.totalPrices + (item.price * item.amount)
                    self.totalInvestments = self.totalInvestments + (item.avgPurchase * item.amount)
                }
               
            } catch {
                print(error)
            }
        
    }
    
//    private func addStock(stock: StockModel)
//    {
//
//            withAnimation {
//
//                let newStock = Stock(context: viewContext)
//                newStock.id = UUID()
//                newStock.accountId = self.$account.wrappedValue.id
//                newStock.name = stock.name
//                newStock.amount = stock.amount
//                newStock.symbol = stock.symbol
//                newStock.avgPurchase = stock.avgPurchase
//                newStock.price = stock.price
//
//
//      SaveContext()
//            }
//        GetMarketStocks(viewContext: viewContext).run()
//        getTotals()
//
//    }
//
//    private func updateStock(stock: StockModel)
//    {
//
//
//        do {
//                let request: NSFetchRequest<Stock> = Stock.fetchRequest()
//                request.predicate = NSPredicate(format: "id = %@", stock.id as CVarArg)
//
//                let savedStock = try  self.viewContext.fetch(request)[0]
//
//            savedStock.name = stock.name
//            savedStock.accountId = self.$account.wrappedValue.id
//            savedStock.amount = stock.amount
//            savedStock.symbol = stock.symbol
//            savedStock.amount = stock.amount
//            savedStock.avgPurchase = stock.avgPurchase
//            savedStock.price = stock.price
//
//
//        } catch {
//            print(error)
//        }
//
//      SaveContext()
//        GetMarketStocks(viewContext: viewContext).run()
//        getTotals()
//
//    }
//
//    private func deleteStock(stock: StockModel)
//    {
//            withAnimation {
//
//                let request: NSFetchRequest<Stock> = Stock.fetchRequest()
//                request.predicate = NSPredicate(format: "id = %@", stock.id as CVarArg)
//
//                    do {
//                        let savedStocks = try  self.viewContext.fetch(request)
//
//                        for stock in savedStocks {
//                            self.viewContext.delete(stock)
//                        }
//                        try self.viewContext.save()
//                    } catch {
//                        print(error)
//                    }
//
//            }
//SaveContext()
//        GetMarketStocks(viewContext: viewContext).run()
//        getTotals()
//
//    }
//
//    private func SaveContext () {
//    do {
//
//  try viewContext.save()
//
//
//        }
//
//
//    catch {
//
//    }
//    }
//
//    private func map(stock: Stock) -> StockModel
//    {
//        var stockModel = StockModel()
//
//        stockModel.id = stock.id!
//        stockModel.name = stock.name ?? ""
//        stockModel.symbol = stock.symbol ?? ""
//        stockModel.amount = stock.amount
//        stockModel.accountId = stock.accountId!
//        stockModel.avgPurchase = stock.avgPurchase
//        stockModel.price = stock.price
//
//        return stockModel
//    }
//
   
    
}


//#if DEBUG
//struct StockView_Previews: PreviewProvider {
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//        StockView(account: .constant(AccountModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//    }
//}
//#endif
