//
//  EditMenuControlView.swift
//  colorful-room
//
//  Created by macOS on 7/8/20.
//  Copyright © 2020 PingAK9. All rights reserved.
//

import SwiftUI
import BrightroomEngine
import BrightroomUI
import BrightroomUIPhotosCrop

struct CropView: View {
    @Environment(\.presentationMode) var presentationMode
    let editingStack: () -> BrightroomEngine.EditingStack
    let onComplete: (BrightroomEngine.EditingStack) -> Void
    
    var body: some View {
        ZStack {
            PhotosCropRotating(editingStack: editingStack)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Hủy")
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onComplete(editingStack())
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Xong")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.top, 44)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct EditMenuView: View {
    
    @EnvironmentObject var shared:PECtl
    
    @State var currentView:EditView = .lut
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                if((self.currentView == .filter && self.shared.currentEditMenu != .none) == false
                   && self.shared.lutsCtrl.editingLut == false){
                    HStack(spacing: 48){
                        NavigationLink(destination:
                                        CropView(
                                            editingStack: {
                                                self.shared.brightroomEditingStack!
                                            },
                                            onComplete: { stack in
                                                do {
                                                    let rendered = try stack.makeRenderer().render()
                                                    self.shared.setImage(image: rendered.uiImage)
                                                } catch {
                                                    print("Error rendering cropped image: \(error)")
                                                }
                                            }
                                        )
                        ){
                            IconButton("adjustment")
                        }
                        Button(action:{
                            self.currentView = .lut
                        }){
                            IconButton(self.currentView == .lut ? "edit-lut-highlight" : "edit-lut")
                        }
                        Button(action:{
                            if(self.shared.lutsCtrl.loadingLut == false){
                                self.currentView = .filter
                                self.shared.didReceive(action: PECtlAction.commit)
                            }
                        }){
                            IconButton(self.currentView == .filter ? "edit-color-highlight" : "edit-color")
                        }
                        Button(action:{
                            self.currentView = .recipe
                        }){
                            IconButton(self.currentView == .recipe ? "edit-recipe-highlight" : "edit-recipe")
                        }
                        Button(action:{
                            self.shared.didReceive(action: PECtlAction.undo)
                        }){
                            IconButton("icon-undo")
                        }
                    }
                    .frame(width: geometry.size.width, height: 50)
                    .background(Color.myPanel)
                }
                Spacer()
                ZStack{
                    if(self.currentView == .filter){
                        FilterMenuUI()
                    }
                    if(self.currentView == .lut){
                        LutMenuUI()
                    }
                    if(self.currentView == .recipe){
                        RecipeMenuUI()
                    }
                }
                Spacer()
            }
           
        }
    }
    
    
}

public enum EditView{
    case lut
    case filter
    case recipe
}
