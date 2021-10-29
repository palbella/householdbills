//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData


struct DashboardBodyView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)])
    var cardsFetch: FetchedResults<Card>
    
    @ObservedObject var fetchPayments = FetchPayments()
    
    @Binding var totalAccounts: Double
    @Binding var totalGoalAccounts: Double
    @Binding var totalGoals: Double
    @Binding var totalPayments: Double
    @Binding var totalBudgets: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    
    @Binding var hideData: Bool
    @State var monthChange: Bool = false
    @State var nextMonth: Date? = Date()
    @State var nextMonthName: String = ""
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    
    @Binding var currentMonthName: String
    
    @State var showConfirmBalance: Bool = false
    
    func onAppear() {
     
        self.setMonthName()
        self.setMonthBalance()
        
    }
    
    var body: some View {
        
        VStack {
            
            if(monthChange) {
                
                Button(action: {
                    self.showConfirmBalance = true
                }) {
                VStack (spacing: 0) {
                    HStack (spacing: 0) {
                        
                        VStack (alignment: .leading, spacing: 0) {
                          Text("Close balance month " + currentMonthName)
                                .padding(.leading, 10)
                                .padding(.top, 10)
                                .padding(.bottom, 1)
                        .font(.system(size: 15))
                        .foregroundColor(Color.white)
                   
                        
                            Text("Open balance month " + nextMonthName)
                                  .padding(.leading, 10)
                                  .padding(.bottom, 10)
                                  .padding(.top, 2)
                          .font(.system(size: 15))
                          .foregroundColor(Color.white)
                     
                        }
                        
                        Spacer()
                                Icon(content: "greaterthan", color: .blue).padding(5).padding(.leading, 5).padding(.trailing, 5)
                }
                }
                .background(Color.blue)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            
            ForEach(self.cardsFetch.indexed(), id: \.1.id) { index, card in
                
                if(card.name == "Month Available Balance") {
                    
                    if(card.visible == true && settings.showMonthBalance == true) {
                     
                        MonthBalanceView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, totalGoals: self.$totalGoals, totalPayments: self.$totalPayments, totalBudgets: self.$totalBudgets, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData)
                            .padding(.top, 10)

                         Spacer()
                    
                    }
                }
                
                if(card.name == "Accounts") {
                    
                    if(card.visible == true) {
                        AccountListView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError)
                            .padding(.top, 10)

                         Spacer()
                    }
                   
                }
                
                if(card.name == "Goals") {
                    
                    if(card.visible == true) {
                        GoalListView(totalGoals: self.$totalGoals, hideData: self.$hideData)
                           .padding(.top, 10)


                       Spacer()
                    }
                   
                }
                
                if(card.name == "Budgets") {
                    
                    if(card.visible == true) {
                        BudgetListView(totalBudgets: self.$totalBudgets, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData)
                            .padding(.top, 10)

                        Spacer()
                    }
                   
                }
                
                if(card.name == "Payments") {
                    
                    if(card.visible == true) {
                        PaymentListView(totalPayments: self.$totalPayments, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData)
                            .padding(.top, 10)

                        Spacer()
                    }
                    
                   
                }
                
                if(card.name == "Cars") {
                    
                    if(card.visible == true) {
                        CarListView()
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                   
                }
                
                if(card.name == "Chart") {
                    
                    if(card.visible == true) {
                        BalanceChart()
                            .padding(.top, 20)
                            .frame(height: 350)
                        
                    }
                }
            }
                
Divider()
            
        }
        .onAppear(){
            self.onAppear()
        }
        .alert(isPresented: $showConfirmBalance, content: { confirmBalance })
    
        
    }
    
    var confirmBalance: Alert {
        
        var text = "Are you sure you want to change the month?"
        
        if(fetchPayments.hasUnpaidPayments(viewContext: viewContext)) {
            text = "Current month has payments pending to be paid... are you sure you still want to change the month?"
        }
        
        return Alert(title: Text("New Month Balance"), message: Text(text),
            primaryButton: .default (Text("Yes")) {
            MonthBalance(viewContext: viewContext).run(totalBalance: self.totalAccounts, dayChangeMonth: settings.dayChangeMonth)
            self.setMonthName()
            self.setMonthBalance()
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
    func setMonthName () {
        let monthRequest: NSFetchRequest<Month> = Month.fetchRequest()
        monthRequest.predicate = NSPredicate(format: "current = true")
        
        do {
            let currentMonth = try viewContext.fetch(monthRequest)[0]
            self.currentMonthName = currentMonth.name! //getMonthName(monthNumber: currentMonth.month)
        } catch {
            
        }
    }
    
    func setMonthBalance () {
        let monthRequest: NSFetchRequest<Month> = Month.fetchRequest()
        monthRequest.predicate = NSPredicate(format: "current = true")
        
        let dateFormarterLabel = DateFormatter()
        dateFormarterLabel.dateFormat = "MMM y"
        
        do {
            let currentMonth = try viewContext.fetch(monthRequest)[0]
            
            var dateComponent = DateComponents()
            dateComponent.month = 1
            
           
            
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let toDate = dateFormatter.date(from:
                                                String(currentMonth.timestamp!.get(.year)) + "-" +
                                                String(currentMonth.timestamp!.get(.month)) + "-" +
                                                String(settings.dayChangeMonth))! as NSDate
            if(Date() > toDate as Date || Date().get(.month) > (currentMonth.timestamp?.get(.month))! || Date().get(.year) > (currentMonth.timestamp?.get(.year))!) {
                self.monthChange = true
            } else {
                self.monthChange = false
            }
            
            if(self.monthChange) {
                nextMonth = Calendar.current.date(byAdding: dateComponent, to: Date())
                nextMonthName = dateFormarterLabel.string(from: nextMonth!)
            } else {
                nextMonth = Date()
                nextMonthName = dateFormarterLabel.string(from: nextMonth!)
            }
            
        } catch {
            
        }
    }
}


//#if DEBUG
//struct DashboardBodyView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//       
//            DashboardBodyView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//        
//    }
//}
//#endif

