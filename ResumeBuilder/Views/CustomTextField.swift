//
//  CustomTextField.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// Custom formatter
enum TextFieldFormatter {
    case phone, website, month, year
}

/// Custom text field
struct CustomTextField: View {

    @Binding var text: String
    @State var isEditing: Bool = false
    @State var formatter: TextFieldFormatter?
    @State var titleText: String?
    var placeholderText: String
    
    // MARK: - Main rendering function
    var body: some View {
        func updateFormattedText() {
            if let textFormatter = formatter {
                switch textFormatter {
                case .phone:
                    text = text.formattedPhoneNumber
                case .website:
                    text = text.formattedWebsite
                default: break
                }
            }
        }
        
        return VStack {
            VStack {
                if titleText != nil {
                    HStack {
                        Text(titleText!).opacity(0.75)
                        Spacer()
                    }
                }
                TextField(placeholderText, text: $text.onChange({ value in
                    if formatter == .month || formatter == .year {
                        if let number = Int(value), number > (formatter == .month ? 12 : Calendar.current.component(.year, from: Date())) {
                            text = "\(value.dropLast())"
                        }
                    }
                })) { didChange in
                    isEditing = didChange
                    if didChange == false {
                        updateFormattedText()
                    }
                } onCommit: {
                    updateFormattedText()
                }
                .font(.system(size: 25, weight: .bold))
                Rectangle().frame(height: 1.5)
                    .foregroundColor(isEditing ? .accentColor : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            }
        }
    }
}
