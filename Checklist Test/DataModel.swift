/*--------------------------------------------------------------------------------------------------------------------------
    File: DataModel.swift
  Author: Kevin Messina
 Created: 12/15/23
Modified:
 
©2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

@MainActor
class SelectedVars:ObservableObject {
    @Published var selectedBoxFill:Int
    @Published var selectedBoxShape:Int
    @Published var selectedBoxMark:Int
    @Published var selectedColor:Color
    @Published var selectedSelection:Int
    @Published var selectedSelectionHighlight:Int
    
    init(
        selectedBoxFill:Int = 0,
        selectedBoxShape:Int = 0,
        selectedBoxMark:Int = 0,
        selectedColor:Color = .green,
        selectedSelection:Int = 0,
        selectedSelectionHighlight:Int = 0
    ) {
        self.selectedBoxFill = selectedBoxFill
        self.selectedBoxShape = selectedBoxShape
        self.selectedBoxMark = selectedBoxMark
        self.selectedColor = selectedColor
        self.selectedSelection = selectedSelection
        self.selectedSelectionHighlight = selectedSelectionHighlight
    }
}

struct vars {
    enum shapeType:Int { case square,circle,shield }
    enum fillType:Int { case none,filled }
    enum markType:Int { case none,check,x }
    enum selectionType:Int { case single,multiple }
    enum selectionHighlightTypes:Int { case none,outline,filledBox }
    
    static let shapeName:[String] = ["square","circle","shield"]
    static let fillName:[String] = ["",".fill"]
    static let markName:[String] = ["","checkmark.","xmark."]
    static let HighlightName:[String] = ["None","Outline.","Filled"]
}

struct checkListItemStruct:Identifiable {
    var id: Int
    var name: String
    var isSelected: Bool = false
}

struct itemDetails:Identifiable {
    var id: Int
    var title: String
    var symbol: String
}

struct items:Identifiable {
    var id: Int
    var title: String
    var items: [itemDetails]
}

var testData = [
        checkListItemStruct(id:0,name: "Item #1", isSelected: false),
        checkListItemStruct(id:1,name: "Item #2", isSelected: false),
        checkListItemStruct(id:2,name: "Item #3", isSelected: false),
        checkListItemStruct(id:3,name: "Item #4", isSelected: false),
        checkListItemStruct(id:4,name: "Item #5", isSelected: false)
    ]

struct settings {
    @ObservedObject var selectedVars:SelectedVars
    
    static let outlineStyle:items = items.init(id: 0,title: "Outline Style",
        items: [
            itemDetails(id: 0,title: vars.HighlightName[0].capitalizingFirstLetter(),symbol: ""),
            itemDetails(id: 1,title: String(vars.HighlightName[1].capitalizingFirstLetter().dropLast()),symbol: "capsule"),
            itemDetails(id: 2,title: vars.HighlightName[2].capitalizingFirstLetter(),symbol: "capsule.fill")
        ]
    )
    
    static let MultiSelectStyle:items = items.init(id: 0,title: "Multiple Selection Style",
        items: [
            itemDetails(id: 0,title: "Single",symbol: "checklist"),
            itemDetails(id: 1,title: "Multiple",symbol: "checklist.checked"),
        ]
    )
    
    static let FilledStyle:items = items.init(id: 0,title: "Selection Fill Type",
        items: [
            itemDetails(id: 0,title: "None",symbol: ""),
            itemDetails(id: 1,title: "Filled",symbol: "square.fill")
        ]
    )
    
    static let MarkStyle:items = items.init(id: 0,title: "Selection Mark",
        items: [
            itemDetails(id: 0,title: "None",symbol: ""),
            itemDetails(id: 1,title: String(vars.markName[1].capitalizingFirstLetter().dropLast()),symbol: "\(vars.markName[1].dropLast())"),
            itemDetails(id: 2,title: String(vars.markName[2].capitalizingFirstLetter().dropLast()),symbol: "\(vars.markName[2].dropLast())")
        ]
    )
    
    static let boxShapeStyle:items = items.init(id: 0,title: "Selection Shape",
        items: [
            itemDetails(id: 0,title: vars.shapeName[0].capitalizingFirstLetter(),symbol: vars.shapeName[0]),
            itemDetails(id: 1,title: vars.shapeName[1].capitalizingFirstLetter(),symbol: vars.shapeName[1]),
            itemDetails(id: 2,title: vars.shapeName[2].capitalizingFirstLetter(),symbol: vars.shapeName[2])
        ]
    )
}
