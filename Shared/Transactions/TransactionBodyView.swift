//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct TransactionsBodyView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var placeItemSelected: String? = nil
    
    @State var transactions = GetTransactions()
    @ObservedObject var fetchTransactions = FetchTransactions()
    
    @State var categories = GetCategories()
    @State var fetchCategories = FetchCategories()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var now = Date()
    
    @Binding var filters: TransactionFiltersModel
    @Binding var loading: Bool
    
    let dateFormarter = DateFormatter()
    
    
    
    var body: some View {
        
        VStack {
            ForEach(self.transactions.months.indexed(), id: \.1.id) { index, month in
        
            
        
        VStack(spacing: 0) {
            
            if(!self.$loading.wrappedValue) {
            Section(header:
                        HStack {
                            VStack{
                                Spacer()
                                Text(month.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                            .font(.system(size: 12))
                            .foregroundColor(Color(UIColor.darkGray))
                            }
                            Spacer()
                            
                            VStack {
                                Spacer()
                                Button(action: {
                                    self.isShowing = true
                                }) {
                                    CommandButton(content: "chart.pie")
                                }
                                .sheet(isPresented: self.$isShowing) { TransactionChart(items: self.$transactions.months[index].items, categories: $categories.items)}
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                                .padding(.trailing, 17)
                                .padding(.bottom, 17)
                            }
                           
                        }
                      
                        
            ) {

                Divider()
                
               
                ForEach (self.transactions.months[index].items.indexed(), id: \.1.id) { i, item in
                
                    let fontColorAccounts = item.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
            
                    VStack (spacing: 0) {
                        HStack (spacing: 0) {
                            Icon(content: item.iconContent, color: getColor(color: item.iconColor)).padding(5).padding(.leading, 5).padding(.trailing, 5)

                            VStack (spacing: 0) {
                           
                            HStack (spacing: 0) {
                                
                                VStack (alignment: .leading) {
                                Text(item.name)
                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor).padding(.bottom, 1)
                            .font(.system(size: 15))
//                            .padding(.top, 3)
                                    
                                    Text(item.account + getCategoryName(id: item.category))
                                        .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor )
                                .font(.system(size: 10))
                               
                                    
                                }
                                .padding(.top, 5)
                                

                        Spacer()
                                
                                VStack  (alignment: .trailing){
                                    Text(String(item.amount)).padding(.leading, 5).padding(.trailing, 5).padding(.top, 5).padding(.bottom, 5)
                            .foregroundColor(fontColorAccounts)
                            .font(.system(size: 15))
                                    
                                    Text(dateFormarter.string(from: item.timestamp!)).padding(.leading, 5).padding(.trailing, 5).padding(.bottom, 1)
                                        .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                .font(.system(size: 10))
                                    
                                }
                                .padding(.top, 5)



                            }
                                Spacer()
                          
                                if(i != self.transactions.months[index].items.count){
                                    Divider()
                                }
                                    

                            }
                    }
//                    .frame(maxWidth: .infinity)



                    }
               
                   
                
                
            }
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                Divider()
                }
                
            
         
      
        }
        
       
     
    }
    }
        }
        .onAppear {
          
            self.categories.items = fetchCategories.fetch(viewContext: viewContext)
            
            dateFormarter.dateStyle = .short
            getTransactions()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            getTransactions()
        
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            getTransactions()
            }
        .onReceive(timer) { _ in
            if(self.loading) {
            getTransactions()
                   self.now = Date()
               }
        }
        
      
    }
    
    func getCategoryName(id: Int32) -> String {
        if(id == 99) {
            return ""
        }
        var name = ""
        for c in categories.items {
            if (c.id == id) {
                name = c.name
            }
        }
        return " - " + name
    }
    
    func getTransactions()
    {
     
        self.loading = true
        
        self.transactions = self.fetchTransactions.fetch(viewContext: viewContext, filters: filters)
        
        self.loading = false

    }
    
    
    
    
}


//#if DEBUG
//struct TransactionsBodyView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        TransactionsBodyView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//
//    }
//}
//#endif
