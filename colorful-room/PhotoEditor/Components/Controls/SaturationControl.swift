//
//  SaturationControl.swift
//  colorful-room
//
//  Created by macOS on 7/14/20.
//  Copyright © 2020 PingAK9. All rights reserved.
//

import SwiftUI
import PixelEngine

struct SaturationControl: View {
    @State var filterIntensity:Double = 0
    
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
        let min = FilterSaturation.range.min
        let max = FilterSaturation.range.max
        return  FilterSlider(value: intensity, range: (min, max), lable: "Saturation", defaultValue: 0)
        .onAppear(perform: didReceiveCurrentEdit)
    }
    
    func didReceiveCurrentEdit() {
        
        let edit: EditingStack.Edit = PECtl.shared.edit.currentEdit
        self.filterIntensity = edit.filters.saturation?.value ?? 0
    }
    
    func valueChanged() {
        
        let value = self.filterIntensity
        
        guard value != 0 else {
            PECtl.shared.didReceive(action: PECtl.Action.setFilter({ $0.saturation = nil }))
            return
        }
        
        
        var f = FilterSaturation()
        f.value = value
        PECtl.shared.didReceive(action: PECtl.Action.setFilter({ $0.saturation = f }))
    }
}
