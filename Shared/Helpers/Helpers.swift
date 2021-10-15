//
//  Helpers.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import MessageUI


class EmailHelper: NSObject {
    static let shared = EmailHelper()
    private override init() {}
}


func getColor(color: String) -> Color
{
 
    
    if(color == "red") {
        return Color.red
    }
        
    
    if(color == "blue") {
        return Color.blue
    }
       
    
    if(color == "yellow") {
        return Color.yellow
    }
        
    
    if(color == "green") {
        return Color.green
    }
    
    if(color == "orange") {
        return Color.orange
    }
    
    if(color == "purple") {
        return Color.purple
    }
    
    if(color == "gray") {
        return Color.gray
    }
    
    if(color == "lightBlue") {
        return Color(UIColor(red: 130,green: 190,blue: 255))
    }
    if(color == "darkBlue") {
        return Color(UIColor(red: 6,green: 9,blue: 101))
    }
    if(color == "lightRed") {
        return Color(UIColor(red: 255,green: 153,blue: 153))
    }
    if(color == "darkRed") {
        return Color(UIColor(red: 202,green: 0,blue: 0))
    }
    if(color == "brown") {
        return Color(UIColor(red: 102,green: 51,blue: 0))
    }

    return Color.blue
}

func getMonthName(monthNumber: Int32) -> String {
    
    if (monthNumber == 1) {
        return "January"
    }
    if (monthNumber == 2) {
        return "February"
    }
    if (monthNumber == 3) {
        return "March"
    }
    if (monthNumber == 4) {
        return "April"
    }
    if (monthNumber == 5) {
        return "May"
    }
    if (monthNumber == 6) {
        return "June"
    }
    if (monthNumber == 7) {
        return "July"
    }
    if (monthNumber == 8) {
        return "August"
    }
    if (monthNumber == 9) {
        return "September"
    }
    if (monthNumber == 10) {
        return "October"
    }
    if (monthNumber == 11) {
        return "November"
    }
    if (monthNumber == 12) {
        return "December"
    }
    
    return ""
}


extension EmailHelper {
    
    /// Remember to add the below code to Info.plist
    ///    <key>LSApplicationQueriesSchemes</key>
    ///    <array>
    ///       <string>googlegmail</string>
    ///    </array>
    func send(subject: String, body: String, to: [String]) {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        if !MFMailComposeViewController.canSendMail() {
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let mails = to.joined(separator: ",")
            
            let alert = UIAlertController(title: "Cannot open Mail!", message: "", preferredStyle: .actionSheet)
            
            var haveExternalMailbox = false
            
            if let defaultUrl = URL(string: "mailto:\(mails)?subject=\(subjectEncoded)&body=\(bodyEncoded)"),
               UIApplication.shared.canOpenURL(defaultUrl) {
                haveExternalMailbox = true
                alert.addAction(UIAlertAction(title: "Mail", style: .default, handler: { (action) in
                    UIApplication.shared.open(defaultUrl)
                }))
            }
            
            if let gmailUrl = URL(string: "googlegmail://co?to=\(mails)&subject=\(subjectEncoded)&body=\(bodyEncoded)"),
               UIApplication.shared.canOpenURL(gmailUrl) {
                haveExternalMailbox = true
                alert.addAction(UIAlertAction(title: "Gmail", style: .default, handler: { (action) in
                    UIApplication.shared.open(gmailUrl)
                }))
            }
            
            if haveExternalMailbox {
                alert.message = "Would you like to open an external mailbox?"
            } else {
                alert.message = "Please add your mail to Settings before using the mail service."
                
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsUrl) {
                    alert.addAction(UIAlertAction(title: "Open Settings App", style: .default, handler: { (action) in
                        UIApplication.shared.open(settingsUrl)
                    }))
                }
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
            return
        }
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(body, isHTML: false)
        mailCompose.setToRecipients(to)
        mailCompose.mailComposeDelegate = self
        
        viewController.present(mailCompose, animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension EmailHelper: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


func removeTimeStamp(fromDate: Date) -> Date {
   guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
       fatalError("Failed to strip time from Date object")
   }
   return date
}
