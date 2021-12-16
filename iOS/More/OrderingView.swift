//
//  OrderingView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/4/21.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData

struct OrderingView: View {
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var items : [String]
    @State var draggedItem : String?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)])
    var cardsFetch: FetchedResults<Card>
    
    @Binding var modal: Bool
    @Binding var save: Bool
    
    @State var showTutorialInfo: Bool = true
    @State var tutorial: TutorialData = TutorialData()
    
    @State var isShowingPopup: Bool = false
    @State var popupMessasge: String = ""
    @State var popupTitle: String = ""
    @State var popupImage: String = ""
    
    init(items: Binding<[String]> , modal: Binding<Bool>, save: Binding<Bool>) {
        
           self._items = items
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
        
        self.showTutorial()
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 0) {
            HeaderTabTitleView(title: "Cards Order")
         
        LazyVStack(spacing : 15) {
            ForEach(items, id:\.self) { item in
                
                HStack {
//                    Image(systemName: "line.horizontal.3")
//                                    .foregroundColor(.blue)
//                        .font(.system(size: 15, weight: .heavy))
//                        .padding()
                    
                    Text(item)
                        .frame(minWidth:0, maxWidth:.infinity, minHeight:50)
                    
//                    CheckBoxView(checked: $checked)
                }
                .background(colorScheme != .dark ? ui.lightItemBackgroundColor: Color(UIColor.systemGray5))
                .onDrag({
                self.draggedItem = item
                return NSItemProvider(item: nil, typeIdentifier: item)
                }) .onDrop(of: [UTType.text], delegate: MyDropDelegate(viewContext: viewContext, item: item, items: $items, draggedItem: $draggedItem))
                  
                 
            }
          
        }
            Spacer()
                }
                PopUpWindow(isShowingPopup: $isShowingPopup, popupTitle: $popupTitle, popupMessasge: $popupMessasge, popupImage: $popupImage)
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
                Text("Cards Order")
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
        .background(colorScheme != .dark ? ui.darkItemBackgroundColor: ui.darkBackgroundColor)
        }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .onAppear {
            self.onAppear()
            getCards()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            getCards()
        
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            getCards()
            }
        
    }
    
    
    func showTutorial() {
        
        self.showTutorialInfo = tutorial.needTutorial(name: "cards", tutorialStep: 0)
        if( self.showTutorialInfo == true) {
            self.popupTitle = "Tutorial"
            self.popupMessasge = LocalizedStringKey("tutorial6-planning").toString()
            self.popupImage = "tutorial6"
            self.isShowingPopup = self.showTutorialInfo
            tutorial.saveTutorial(name: "cards", tutorialStep: 0)
        }
        
    }
    
    func getCards()
    {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        self.items = [String]()
        
        do {
            let savedCards =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedCards.count {
                                let card = self.cardsFetch[index]
                                self.items.append(card.name! as String)
                                    }
        } catch {
           
        }

    }
    

}

struct MyDropDelegate : DropDelegate {

    
    @State var viewContext: NSManagedObjectContext
    
    let item : String
    @Binding var items : [String]
    @Binding var draggedItem : String?

    func performDrop(info: DropInfo) -> Bool {
        
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }

        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
    
    
 
}


//struct CheckBoxView: View {
//    @Binding var checked: Bool
//
//    var body: some View {
//        Image(systemName: checked ? "checkmark.square.fill" : "square")
//            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
//            .onTapGesture {
//                self.checked.toggle()
//            }
//    }
//}
