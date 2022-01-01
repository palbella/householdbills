//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct PasswordListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
    @State var save: Bool = false
    @State var delete: Bool? = false
    @State var modal: Bool = false
  
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var passwordSelected : PasswordModel = PasswordModel()
    @State var action: String = "edit"
    
    @State private var showModal = false
    
    @State private var pin: String = ""
    @State private var password: String = ""
    @State private var result: String = ""
    
    @State var passwordEncription: GetPasswordEncription = GetPasswordEncription()
    
    @Binding var listModal: Bool
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    @State var showTutorialInfoA: Bool = true
    @State var showTutorialInfoB: Bool = true
    @State var tutorial: TutorialData = TutorialData()
    
    @State var isShowingPopup: Bool = false
    @State var popupMessasge: String = ""
    @State var popupTitle: String = ""
    @State var popupImage: String = ""
 
   
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var passwordFetchResult: FetchedResults<Password>
    

    
    init(listModal: Binding<Bool>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool> ) {
        
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        self._listModal = listModal
        
        UINavigationBar.appearance().isTranslucent = false
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
       }
    
 

    var body: some View {
       
        VStack {

            ZStack {
                VStack(spacing: 0) {
            HeaderTabView(title: "Passwords", modal: $listModal, save: $save)
            HeaderTabTitleView(title: "Passwords")
            
            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                VStack {
                  
                    PinInput(label: LocalizedStringKey("Encription Code").toString(), value: $pin)
                    
                    CustomTextfield(label: "Password", text: $password, keyType: UIKeyboardType.alphabet, textAlignment: .center,
                                    maxLength: 50)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
                        .frame(maxWidth: UIScreen.screenWidth - 30)
                        .frame(height: 35)
                        .background(colorScheme != .dark ? Color(UIColor.white): Color(UIColor.systemGray2))
                        .cornerRadius(5)
                        .shadow(color: .gray, radius: 0.5)
                               .padding()
                               .padding(.bottom, 0)
                               .padding(.top, 0)
                    
                    

                    
                    Spacer()
                    
                    HStack {
                        
                      
                        
                        Button(action: {
                            tutorial.saveTutorial(name: "password", tutorialStep: 1)
                            unlock(pin: pin, password: password)
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "lock.open")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())
                      
                        
                        
                        Button(action: {
                            lock(pin: pin, password: password)
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "lock")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())
                     
                        
                        Button(action: {
                            password = ""
//                            self.pin = ""
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "clear")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())
                 
                    }
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                   
                    
                    ModalView(isShowing: $showModal, result: $result, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                   
                   
               
                }
                
                Section(header:
                            HStack {
                                VStack{
                                  
                                Text("Passwords")
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
                                        self.action = "add"
                                        self.passwordSelected = PasswordModel()
                                        self.isShowingNew = true
                                        self.delete = nil
                                        self.save = false
                                    }) {
                                        
                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                     
                                        if(settings.fastApply || self.save) {
                                                       if(self.$passwordSelected.name.wrappedValue != "" && self.passwordSelected.password != "" && self.passwordSelected.code  != "") {
                                                        addPassword(password: self.$passwordSelected.wrappedValue)
                                                           tutorial.saveTutorial(name: "password", tutorialStep: 0)
                                                       }
                                        }
                                            

                                        }) {
                                            PasswordAddUpdateView(password: self.$passwordSelected, modal: self.$isShowingNew, save: self.$save, delete: self.$delete, action: $action, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                                        
                                    }
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 17)
                                    .padding(.bottom, 12)
                                }
                               
                            }
                            .padding(.top, 10)
                          
                            
                ) {

                    Divider()
                    
                   
                    ForEach(self.passwordFetchResult.indexed(), id: \.1.id) { index, item in


                                                                  Button(action: {
                                                                    self.passwordSelected = map(password: item)
                                                                      self.passwordSelected.password = ""
                                                                      self.action = "edit"
                                                                      self.delete = false
                                                                      self.isShowing = true
                                                                      self.save = false
                                                                  }) {

                                                                      VStack (spacing: 0) {
                                                                          HStack (spacing: 0) {
                                                                            Icon(content: "key", color: Color.yellow).padding(10)

                                                                              VStack (spacing: 0) {

                                                                              HStack (spacing: 0) {
                                                                                Text(item.name!)
                                                                                      .multilineTextAlignment(.leading)
                                                                                  
                                                                              .font(.system(size: 15))
                                                                              .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                                              .frame(width: 130, alignment: .leading)

                                                                                Spacer()

                                                                                  Text(item.password!)
                                                                              .font(.system(size: 12))
                                                                              .padding(.top, 3)
                                                                                  
                                                                                  Button(action: {
                                                                                         
                                                                                      UIPasteboard.general.string = item.password!
                                                                                      self.password = item.password!
                                                                                      self.toastMessasge = "Copied"
                                                                                      self.toastError = false
                                                                                      self.isShowingToast = true
                                                                                  }) {
                                                                                                  HStack {
                                                                                                      Image(systemName: "square.and.arrow.up")
                                                                                                  
                                                                                                  }
                                                                                              }
                                                                                  .foregroundColor(.green)
                                                                                  .padding(.trailing, 15)
                                                                                  .padding(.leading, 15)

                                                                              }

                                                                              }
                                                                      }
                                                                      .frame(maxWidth: .infinity)

                                                                      }

                                                                  }
                                                                  .sheet(isPresented: self.$isShowing, onDismiss: {


                                                                    if(self.delete == true) {
                                                                          deletePassword(password: self.$passwordSelected.wrappedValue)
                                                                      } else {
                                                                          if(settings.fastApply || self.save) {
                                                                          if(self.passwordSelected.password != "" && self.passwordSelected.code  != "") {
                                                                              updatePassword(password: self.$passwordSelected.wrappedValue)
                                                                          }
                                                                          }
                                                                      }

                                                                  }) {

                                                                    PasswordAddUpdateView(password: self.$passwordSelected, modal: self.$isShowing, save: self.$save, delete: self.$delete, action: $action, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)



                                                }


                                          }
                                                          .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                 
                    
          
            }
            
         
                Spacer()
         
        }
         
            }
            .padding(.top, settings.fastApply ? 40 : 0)
                }
                PopUpWindow(isShowingPopup: $isShowingPopup, popupTitle: $popupTitle, popupMessasge: $popupMessasge, popupImage: $popupImage)
            }
        
    }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        .onAppear(){
            showTutorial()
        }

    .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
       
    }
    
    
    func showTutorial() {
        
        self.showTutorialInfoA = tutorial.needTutorial(name: "password", tutorialStep: 0)
        if( self.showTutorialInfoA == true) {
            self.popupTitle = "Tutorial"
            self.popupMessasge = LocalizedStringKey("tutorial7-planning").toString()
            self.popupImage = "tutorial7"
            self.isShowingPopup = self.showTutorialInfoA
        }
        
        self.showTutorialInfoB = tutorial.needTutorial(name: "password", tutorialStep: 1)
        if( self.showTutorialInfoB == true && self.showTutorialInfoA == false) {
            self.popupTitle = "Tutorial"
            self.popupMessasge = LocalizedStringKey("tutorial8-planning").toString()
            self.popupImage = "tutorial8"
            self.isShowingPopup = self.showTutorialInfoB
        }
        
    }

    func unlock (pin: String, password: String) {
        
        if(!pin.isEmpty) {
            result = passwordEncription.Desentrypt(pin: pin, password: password)
        }
        
        showModal = true
    }
    
    func lock (pin: String, password: String) {
        
        if(!pin.isEmpty) {
            result = passwordEncription.Entrypt(pin: pin, password: password)
        }
        
        showModal = true
    }
    
    
    private func addPassword(password: PasswordModel)
    {

            withAnimation {
               
                let newPassword = Password(context: viewContext)
                newPassword.id = UUID()
                newPassword.name = password.name
                newPassword.password = passwordEncription.Entrypt(pin: String(password.code), password: password.password)


      SaveContext()
            }

    }

    private func updatePassword(password: PasswordModel)
    {


        do {
                let request: NSFetchRequest<Password> = Password.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", password.id as CVarArg)

                let savedPassword = try  self.viewContext.fetch(request)[0]

            savedPassword.name = password.name
            savedPassword.password = passwordEncription.Entrypt(pin: String(password.code), password: password.password) 
       



        } catch {
            print(error)
        }

      SaveContext()


    }
    
    private func deletePassword(password: PasswordModel)
    {
            withAnimation {

                let request: NSFetchRequest<Password> = Password.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", password.id as CVarArg)

                    do {
                        let savedPasswords = try  self.viewContext.fetch(request)

                        for item in savedPasswords {
                            self.viewContext.delete(item)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }

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

    private func map(password: Password) -> PasswordModel
    {
        var passwordModel = PasswordModel()

        passwordModel.id = password.id!
        passwordModel.name = password.name ?? ""
        passwordModel.password = password.password ?? ""
     


        return passwordModel
    }
    
    
}





struct ModalView: View {
    
    @Binding var isShowing: Bool
    @Binding var result: String
    
    @State private var curHeight: CGFloat = 600
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if(isShowing) {
                
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
             
                
            
            
                VStack {
                    
                    ZStack {
                        Capsule()
                            .frame(width: 40, height: 6)
                            .padding(.top, 10)
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.00001))
                    
                    
//                    ZStack {
                        VStack {
                            Text(result)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 33))
                                .foregroundColor(.black)
                                .padding()
                            
                            
                            Button(action: {
                                   
                                UIPasteboard.general.string = result
                                self.toastMessasge = "Copied"
                                self.toastError = false
                                self.isShowingToast = true
                                
                            }) {
                                          
                                                Image(systemName: "square.and.arrow.up")
                                                    .font(.title)
                                                  
                                        }
                            .foregroundColor(.green)
                                
                            Text("")
                                .padding()
                               
                                Button(action: {
                                       
                                    self.isShowing = false
                                    
                                }) {
                                               
                                                    Image(systemName: "chevron.down.square")
                                                        .font(.title)
                               
                                                
                                            }
                                .foregroundColor(Color.black)
                            
                           Spacer()
                          
                        }
//                        .padding(30)
//
//                    }
//                    .frame(maxHeight: .infinity)
                    
                    
                   
                }
                .frame(height: curHeight)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            .transition(.move(edge: .bottom))
            }
  
        }
        .ignoresSafeArea()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,  maxHeight: .infinity, alignment: .bottom)
        .animation(.easeInOut)
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                                if value.translation.width < 0 {
                                    // left
                                }

                                if value.translation.width > 0 {
                                    // right
                                }
                                if value.translation.height < 0 {
                                    // up
                                }

                                if value.translation.height > 0 {
                                    isShowing = false
                                    result = ""
                                }
                            }))
        .onChange(of: scenePhase) { newPhase in
                        if newPhase == .inactive {

                        } else if newPhase == .active {
                           
                        } else if newPhase == .background {
                            result = ""
                            isShowing = false
                        }
                    }
     
    }
   
    
 
}


//#if DEBUG
//struct ServiceView_Previews: PreviewProvider {
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//        ModalView(account: .constant(AccountModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//    }
//}
//#endif
