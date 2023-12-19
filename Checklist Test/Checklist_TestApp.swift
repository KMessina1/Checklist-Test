/*--------------------------------------------------------------------------------------------------------------------------
    File: Checklist_TestApp.swift
  Author: Kevin Messina
 Created: 12/19/23
Modified:
 
©2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

@main
struct Checklist_TestApp: App {
    var body: some Scene {
        WindowGroup {
            CheckListView(
                bindingSelection: .constant(0),
                items: testData,
                boxShape: .shield,
                boxFill: .filled,
                boxMark: .check,
                textColor: .white,
                selection: .single,
                selectionHighlight: .outline,
                selectionHighlightTextColor: .black,
                selectionHighlightColor: .yellow,
                textAlignment: .leading,
                unselectedColor: .gray,
                backColor: .clear,
                fontSize: 18,
                height: 160,
                width: 300,
                rowHeight: 30
            )
            .background(Color.black)
        }
    }
}
