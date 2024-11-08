//
//  CustomSlider.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import SwiftUI

struct CustomSlider<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    
    @State var text: String
    @Binding var value: V
    @State var onChange: (V, V) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .bold()
                Spacer()
                Text("\(Int(value * 100))")
            }
            
            Slider(value: $value, in: 0...1)
            .onChange(of: value, onChange)
        }
    }
}
