//
//  TransactionFilterView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/9/21.
//

import SwiftUI

struct TransactionFilterView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var filters: TransactionFiltersModel
    
    @State private var showConfirm = false
    @ObservedObject var fetchCategories = FetchCategories()
    @State var categories = GetCategories ()
    
    @State var categoryIndex: Int = 0
    @State var categoryList: [String] = []
    @State var categorySelected: String? = ""

    
    init(filters: Binding<TransactionFiltersModel>) {
        self._filters = filters
     
        
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.categories.items = fetchCategories.fetch(viewContext: viewContext)
     
    }
    
    var body: some View {
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
        
        NavigationView {
            
        Form {
            
            TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Description", value: $filters.name)
            DateInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "From", value: self.$filters.startDate)
            DateInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "To", value: self.$filters.endDate)
            TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Account", value: $filters.account)
            
            
            Picker("Category", selection: $filters.category) {
                ForEach(categories.items) { item in
                    Text(item.name).tag(item.id)
                    }
                        }
            .padding()
            
  
            
          
        }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Transaction Filters")
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            }
        }
        .onAppear(){
            self.onAppear()
        }
        }
        
        
           
    
}
   
}
