//
//  PhotoEditorView.swift
//  colorful-room
//
//  Created by macOS on 7/8/20.
//  Copyright © 2020 PingAK9. All rights reserved.
//

import SwiftUI
import BrightroomEngine
import BrightroomUI

struct PhotoEditorView: View {
    
    @EnvironmentObject var shared: PECtl
    @State private var brushSize: CanvasView.BrushSize = .point(30)
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if let image = shared.previewImage {
                    if let stack = shared.brightroomEditingStack {
                        ZStack {
                            ImagePreviewView(image: image)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                            
                            SwiftUIBlurryMaskingView(editingStack: stack)
                                .blushSize(brushSize)
                                .hideBackdropImageView(true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .allowsHitTesting(shared.currentEditMenu == .mask)
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.myGrayDark)
                }
                EditMenuView()
                    .frame(height: 250)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("UpdateMaskBrushSize"))) { notification in
            if let size = notification.userInfo?["size"] as? Double {
                brushSize = .point(size)
            }
        }
    }
}
