//
//  CurrencyField.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/29/21.
//

import SwiftUI

public struct NumericField: View {
    
    // The NumberFormatter that will display the currency correctly
    // for the user's settings
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // The NumberFormatter used while editing. This prevents crashes
    // from a more stringent "end" formatter
    let numberEditingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // Constant properties not managed by SwiftUI
    let title: String
    let symbol: String
    let value: Binding<NSNumber?>
    let foregroundColor: UIColor
    let font: Font?
    let textAlignment: TextAlignment?
    let maxLength: Int?
    
    // @State represents data stored and managed by SwiftUI
    @State private var valueWhileEditing: String = ""
    @State private var isEditing: Bool = false
    
    
    /// Public initializer
    /// - Parameters:
    ///   - title: The title of the component
    ///   - value: The desired value of the component
    public init(_ title: String, symbol: String,
                value: Binding<NSNumber?>,
                foregroundColor: UIColor,
                font: Font? = nil,
                textAlignment: TextAlignment? = nil,
                maxLength: Int? = nil
    ) {
        self.title = title
        self.symbol = symbol
        self.value = value
        self.foregroundColor = foregroundColor
        self.font = font
        self.textAlignment = textAlignment
        self.maxLength = maxLength
    }
    
    public var body: some View {
        // Use a TextField
        CustomTextfield(
            label: title,
            // text is a two way binding with the @State data
            text: Binding(
                get: {
                    // if we are editing, return the editing value, if not return the final
                    // formatted version
                    self.isEditing ?
                        self.valueWhileEditing :
                        symbol + " " + self.formattedValue
                },
                // set the new value
                set: { newValue in
                    // we are only interested in numbers and the decimal
                    let strippedValue = newValue.filter{ "0123456789.".contains($0) }
                    // if there is less than one decimal point
                    if strippedValue.filter({$0 == "."}).count <= 1 {
                        // update the editing value
                        self.valueWhileEditing = strippedValue
                        // update the current value
                        self.updateValue(with: strippedValue)
                    } else {
                        // we might have more than one decimal place
                        let newValue = String(
                            // remove all of the extra decimal places and/or other characters
                            strippedValue.dropLast(strippedValue.count - self.valueWhileEditing.count)
                        )
                        // update the editing value
                        self.valueWhileEditing = newValue
                        // update the current value
                        self.updateValue(with: newValue)
                    }
                }
            )
            , keyType: UIKeyboardType.decimalPad
            , onEditingChanged: { isEditing in
                // once the editing is finished
                // set the isEditing Boolean
                self.isEditing = isEditing
                // set the editing value to be the end value
                self.valueWhileEditing = self.formattedValue
            },
            maxLength: maxLength
        )
        .customFont(UIFont.fromFont(font: font))
        .customForegroundColor(foregroundColor)
        .customMultilineTextAlignment(textAlignment) 
    }
    
    // a private property which is represents the current formatted value as a string
    private var formattedValue: String {
        // if there isn't an underlying value, the formatted value is nothing
        guard let value = self.value.wrappedValue else { return "" }
        // if we are editing using the editing formatter, else use the currency formatter
        let formatter = isEditing ? numberEditingFormatter : numberFormatter
        // if we can't format the String, no String should be returned
        guard let formattedValue = formatter.string(for: value) else { return "" }
        // return the formatted value
        return formattedValue
    }
    
    private func updateValue(with string: String) {
        // format the string value as NSNumber?, using the formatter
        let newValue = numberEditingFormatter.number(from: string)
        // convert that NSNumber? to a String
        //let newString = newValue.map { currencyEditingFormatter.string(for: $0) } as? String
        let newString = newValue.map { numberEditingFormatter.string(for: $0) }
        // convert the string to an NSNumber, and assign to the underlying value property
        //value.wrappedValue = newString.map { currencyEditingFormatter.number(from: $0) } as? NSNumber
        value.wrappedValue = newString.map { numberEditingFormatter.number(from: $0!)! }
    }
}
