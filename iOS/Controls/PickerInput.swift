//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct PickerInput: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    var iconContent: String
    var iconColor: Color
  
    var label: String
    var placeholder: String
    @Binding var data: [String]
    @Binding var value: String?
    @Binding var index: Int
   
  
    var body: some View {
       
            HStack (spacing: 0) {
                if(iconContent != "") {
                    Icon(content: iconContent, color: iconColor).padding(5).padding(.leading, 5).padding(.trailing, 5)
                } else {
                    Text("   ")
                }
              
                  
             
                Text(LocalizedStringKey(label))
            
                    
            Spacer()
                TextFieldWithInputView(data: self.data, placeholder: placeholder, selectionIndex: self.$index, selectedText: self.$value)
                    .padding(.trailing, 10)
                   
                    
                
        }
//        .frame(width: .infinity)
            .padding(.top, 15)
            .padding(.bottom, 10)
       
            
          
        
    }
}


struct TextFieldWithInputView : UIViewRepresentable {

  var data : [String]
  var placeholder : String

  @Binding var selectionIndex : Int
  @Binding var selectedText : String?

  private let textField = UITextField()
  private let picker = UIPickerView()

  func makeCoordinator() -> TextFieldWithInputView.Coordinator {
       Coordinator(textfield: self)
  }

  func makeUIView(context: UIViewRepresentableContext<TextFieldWithInputView>) -> UITextField {
       picker.delegate = context.coordinator
       picker.dataSource = context.coordinator
       picker.backgroundColor = .gray
       picker.tintColor = .black
       textField.placeholder = placeholder
       textField.inputView = picker
       textField.delegate = context.coordinator
    textField.textAlignment = .right
    textField.textColor = UIColor.systemGray
       return textField
  }

  func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldWithInputView>) {
       uiView.text = selectedText
  }

  class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate , UITextFieldDelegate {

       private let parent : TextFieldWithInputView

       init(textfield : TextFieldWithInputView) {
            self.parent = textfield
       }

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data.count
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.data[row]
       }
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.$selectionIndex.wrappedValue = row
            self.parent.selectedText = self.parent.data[self.parent.selectionIndex]
            self.parent.textField.endEditing(true)

       }
       func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.textField.resignFirstResponder()
       }
 }
}



//#if DEBUG
//struct pickerInputView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        PickerInput(iconContent: "pencil", iconColor: Color.blue, label: "AA", data: Binding<[String]>, value: .constant("CC"), index: .constant(0)).environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif
