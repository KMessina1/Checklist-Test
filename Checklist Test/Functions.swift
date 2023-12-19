/*--------------------------------------------------------------------------------------------------------------------------
    File: Functions.swift
  Author: Kevin Messina
 Created: 12/15/23
Modified:
 
©2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct showDivider: View {
    @Binding var buttonPress: Bool
    var text: String
    var textColor: Color
    var lineColor: Color
    var btnText: String = "Reset"
    var btnImg: String = "trash"

    var body: some View {
        HStack {
            Rectangle().fill(lineColor).frame(height: 1.0)
            Text(text).foregroundColor(textColor).italic().font(.headline)
            Rectangle().fill(lineColor).frame(height: 1.0)
            Button(btnText, systemImage: btnImg, action: { buttonPress.toggle() })
                .accentColor(.red)
                .bold()
                .padding(.vertical,4)
                .padding(.horizontal,8)
                .background(lineColor)
                .cornerRadius(5.0)
        }
        .padding(.vertical,15)
    }
}

struct backgroundView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.all,10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(5)
    }
}

struct commonSettings: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accentColor(.red)
            .padding([.horizontal],20)
            .foregroundColor(.white)
    }
}

struct setingsRow: View {
    @Binding var pickerSelection: Int
    var titleColor: Color = .white
    var items: items
    
    var body: some View {
        HStack {
            Text(items.title)
                .foregroundColor(.white)
            
            Spacer()
            
            Picker("", selection: $pickerSelection) {
                ForEach(items.items, id: \.id) { item in
                    Label(item.title, systemImage: item.symbol).tag(item.id)
                }
            }
        }
        .contentShape(Rectangle())
    }
}



