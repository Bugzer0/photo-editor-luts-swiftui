import SwiftUI
import BrightroomEngine
import BrightroomUI

struct ContrastControl: View {
    @State var filterIntensity: Double = 0
    @EnvironmentObject var shared: PECtl
    
    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.valueChanged()
            }
        )
        
        return FilterSlider(value: intensity,
                          range: (-1.0, 1.0),
                          defaultValue: 0)
            .onAppear(perform: didReceiveCurrentEdit)
    }
    
    func didReceiveCurrentEdit() {
        if let stack = shared.brightroomEditingStack {
            if let loadedState = stack.store.state.loadedState {
                self.filterIntensity = loadedState.currentEdit.filters.contrast?.value ?? 0
            }
        }
    }
    
    func valueChanged() {
        let value = self.filterIntensity
        
        if let stack = shared.brightroomEditingStack {
            if value == 0 {
                stack.set(filters: {
                    $0.contrast = nil
                })
                PECtl.shared.didReceive(action: PECtlAction.setFilter({ $0.contrast = nil }))
            } else {
                // Cập nhật cho BrightroomEngine
                stack.set(filters: {
                    var filter = BrightroomEngine.FilterContrast()
                    filter.value = value
                    $0.contrast = filter
                })
                
                // Cập nhật cho preview thông qua PECtl
                PECtl.shared.didReceive(action: PECtlAction.setFilter({ filters in
                    if filters.contrast == nil {
                        filters.contrast = .init()
                    }
                    filters.contrast?.value = value
                }))
            }
        }
    }
}
