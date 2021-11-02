//
//  PurchaseItemView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 11/3/21.
//

import SwiftUI
import CoreData


struct PurchaseItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var purchaseItemFetchResult: FetchedResults<PurchaseItem>
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    
    @Binding var purchase: PurchaseModel
    
    @Binding var isShowing: Bool
    @Binding var isShowingNew: Bool
    @Binding var deleteItem: Bool
    @Binding var modalItem: Bool
    
    @Binding var itemSelected : PurchaseItemModel
    
    @Binding var totalPrices: Double
    
    public let predicate: NSPredicate
    var purchaseItemFetch: FetchRequest<PurchaseItem>
//    @State var purchaseItemData : PurchaseItemData = PurchaseItemData()
    
    init(purchase: Binding<PurchaseModel>, itemSelected: Binding<PurchaseItemModel>, isShowingNew: Binding<Bool>, isShowingUpdate: Binding<Bool>, deleteItem: Binding<Bool>, modalItem: Binding<Bool>, totalPrices: Binding<Double> ) {
        
        self._purchase = purchase
        self._itemSelected = itemSelected
        self._isShowingNew = isShowingNew
        self._isShowing = isShowingUpdate
        self._deleteItem = deleteItem
        self._modalItem = modalItem
        self._totalPrices = totalPrices
        
        UINavigationBar.appearance().isTranslucent = false
        
        
        predicate = NSPredicate(format: "purchaseId == %@", self._purchase.wrappedValue.id as CVarArg)
        purchaseItemFetch = FetchRequest<PurchaseItem>(entity: PurchaseItem.entity(), sortDescriptors: [], predicate: predicate)
       }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                Section(header:
                            HStack {
                                VStack{
                                  
                                Text("Goods")
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
//                                        self.itemSelected = PurchaseItemModel()
                                        self.isShowingNew = true
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
                    
                
                    
                   
                    ForEach(self.purchaseItemFetchResult.indexed(), id: \.1.id) { index, item in
                                 
                        if(item.purchaseId == self.$purchase.wrappedValue.id) {
                           
                                              
//                                              let fontColor = item.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                                              
//                                                                  Button(action: {
//                                                                      self.cryptoSelected = cryptoData.map(crypto: item)
//                                                                      self.deleteCrypto = false
//                                                                      self.isShowing = true
//                                                                  }) {
//
//                                                                      VStack (spacing: 0) {
//                                                                          HStack (spacing: 0) {
//                                                                            Icon(content: "bitcoinsign.circle", color: Color.yellow).padding(5).padding(.leading, 5).padding(.trailing, 5)
//
//                                                                              VStack (spacing: 0) {
//
//                                                                              HStack (spacing: 0) {
//                                                                                Text(item.name!)
//                                                                              .font(.system(size: 15))
//                                                                              .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
//
//                                                                                Spacer()
//
//                                                                                Text(self.account.symbol + " " + String(item.price))
//                                                                              .font(.system(size: 12))
//                                                                                    .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor )
//
//
//
//                                                                                VStack(alignment: .trailing, spacing: 0) {
//                                                                                    Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5)
//                                                                                        .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
//                                                                              .font(.system(size: 13))
//                                                                                        .multilineTextAlignment(.trailing)
//
//
//                                                                                    Text(self.account.symbol + " " + String(format: "%.2f", (item.price * item.amount))).padding(.leading, 5).padding(.trailing, 5).padding(.bottom, 5)
//                                                                                  .foregroundColor(fontColor)
//                                                                                        .multilineTextAlignment(.trailing)
//                                                                                  .font(.system(size: 10))
//                                                                                }
//                                                                                .frame(width: 180, alignment: .trailing)
//                                                                              }
//
//
//
//                                                                              }
//                                                                      }
//                                                                      .frame(maxWidth: .infinity)
//
//                                                                      }
//
//                                                                  }
                                          
                        }
                                          }
                                                          .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                          
                    
                 
                    
                 
                    
          
            }
            
         
        }
            .padding(.top, 40)
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .onAppear() {
                
                        }
        }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
       
    }
}
