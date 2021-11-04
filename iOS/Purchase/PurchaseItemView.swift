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
    
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
//        var purchaseItemFetchResult: FetchedResults<PurchaseItem>
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    
    @Binding var purchase: PurchaseModel
    
    @Binding var totalPrices: Double
    
//    public let predicate: NSPredicate
//    var purchaseItemFetch: FetchRequest<PurchaseItem>
    @State var currencies = GetCurrencies()
    
    @StateObject var items : GetPurchaseItems = GetPurchaseItems()
    @State var viewRefresh : Int = 0
    
    init(purchase: Binding<PurchaseModel>, totalPrices: Binding<Double> ) {
        
        self._purchase = purchase
        self._totalPrices = totalPrices
        
    
        
        UINavigationBar.appearance().isTranslucent = false

       }
    
    
    func onAppear() {
        
        self.totalPrices = 0
        let fetchRequest: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        self.items.items = []
        
        do {
            let savedPurchaseItems =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedPurchaseItems.count {

                                var item = PurchaseItemModel()
                                
                                item.id = savedPurchaseItems[index].id!
                                item.name = savedPurchaseItems[index].name!
                                item.price = savedPurchaseItems[index].price
                                item.unit = savedPurchaseItems[index].unit!
                                item.purchaseId = savedPurchaseItems[index].purchaseId!
                                item.purchased = savedPurchaseItems[index].purchased
                                
                                self.items.items.append(item)
                                
                                if( savedPurchaseItems[index].purchased != true) {
                                self.totalPrices = self.totalPrices + savedPurchaseItems[index].price
                                }
                                    }
        } catch {
           
        }
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
                                        self.addItem()
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
                    
                
                    
                   
                    ForEach(self.items.items.indexed(), id: \.1.id) { index, item in
                            
                       
                        if(item.purchaseId == self.$purchase.wrappedValue.id) {
                         
                            var iconColor = self.items.items[index].purchased == true ? Color.blue: Color.gray

                            VStack (spacing: 0) {
                                
                                HStack (spacing: 0) {
                                    
                                    Button(action: {
                                        self.onPurchase(id: self.items.items[index].id)
                                        iconColor = self.items.items[index].purchased == true ? Color.blue: Color.gray
                                      
                                    }) {
                                    Icon(content: "cart", color: iconColor).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                    }

                                      
                                 
                                    Text(item.name)
//                                    .foregroundColor(labelColor)
                                    .frame(width: 200, alignment: .leading)
                                    Spacer()
                                   
                                    CustomTextfield(label: "", text: self.$items.items[index].unit, keyType: UIKeyboardType.alphabet, textAlignment: .left, maxLength: 3)
//                                        .foregroundColor(labelColor)
                                        .onChange(of: self.$items.items[index].unit.wrappedValue, perform: { value in
                                            self.onUnitChange(id: self.$items.items[index].id.wrappedValue, value: self.$items.items[index].unit.wrappedValue)
                                        })
                                    

                                  
                                    CurrencyField(
                                                "Amount",
                                                value: Binding(get: {
                                                    return self.$items.items[index].price.wrappedValue as NSNumber
                                                }, set: { number in
                                                    var result: Double = 0
                                                    if(number != nil) {
                                                        result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                                    }
                                                    
                                                    self.$items.items[index].price.wrappedValue = result
                                                }
                                                ),
                                                foregroundColor: UIColor(Color.black),
                                                maxLength: 10
                                            ).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                        .onChange(of: self.$items.items[index].price.wrappedValue, perform: { value in
                                            self.onPriceChange(id: self.$items.items[index].id.wrappedValue, value: self.$items.items[index].price.wrappedValue)
                                        })
                                    

                                    
                            }
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                

                            }
                            
                 }
                                          
                        
                                          }
                                                          .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                          
                    
                 
                    
                 
                    
          
            }
            
         
        }
            .padding(.top, 40)
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .onAppear() {
                self.onAppear()
                        }
        }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
       
    }
    
    
    func onUnitChange (id: UUID, value: String) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.unit = value
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
        self.onAppear()
    }
    
    func onPriceChange (id: UUID, value: Double) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.price = value
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
        self.onAppear()
    }
    
    
    func onPurchase (id: UUID) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.purchased = !item.purchased
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
        self.onAppear()
    }
    
    func addItem () {
        
        let newItem = PurchaseItem(context: viewContext)
        newItem.id = UUID()
        newItem.name = "Item"
        newItem.price = 0
        newItem.unit = "u"
        newItem.purchaseId = self.$purchase.wrappedValue.id
     
     
SaveContext()
        self.onAppear()
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
}
