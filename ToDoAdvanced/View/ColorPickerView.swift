//
//  ColorPickerView.swift
//  ToDoAdvanced
//
//  Created by Keyhou on 02/03/2023.
//

import SwiftUI

struct ColorPickerView: View {
    
    let colors: [Color] = [.red, .green, .blue, .yellow]
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Image(systemName: selectedColor == color ? Constants.Icons.recordCircleFill: Constants.Icons.circleFill)
                    .foregroundColor(color)
                    .clipShape(Circle())
                    .onTapGesture {
                        print(color)
                        selectedColor = color
                    }
            }
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.red))
    }
}
