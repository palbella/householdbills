//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct TermsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.presentationMode) var presentationMode
  
    @Binding var back: Bool
    @State var save: Bool = false
    
    func onAppear() {
   
    }
    
    var body: some View {
        
        
            VStack {
            
                VStack(spacing: 0) {
                Spacer()
                HStack {
                    
                        Button("Done") {
                                self.back = false
                                self.save = true
                  
                  
                    }
                        .font(Font.body)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                        .padding(.bottom, 17)
                        .padding(.leading, 15)
                   
                    Spacer()
                    Text("Terms and Conditions")
                        .font(ui.title)
                        .font(.system(size: 30, weight: .heavy, design: .default))
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                        .padding(.bottom, 13)
                    Spacer()
                    Button("    ") {
      
              
                }
                    .font(Font.body)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                    .padding(.bottom, 17)
                    .padding(.trailing, 15)
                   
                }
                    
                Divider()
            }
                .frame(height: 55, alignment: .leading)
            .background(colorScheme != .dark ? Color.white: ui.darkBackgroundColor)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 0) {
//                    1
                    VStack {
                        Text("1. INTERPRETATION AND DEFINITIONS")
                            .font(.system(size: 15))
                            .foregroundColor(ui.lightPrimaryColor)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                        
                    VStack (spacing: 0) {
                    Text("1.1 INTERPRETATION: The words in the definition section have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                    
                        Text("1.2 DEFINITIONS:")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                        
                    Text("- Account: means a unique account created for You to access our Service or parts of our Service.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("- Application: means the software program provided by the Company downloaded by You on any electronic device, named Household Bills.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("- Company: (referred to as either the Company, We, Us or Our in this Agreement) refers to the company has developed the Application.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("- Country: refers to Argentina")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("- Device: means any device that can access the Service such as a computer, a cell phone or a digital tablet.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("- Personal Data: is any information that relates to an identified or identifiable individual.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("- Service: refers to the Website or Application.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                   
                    }
                    
                    VStack (spacing: 0) {
                    Text("- Service Provider: means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("- Usage Data: refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("- You: means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("- User: means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.")
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                   
                    }
                    }
                    .padding()
                    
                    //                    2
                                        VStack {
                                            Text("2. ACCEPTANCE")
                                                .font(.system(size: 15))
                                                .foregroundColor(ui.lightPrimaryColor)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                           
                                            
                                        VStack (spacing: 0) {
                                        Text("2.1. In order to use the Application, You must first accept this Agreement. If You do not or cannot accept this Agreement, You are not permitted to use the Application or Services. Do not download or use the Application or Services in that case. You accept and agree to the terms of this Agreement on Your own behalf and/or on behalf of Your company, organization, educational institution, or agency, instrumentality, or department of the federal government as its authorized legal representative, by doing either of the following:")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                            
                                        Text("(a) checking the box displayed at the end of this Agreement if You are reading this on an Login or registration page.")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("(b) clicking an “Agree” or similar button, where this option is provided by the Application.")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)

                                        }
                                        
                                    
                                        }
                                        .padding()
                                        
                    
                    //                    3
                                        VStack {
                                            Text("3. COMPANY OVERVIEW")
                                                .font(.system(size: 15))
                                                .foregroundColor(ui.lightPrimaryColor)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                             
                                            
                                        VStack (spacing: 0) {
                                        Text("3.1. The Application is a personal financial management platform conceived to assist the education and management of money on a daily basis, by which the User can control his incomes and expenses from his phone, tablet or computer.")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                            
                                            Text("3.2. By accepting the present Term, the User declares that has civil capacity or, in case of not having, the User was assisted by a civil apt person when agreeing to the following conditions, according to the Argentinian Civil Code.")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                            
                                            
                                            Text("3.3. If you are between 16 years old and under 18 years old, and intend to use our products and services, you should review these Terms of Use with your parent or legal guardian to ensure that you understand all of the conditions set out herein.")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                                
                                                Text("3.4. By agreeing to these Terms you declare that you have at least 16 years old. If you are under 16 years old, this terms must be agree by your parents before using it.")
                                                        .font(.system(size: 13))
                                                        .multilineTextAlignment(.leading)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.top, 10)

                                        }
                                        
                                    
                                        }
                                        .padding()
                                        
                    //                    4
                                        VStack {
                                            Text("4. USING THE APPLICATION")
                                                .font(.system(size: 15))
                                                .foregroundColor(ui.lightPrimaryColor)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        VStack (spacing: 0) {
                                        Text("4.1. While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                        
                                       
                                            
                                        Text("- Email address")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- First name and last name")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- Phone number")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- Address, State, Province, ZIP/Postal code, City")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- Usage Data")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                         
                                        
                                            Text("4.2. While using Our Application, in order to provide features of Our Application, We may collect, all the financial data You want to store and save in the application.")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                            
                                            Text("4.3. Usage Data may include also information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data, We may also collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data. We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                            
                                            Text("4.4. We use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the Company's servers and/or a Service Provider's server or it may be simply stored on Your device")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                            
                                            Text("4.5. The User may register for free with the Application, opting, if he or she wishes, for the Subscription Plan, which allows the charging of a monetary value due to the benefits added to this type of account.")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                            
                                          
                                       
                                        }
                                        
                                        VStack (spacing: 0) {
                                            Text("4.6. The Application reserves the right to start charging the User due to the services received as a Subscription Plan Account, through prior notice that allows the User decides whether to continue using the platform.")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                        
                                       
                                        }
                                        }
                                        .padding()
                    
                    //                    5
                                        VStack {
                                            Text("5. USE OF YOU PERSONAL DATA")
                                                .font(.system(size: 15))
                                                .foregroundColor(ui.lightPrimaryColor)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        VStack (spacing: 0) {
                                        Text("5.1. The Company may use Personal Data for the following purposes:")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                        
                                       
                                            
                                        Text("- To provide and maintain our Service, including to monitor the usage of our Service.")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        Text("- To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.")
                                                .font(.system(size: 10))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                         
                                        
                                           
                                            Text("- To manage Your requests: To attend and manage Your requests to Us.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                          
                                       
                                        }
                                        
                                        VStack (spacing: 0) {
                                            Text("- For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                            Text("- For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience. We may share Your personal information in the following situations:")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("- With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, for payment processing, to contact You.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("- For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("- With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                            Text("- With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("- With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("- With Your consent: We may disclose Your personal information for any other purpose with Your consent.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                       
                                        }
                                        }
                                        .padding()
                    
                    //                    6
                                        VStack {
                                            Text("6. RETENTION OF YOUR PERSONAL DATA")
                                                .font(.system(size: 15))
                                                .foregroundColor(ui.lightPrimaryColor)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                             
                                            
                                        VStack (spacing: 0) {
                                        Text("6.1. The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.")
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 10)
                                            
                                            Text("6.2. The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                            

                                        }
                                        
                                    
                                        }
                                        .padding()
                    
                    //                    7
                    VStack {
                        Text("7. TRANSFER OF YOUR PERSONAL DATA")
                            .font(.system(size: 15))
                            .foregroundColor(ui.lightPrimaryColor)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                         
                        
                    VStack (spacing: 0) {
                    Text("7.1. Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction. Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                        
                        Text("7.2. The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.")
                                .font(.system(size: 13))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                        

                    }
                    
                
                    }
                    .padding()
                        
                        
                        //                    8
                        VStack {
                            Text("8. DISCLOSURE OF YOUR PERSONAL DATA")
                                .font(.system(size: 15))
                                .foregroundColor(ui.lightPrimaryColor)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                             
                            
                        VStack (spacing: 0) {
                        Text("8.1. Business Transactions: If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.")
                                .font(.system(size: 13))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                            
                            Text("8.2. Law enforcement: Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                            Text("8.3. Other legal requirements: The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                            Text("- Comply with a legal obligation")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("- Protect and defend the rights or property of the Company")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("- Prevent or investigate possible wrongdoing in connection with the Service")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("- Protect the personal safety of Users of the Service or the public")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("- Protect against legal liability")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                        }
                        
                    
                        }
                        .padding()
                        
                        
                        //                    9
                        VStack {
                            Text("9. SECURITY OF YOUR PERSONAL DATA")
                                .font(.system(size: 15))
                                .foregroundColor(ui.lightPrimaryColor)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                             
                            
                        VStack (spacing: 0) {
                        Text("9.1. Banking Integration: The application DO NOT INTEGRATE with any bank entity, the Application will never ask you for credentials or sensitive information than can put a risk your bank accounts. It is user responsability to not use in the application any information that could compromise the security of your accounts or anything else.")
                                .font(.system(size: 13))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                            
                            Text("9.2. The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                            Text("9.3. The Service Providers We use may have access to Your Personal Data. These third-party vendors collect, store, use, process and transfer information about Your activity on Our Service in accordance with their Privacy Policies. We may use third-party Service providers to monitor and analyze the use of our Service.")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                            Text("- Apple")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("9.4. Email Marketing: We may use Your Personal Data to contact You with newsletters, marketing or promotional materials and other information that may be of interest to You. You may opt-out of receiving any, or all, of these communications from Us by following the unsubscribe link or instructions provided in any email We send or by contacting Us.")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                            Text("- Apple")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("9.5. The application will not have access to your financial data located in banks or institutions, only the information that the user input in the application will be stored using the Apple Cloud Storage. This information can be shared to other devices with the same Apple ID, user must not input any data that do not to share with other user devices.")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                            Text("9.6. The User is the unique responsible for every data and information that he inserts on his own account and The application is not in charge of verifying the veracity of the personal data inserted.")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                            Text("9.7. Although the application makes all possible efforts to improve experience and storage of data, it is not possible to guarantee that the entered information will be available during all the usage time of the company’s platform. It is possible that the entered information be deleted, eventually, without advance notice and, because of that, the User is the solely responsible for maintaining copies of all the data and reports elaborated by the application that he wishes to keep.")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                            
                           

                        }
                            
                            VStack (spacing: 0) {
                          
                                
                                Text("9.8. The application will not be responsible, no matter what was the type of account chosen by the User, under no circumstances for any damage arising from:")
                                        .font(.system(size: 13))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 10)
                                
                                Text("-Misusing of the platform by the User;")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("-Poor connection with internet;")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("-Interruption of the transmission, diffusion, availability, reception, acquiring and access to information; ")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("-Any other interruptions of access to the platform, no matter what or who is responsible for causing it.")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                               
                                
                                Text("9.9. The application will not be held responsible, under no circumstances, for the User’s decision based on any report or data provided by the platform, since is not your obligation to deliberate about the User’s choices.")
                                        .font(.system(size: 13))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 10)
                                
                                Text("9.10. Users are fully responsible the data stored on the application, and the application will not be held responsible for the products and services delivered by third parties, even if integrated with the application.")
                                        .font(.system(size: 13))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 10)

                            }
                            
                    
                        }
                        .padding()
                        
                        //                    10
                                            VStack {
                                                Text("10. CHANGES TO THIS PRIVACY POLICY")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(ui.lightPrimaryColor)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                               
                                                
                                            VStack (spacing: 0) {
                                            Text("10.1. We may update Our Privacy Policy from time to time without any notification to You of any changes by posting the new Privacy Policy on this page. You must review this agreement time to time, prior to the change becoming effective and stop using the application if you are not agree of any new terms.")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                                
                                            Text("You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.")
                                                    .font(.system(size: 10))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                

                                            }
                                            
                                        
                                            }
                                            .padding()
                        
                    }
                    
                    VStack(spacing: 0) {
                        //                    11
                                            VStack {
                                                Text("11. CHILDREN'S PRIVACY")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(ui.lightPrimaryColor)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                               
                                                
                                            VStack (spacing: 0) {
                                            Text("11.1. Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                                

                                            }
                                            
                                        
                                            }
                                            .padding()
                        
                        //                    12
                                            VStack {
                                                Text("12. PAYMENT METHODS AND PERIODICITY")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(ui.lightPrimaryColor)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                               
                                                
                                            VStack (spacing: 0) {
                                            Text("12.1. If the User chooses the Subscribe Account, he can be paid by credit card or barcode. The payment made by barcode will only be available with the total amount of the annual plan.")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                                
                                                Text("12.2. The services of the Subscription Account will only be available when the application has verified the payment of the respective amount, which can take few business days.")
                                                        .font(.system(size: 13))
                                                        .multilineTextAlignment(.leading)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.top, 10)
                                                
                                                Text("12.3. If the User chooses not to renew his subscription after the end of the plan, all exclusive features will be automatically disabled and, in the same away, every information provided by the platform may be deleted without advance notice.")
                                                        .font(.system(size: 13))
                                                        .multilineTextAlignment(.leading)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.top, 10)
                                                
                                            
                                                

                                            }
                                            
                                        
                                            }
                                            .padding()
                        
                        //                    13
                                            VStack {
                                                Text("13. DISPUTES")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(ui.lightPrimaryColor)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                               
                                                
                                            VStack (spacing: 0) {
                                            Text("13.1. By accepting these terms, the User agrees that the laws of Argentina, without regard to principles of conflict laws, will govern these terms of service, or any dispute of any sort that might come between Household Bills and the User.")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                                
                                                Text("13.2 Any dispute related in any way to the access to this platform or services provided by the application shall be arbitrated by state or federal courts located in Cordoba, Cordoba, Argentina, and the User consents to exclusive jurisdiction and venue of such courts.")
                                                        .font(.system(size: 13))
                                                        .multilineTextAlignment(.leading)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.top, 10)
                                                
                                            
                                                
                                            
                                                

                                            }
                                            
                                        
                                            }
                                            .padding()
                        
                        
                        //                    Contact
                                            VStack {
                                                Text("CONTACT US")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(ui.lightPrimaryColor)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                               
                                                
                                            VStack (spacing: 0) {
                                            Text("If you have any questions about this Privacy Policy, You can contact us by sending us an email: householdbills.app@gmail.com")
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 10)
                                                
                                      
                                                
                                            
                                                
                                            
                                                

                                            }
                                            
                                        
                                            }
                                            .padding()
                    }
                    
                }
            }
            .onAppear() {
                self.onAppear()
               
            }
            .background(ui.lightBackgroundColor)
        }
       
     
        
        
       

}
