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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var passwordFetchResult: FetchedResults<Password>
    

    
    init() {
        UINavigationBar.appearance().isTranslucent = false
       }
    
 

    var body: some View {
       
        NavigationView {

          
            
            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                VStack {
                  
                   
                    SecureField("PIN", text: $pin)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                               .padding()
                        .textFieldStyle(AppTextFieldStyle())
                        .keyboardType(UIKeyboardType.decimalPad)
                    
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textFieldStyle(AppTextFieldStyle())
                    
                    Spacer()
                    
                    HStack {
                        
                      
                        
                        Button(action: {
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
                            pin = ""
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
                   
                    
                    ModalView(isShowing: $showModal, result: $result)
                   
                   
               
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
                                    }) {
                                        
                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                     
                                      
                                                       if(self.$passwordSelected.name.wrappedValue != "" && self.passwordSelected.password != "" && self.passwordSelected.code > 0) {
                                                        addPassword(password: self.$passwordSelected.wrappedValue)
                                                       }
                                            

                                        }) {
                                            PasswordAddUpdateView(password: self.$passwordSelected, modal: self.$isShowingNew, delete: self.$delete, action: $action)
                                        
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
                                                                  }) {

                                                                      VStack (spacing: 0) {
                                                                          HStack (spacing: 0) {
                                                                            Icon(content: "key", color: Color.yellow).padding(10)

                                                                              VStack (spacing: 0) {

                                                                              HStack (spacing: 0) {
                                                                                Text(item.name!)
                                                                              .font(.system(size: 15))
                                                                              .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                                                                                Spacer()

                                                                                  Text(item.password!)
                                                                              .font(.system(size: 14))
                                                                              .padding(.top, 3)
                                                                                  
                                                                                  Button(action: {
                                                                                         
                                                                                      UIPasteboard.general.string = item.password!
                                                                                      self.password = item.password!
                                                                                  }) {
                                                                                                  HStack {
                                                                                                      Image(systemName: "square.and.arrow.up")
                                                                                                  
                                                                                                  }
                                                                                              }
                                                                                  .foregroundColor(.green)
                                                                                  .padding(.trailing, 10)
                                                                                  .padding(.leading, 10)

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
                                                                          if(self.passwordSelected.password != "" && self.passwordSelected.code > 0) {
                                                                              updatePassword(password: self.$passwordSelected.wrappedValue)
                                                                          }
                                                                      }

                                                                  }) {

                                                                    PasswordAddUpdateView(password: self.$passwordSelected, modal: self.$isShowing, delete: self.$delete, action: $action)



                                                }


                                          }
                                                          .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                 
                    
          
            }
            
         
                Spacer()
         
        }
         
            }
            .padding(.top, 40)
            .navigationBarTitle("Back")
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .background(NavigationConfigurator { nc in
                let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                            nc.navigationBar.barTintColor = UIColor(color)
                        })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Passwords")
                        .font(ui.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                    
                   
                }
            }
            
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
//            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        
    }
        
//    .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
    .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
       
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




struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(10)
                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)
                .shadow(color: .gray, radius: 10)
        }
}

struct AppButtonStyle: ButtonStyle {
 
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}



struct ModalView: View {
    
    @Binding var isShowing: Bool
    @Binding var result: String
    
    @State private var curHeight: CGFloat = 600
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if(isShowing) {
                
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
             
                
            
            
           mainView
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
   
    
    var mainView: some View {
        
        VStack {
            
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            
            
            ZStack {
                VStack {
                    Text(result)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 33))
                        .foregroundColor(.black)
                        .padding()
                    
                    
                    Button(action: {
                           
                        UIPasteboard.general.string = result
                        
                    }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.title)
                                    }
                                }
                    .foregroundColor(.green)
                  
                }
                .padding(30)
            }
            .frame(maxHeight: .infinity)
            
            
           
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}


//#if DEBUG
//struct ServiceView_Previews: PreviewProvider {
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//        ServicecurrencyView(account: .constant(AccountModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//    }
//}
//#endif
