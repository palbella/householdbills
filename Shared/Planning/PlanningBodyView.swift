//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct PlanningBodyView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var delete: Bool = false
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()

    @State var totalPayments: Double = 0
    @State var totalBudgets: Double = 0
     
    var body: some View {
        
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
      
        VStack(spacing: 0) {
        Section(header:
                    HStack {
                        VStack{
                            Spacer()
                        Text("MONTHLY ESTIMATED INCOME")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                        .font(.system(size: 12))
                        .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                        }
                        
                        
                       
                    }
                  
                    
        ){
        VStack(spacing: 0) {
            Spacer()
        Divider()
            DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Estimated Income", value: $settings.estimatedMontlyIncomes)
                   .onChange(of: settings.estimatedMontlyIncomes, perform: { value in
                    do {
                    let savedSettings =  try viewContext.fetch(fetchRequest)
                        
                        if(savedSettings.count == 1) {
                            
                            savedSettings[0].monthIncome = settings.estimatedMontlyIncomes

                            SaveContext()
                        }
                       
                    } catch {
                        print(error)
                    }
                   })
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
       
            HStack (spacing: 0) {
                Text("   ")
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                  
             
            Text("Unassigned Amount")
                .foregroundColor(labelColor)
                    
            Spacer()
                Text(String(settings.estimatedMontlyIncomes - totalPayments - totalBudgets))
                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                    
                
   
                
        }
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
           
            
                        HStack (spacing: 0) {
                            Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                .padding(.top, 15)
                                .padding(.bottom, 15)
            
                        Text("Budgets")
                            .foregroundColor(labelColor)
                            .frame(width: 80, height: 30, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 15))

                            
            
                        Spacer()
                            Text("budget-info")
                            .padding(5).padding(.leading, 5).padding(.trailing, 5)
                            .multilineTextAlignment(.leading)
                                .font(.system(size: 12))
                                .fixedSize(horizontal: false, vertical: true)
            
            
            
                    }
                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
            
            HStack (spacing: 0) {
                Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)
                    .padding(.top, 15)
                    .padding(.bottom, 15)

            Text("Payments")
                .foregroundColor(labelColor)
                .frame(width: 80, height: 30, alignment: .leading)
                .multilineTextAlignment(.leading)
                .font(.system(size: 15))

            Spacer()
                Text("payment-info")
                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .fixedSize(horizontal: false, vertical: true)

        }
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
            
            
            HStack (spacing: 0) {
                Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)
                    .padding(.top, 15)
                    .padding(.bottom, 15)

            Text("Goals")
                .foregroundColor(labelColor)
                .frame(width: 80, height: 30, alignment: .leading)
                .multilineTextAlignment(.leading)
                .font(.system(size: 15))

            Spacer()
                Text("goal-info")
                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .fixedSize(horizontal: false, vertical: true)


        }
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                        Divider()
                        Spacer()
            
            Spacer()
        }
      
       
        }
        
        PlanningBudgetBodyView(totalBudgets: self.$totalBudgets)
        PlanningPaymentBodyView(totalPayments: self.$totalPayments)
           Spacer()
            
       
            
            VStack{
                Spacer()
                
                Button(action: {
                    MonthBalance(viewContext: viewContext).syncMonth()
                    self.toastMessasge = "Month Syncronized!"
                    self.toastError = false
                    self.isShowingToast = true
                }) {
                    HStack {
                        Text("Syncronize with current month")
                    }
                    .padding()
                    .frame(width: 230, height: 30)
                    .font(.system(size: 12))
                    .foregroundColor(Color.white)
                    .background(ui.lightPrimaryColor)
                    .cornerRadius(5)
                }.padding(.bottom, 40)
                    .padding(.top, 40)
                
            }
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
           

        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
       
       
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
//struct PlanningBodyView_Previews: PreviewProvider {
//    
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//        PlanningBodyView().environmentObject(UserSettings())
//            .environmentObject(AppUI())
//            .environment(\.managedObjectContext, viewContext)
//    }
//}
//#endif
