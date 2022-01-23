//
//  GoalAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/2/21.
//

import SwiftUI

struct GoalAdjustmentView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
    @Binding var goal: UUID?
    @Binding var amount: Double
    @Binding var modal: Bool
    @Binding var save: Bool
    
    
    @Binding var goals : GetGoals
    @State var goalData: GoalData = GoalData()
    
    @State var goalIndex: Int = 0
    @State var goalList: [String] = []
    @State var goalSelected: String? = ""
    
    init(goals: Binding<GetGoals>, goal: Binding<UUID?>, amount: Binding<Double>, modal: Binding<Bool>, save: Binding<Bool> ) {
        
           self._goal = goal
        self._goals = goals
           self._amount = amount
        self._modal = modal
        self._save = save
     
        
        UINavigationBar.appearance().isTranslucent = false
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
       }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.goals.items = goalData.fetch()
        
        goalList = ["None"]
        for index in 0..<goals.items.count {
            goalList.append(goals.items[index].name)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
            
            HeaderTabTitleView(title: "Goal Adjustment")
        Form {
        VStack {
            
            let amountColor = self.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
            
            Text(settings.symbol + " ")
                .font(.system(size: 18))
                .foregroundColor(amountColor) +
            Text("\((self.amount), specifier: "%.2f")")
                .font(.system(size: 18))
                .foregroundColor(amountColor)
            
            Divider()
           
            PickerInput(iconContent: "", iconColor: .blue, label: "Goal", placeholder: LocalizedStringKey("Goal").toString(), data: $goalList, value: $goalSelected, index: $goalIndex)
                .onChange(of: goalIndex, perform: { value in
                    if(goalIndex > 0) {
                        self.goal = goals.items[goalIndex - 1].id
                    } else {
                        self.goal = nil
                    }
                })
                .padding(.bottom, 5)
            
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
                Text("Goal Adjustment")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                     
                                            self.modal = false
                                            self.save = true
                                      
                                    }
                }
                                }
        }
        .onAppear() {
            self.onAppear()
        }
            }
        
    }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
    }
}
