//
//  MainView.swift
//  Household Bills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import CoreData

enum Tab {
    case dashboard
    case transactions
    case modal
    case planning
    case more
}

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
//    @State var isShowing: Bool = true
    @State var selection: Tab = .dashboard
    
    @State var isShowingToast: Bool = false
    @State var toastMessasge: String = ""
    @State var toastError: Bool = true
    @State var isShowingPopup: Bool = false
    @State var popupMessasge: String = ""
    @State var popupTitle: String = ""
    @State var popupImage: String = ""
    
    @State var showActionSheet: Bool = false
    @State var showSubscribe: Bool = false
    @State var showUser: Bool = false
    
    @State var currencies = GetCurrencies()
    @ObservedObject var transactionData = TransactionData()
    @State var transactionAccountId: UUID = UUID()
    @State var transaction : TransactionModel = TransactionModel()
    
    @State var save: Bool = false
    
    init() {
//        UITabBar.appearance().isTranslucent = false
      }
    
    var body: some View {
        
        
        ZStack {
                    GeometryReader { geometry in
                        TabView(selection: $selection) {

                            DashboardView()
                                .tag(Tab.dashboard)
                            .tabItem {
                                Image(systemName: "house")
                                    .resizable()
                                Text("Dashboard")
                            }
                            
//                            PlanningView(isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, showSubscribe: $showSubscribe, isShowingPopup: $isShowingPopup, popupMessasge: $popupMessasge, popupTitle: self.$popupTitle, popupImage: self.$popupImage)
                            Text("aa")
                                .tag(Tab.planning)
                            .tabItem {
                                Image(systemName: "list.number")
                                Text("Planning")
                            }
                     
//                            DashboardView(isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, isShowingPopup: $isShowingPopup, popupMessasge: $popupMessasge, popupTitle: self.$popupTitle, popupImage: self.$popupImage, showUser: $showUser, showSubscribe: $showSubscribe)
//                                .tag(Tab.dashboard)
//                            .tabItem {
//
//                            }
                             

//                            TransactionView(showSubscribe: $showSubscribe)
//                                .tag(Tab.transactions)
//                            .tabItem {
//                                Image(systemName: "doc.text.magnifyingglass")
//                                Text("Transactions")
//                            }
//
//
//                            MoreView(showSubscribe: $showSubscribe, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, isShowingPopup: $isShowingPopup, popupMessasge: $popupMessasge, popupTitle: self.$popupTitle, popupImage: self.$popupImage)
//                                .tag(Tab.more)
//                            .tabItem {
//                                Image(systemName: "square.split.2x2")
//                                Text("More")
//                            }
                            
                                }
//                        .tabViewStyle()
//                        .accentColor(colorScheme != .dark ? ui.lightFontColor: ui.darkFontColor)
                        
                        .onAppear(){
                           
                            settings.lastLogin = Date()
                        }
                        
//                        Image(systemName: "plus.circle")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .shadow(color: .gray, radius: 4, x: 0, y: 5)
//                            .offset(x: geometry.size.width / 2 - 20, y: geometry.size.height - 60)
////                            .foregroundColor(ui.darkPrimaryColor)
//                            .onTapGesture {
//                                self.transaction = TransactionModel()
//                                self.transactionAccountId = UUID()
//                                self.showActionSheet.toggle()
//                        }
                           
                            
                    }
//                    .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))

//            PopUpWindow(isShowingPopup: $isShowingPopup, popupTitle: $popupTitle, popupMessasge: $popupMessasge, popupImage: $popupImage)
        }
//        .fullScreenCover(isPresented: $showSubscribe, content: SubscribeView.init)
//        .fullScreenCover(isPresented: $showUser, content: UserView.init)
//                .sheet(isPresented: $showActionSheet, onDismiss: {
//
//                    if(settings.fastApply || self.save) {
//                        if(self.$transaction.amount.wrappedValue > 0) {
//
//                             self.transaction.timestamp = Date()
//                            self.updateAccount()
//
//                            if(self.transaction.type == LocalizedStringKey("Expense").toString()) {
//                                self.transaction.amount = self.transaction.amount * -1
//                            }
//                            if(transaction.name == "") {
//                                transaction.name = LocalizedStringKey("Adjustment").toString()
//                            }
//                            self.transactionData.addTransactions(transaction: transaction)
//                        }
//                    }
//
//
//                }) {
//                    TransactionsAddView(accountId: $transactionAccountId, transaction: self.$transaction, modal: self.$showActionSheet, save: $save, isShowingToast: $isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
//                }
               
    }
        
    
    private func updateAccount()
    {
      
          
        do {
                let request: NSFetchRequest<Account> = Account.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", self.transactionAccountId as CVarArg)
           
                
                let savedAccount = try  self.viewContext.fetch(request)[0]
            
            let amountConverted: Double = currencies.convert(currencyFrom: transaction.currency, currencyTo: savedAccount.currency!, value: transaction.amount)
                
            if(transaction.type == LocalizedStringKey("Expense").toString()) {
                savedAccount.amount = savedAccount.amount - amountConverted
            }
            if(transaction.type == LocalizedStringKey("Income").toString()) {
                savedAccount.amount = savedAccount.amount + amountConverted
            }
            if(transaction.type == LocalizedStringKey("Transfer").toString()) {
                savedAccount.amount = savedAccount.amount - amountConverted
                
                let requestB: NSFetchRequest<Account> = Account.fetchRequest()
                requestB.predicate = NSPredicate(format: "id = %@", self.transaction.destinationId as CVarArg)
               
                
                let destination = try  self.viewContext.fetch(requestB)[0]
                
                let amountTransferConverted: Double = currencies.convert(currencyFrom: savedAccount.currency!, currencyTo: destination.currency!, value: transaction.amount)
             
                destination.amount = destination.amount + amountTransferConverted
            }
            if(transaction.type == LocalizedStringKey("Income").toString()) {
                transaction.amount = transaction.amount * -1
            }
            
            
        } catch {
            print(error)
        }

      SaveContext()
      

    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    
}






//#if DEBUG
//struct MainView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        MainView().environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif


