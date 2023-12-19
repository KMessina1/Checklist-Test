/*--------------------------------------------------------------------------------------------------------------------------
    File: ContentView.swift
  Author: Kevin Messina
 Created: 12/19/23
Modified:
 
©2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct CheckListView: View {
    //Observed shared variables
    @StateObject var selectedVars: SelectedVars = SelectedVars.init()
    
    // Local State Variables
    @Binding var bindingSelection:Int
    
    // Local Variables
    @State var resetSelections:Bool = false
    @State var showAlert: Bool = false
    @State var items:[checkListItemStruct] = []
    @State var boxShape:vars.shapeType = .square
    @State var boxFill:vars.fillType = .none
    @State var boxMark:vars.markType = .check
    @State var textColor:Color = .white
    @State var selection:vars.selectionType = .single
    @State var selectionHighlight:vars.selectionHighlightTypes = .none
    @State var selectionHighlightTextColor:Color = .white
    @State var selectionHighlightColor:Color = .yellow
    var textAlignment: TextAlignment = .trailing
    var unselectedColor:Color = .gray
    var backColor:Color = .clear
    var fontSize:CGFloat = 24
    var height:CGFloat = 0.0
    var width:CGFloat = 200
    var rowHeight:CGFloat = 0.0
    
    // Alert & Action Sheet Variables
    var body: some View {
        let shape = "\(vars.shapeName[self.boxShape.rawValue])\(vars.fillName[self.boxFill.rawValue] )"
        let selectedShape = "\(vars.markName[self.boxMark.rawValue])"
        let unselectedShape = "\(vars.markName[vars.markType.none.rawValue])"
        let isFilledBox = (self.selectionHighlight == .filledBox)
        let isOutlineBox = (self.selectionHighlight == .outline)
        let isLeading = (self.textAlignment == .leading)
        let isTrailing = (self.textAlignment == .trailing)
        
        return ZStack {
            Color.black
            
            VStack {
                VStack {
                    Text("Checklist Demo")
                        .foregroundColor(.yellow)
                        .font(.largeTitle)
                        .bold()
                        .underline()
                        .padding(.bottom,20)
                    
                    ColorPicker("Text Color", selection: $textColor)
                        .modifier(backgroundView())
                    
                    VStack(alignment: .leading, spacing: 10) {
                        setingsRow(pickerSelection: $selectedVars.selectedBoxShape,items: settings.boxShapeStyle)
                            .onChange(of: selectedVars.selectedBoxShape, initial: true) {
                                boxShape = vars.shapeType(rawValue: selectedVars.selectedBoxShape)!
                            }
                        
                        setingsRow(pickerSelection: $selectedVars.selectedBoxMark,items: settings.MarkStyle)
                            .onChange(of: selectedVars.selectedBoxMark, initial: true) {
                                boxMark = vars.markType(rawValue: selectedVars.selectedBoxMark)!
                            }
                        
                        ColorPicker("Selection Color", selection: $selectedVars.selectedColor)
                        
                        setingsRow(pickerSelection: $selectedVars.selectedBoxFill,items: settings.FilledStyle)
                            .onChange(of: selectedVars.selectedBoxFill, initial: true) {
                                boxFill = vars.fillType(rawValue: selectedVars.selectedBoxFill)!
                            }
                        
                        setingsRow(pickerSelection: $selectedVars.selectedSelection,items: settings.MultiSelectStyle)
                            .onChange(of: selectedVars.selectedSelection, initial: true) {
                                selection = vars.selectionType(rawValue: selectedVars.selectedSelection)!
                                resetSelections(selectedID: -1)
                                bindingSelection = -1
                            }
                    }
                    .modifier(backgroundView())
                    
                    VStack{
                        setingsRow(pickerSelection: $selectedVars.selectedSelectionHighlight,items: settings.outlineStyle)
                            .onChange(of: selectedVars.selectedSelectionHighlight, initial: true) {
                                selectionHighlight = vars.selectionHighlightTypes(rawValue: selectedVars.selectedSelectionHighlight)!
                            }
                        
                        ColorPicker("Outline Color", selection: $selectionHighlightColor)
                    }
                    .modifier(backgroundView())
                }
                .modifier(commonSettings())
                
                showDivider(buttonPress: $resetSelections, text: "Preview", textColor: .white, lineColor: .yellow)
                
                ScrollView(.vertical,showsIndicators: true) {
                    VStack(alignment:.center,spacing:0) {
                        ForEach(items) { item in
                            HStack(spacing: 10) {
                                Image(systemName: "\( item.isSelected ?selectedShape :unselectedShape )\( shape )")
                                    .foregroundColor(item.isSelected ?selectedVars.selectedColor :unselectedColor)
                                HStack{
                                    if isTrailing { Spacer() }
                                    
                                    Text(item.name)
                                        .foregroundColor((item.isSelected && isFilledBox) ?selectionHighlightTextColor :textColor)
                                        .fontWeight(item.isSelected ?.bold :.regular)
                                    
                                    if isLeading { Spacer() }
                                }
                            }
                            .tag(item.id)
                            .padding(.all,5)
                            .frame(width:width-25,height: (rowHeight < 1) ?fontSize + 5 :rowHeight)
                            .background((item.isSelected && isFilledBox) ?selectionHighlightColor :Color.clear)
                            .cornerRadius((selectionHighlight != .none) ?10 :0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke((item.isSelected && isOutlineBox) ?selectionHighlightColor.opacity(0.80) :.clear, lineWidth: 2)
                            )
                            .padding(.horizontal,10)
                            .padding(.bottom,10)
                            .font(.system(size: fontSize))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if self.selection == .single {
                                    resetSelections(selectedID: item.id)
                                }else{
                                    selectItem(selectedID: item.id)
                                }
                                
                                bindingSelection = item.id
                            }//End Tap Gesture
                        }//End ForEach
                    }//End VStack
                    .padding(.vertical,10)
                }//End ScrollView
                .background(selectionHighlightColor.opacity(0.1))
                .cornerRadius((selectionHighlight == .none) ?0 :10)
                .padding(.bottom,10)
            }//End VStack
            .blur(radius: showAlert ? 3 : 0)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("RESET"), message: Text("Selection default values have been reset."))
            }
            .onChange(of: resetSelections, initial: false) {
                resetAll()
                showAlert.toggle()
            }
        }
    }
    
    // MARK: - *** FUNCTIONS ***
    func selectItem(selectedID:Int) {
        var counter = 0
        
        repeat {
            if items[counter].id == selectedID {
                items[counter].isSelected.toggle()
            }
            
            counter += 1
        } while counter < items.count
    }
    
    func resetAll() {
        resetSelections(selectedID: -1)
        bindingSelection = -1
        boxShape = .square
        boxMark = .none
        boxFill = .none
        textColor = .white
        selection = .single
        selectionHighlight = .none
        selectionHighlightTextColor = .green
        selectionHighlightColor = .yellow
    }
    
    func resetSelections(selectedID:Int) {
        var counter = 0
        
        repeat {
            if items[counter].id == selectedID {
                items[counter].isSelected = true
            }else{
                items[counter].isSelected = false
            }
            counter += 1
        } while counter < items.count
    }
}


#Preview {
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
