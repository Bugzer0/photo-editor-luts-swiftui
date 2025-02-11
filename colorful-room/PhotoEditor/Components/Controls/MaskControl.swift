import SwiftUI
import BrightroomEngine
import BrightroomUI

struct MaskControl: View {
    @State var brushSize: Double = 30
    @EnvironmentObject var shared: PECtl
    
    var body: some View {
        let size = Binding<Double>(
            get: {
                self.brushSize
            },
            set: {
                self.brushSize = $0
                self.valueChanged()
            }
        )
        
        return VStack(spacing: 24) {
            FilterSlider(
                value: size,
                range: (10, 100),
                lable: "Brush Size",
                defaultValue: 30,
                spacing: 8
            )
            
            HStack(spacing: 20) {
                Button(action: {
                    // Clear mask
                    if let stack = shared.brightroomEditingStack {
                        stack.set(blurringMaskPaths: [])
                        shared.didReceive(action: PECtlAction.commit)
                    }
                }) {
                    Text("Clear Mask")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .onAppear(perform: didReceiveCurrentEdit)
    }
    
    func didReceiveCurrentEdit() {
        if let stack = shared.brightroomEditingStack {
            if let loadedState = stack.store.state.loadedState {
                // Có thể thêm logic load brush size ở đây nếu cần
            }
        }
    }
    
    func valueChanged() {
        // Cập nhật brush size cho BlurryMaskingView
        NotificationCenter.default.post(
            name: Notification.Name("UpdateMaskBrushSize"),
            object: nil,
            userInfo: ["size": brushSize]
        )
    }
} 