//
//  CustomSlider.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import SwiftUI

struct CustomSlider: View {
    
    @State var text: String
    @Binding var value: Float
    
    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .bold()
                Spacer()
                Text("\(Int(value * 100))")
            }
            
            Slider(value: $value, in: 0...1)
            .onChange(of: value) { _, newValue in
                
            }
        }
    }
}
