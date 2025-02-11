//
//  TempCode.swift
//  colorful-room
//
//  Created by macOS on 7/13/20.
//  Copyright © 2020 PingAK9. All rights reserved.
//

import SwiftUI
import BrightroomEngine
import BrightroomUI

struct ClarityControl: View {
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
                          range: (0, 1),
                          defaultValue: 0)
            .onAppear(perform: didReceiveCurrentEdit)
    }
    
    func didReceiveCurrentEdit() {
        if let stack = shared.brightroomEditingStack {
            if let loadedState = stack.store.state.loadedState {
                self.filterIntensity = loadedState.currentEdit.filters.unsharpMask?.intensity ?? 0
            }
        }
    }
    
    func valueChanged() {
        let value = self.filterIntensity
        
        if let stack = shared.brightroomEditingStack {
            if value == 0 {
                stack.set(filters: {
                    $0.unsharpMask = nil
                })
                PECtl.shared.didReceive(action: PECtlAction.setFilter({ $0.unsharpMask = nil }))
            } else {
                // Cập nhật cho BrightroomEngine
                stack.set(filters: {
                    var filter = BrightroomEngine.FilterUnsharpMask()
                    filter.intensity = value
                    filter.radius = 0.12
                    $0.unsharpMask = filter
                })
                
                // Cập nhật cho preview thông qua PECtl
                PECtl.shared.didReceive(action: PECtlAction.setFilter({ filters in
                    if filters.unsharpMask == nil {
                        filters.unsharpMask = .init()
                    }
                    filters.unsharpMask?.intensity = value
                    filters.unsharpMask?.radius = 0.12
                }))
            }
        }
    }
}
