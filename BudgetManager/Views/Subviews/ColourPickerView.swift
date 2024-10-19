//
//  ColourPickerView.swift
//  BudgetManager
//
//  Created by Jack on 20/10/2024.
//

import SwiftUI

struct ColourPickerView: View
{
  @Environment(\.dismiss) var dismiss
  @Binding var selected: Color
  var save: () -> Void = {}

  private let colours = K.Colours.CATEGORIES.chunked(into: 4)

  var body: some View
  {
    VStack
    {
      HStack
      {
        Spacer()
        Button("Done")
        {
          save()
          dismiss()
        }
      }
      Spacer()
      Text("Select colour for category").font(.title3)
      Spacer()
      ForEach(colours, id: \.self)
      {
        row in
        HStack
        {
          ForEach(row, id: \.self)
          {
            colour in
            colourButton(colour: colour)
          }
        }
      }
      Spacer()
    }
    .padding()
  }

  func colourButton(colour: Color) -> some View
  {
    Button
    {
      selected = colour
    } label:
    {
//      let border = colour == selected ? 4.0 : 1.0
      let border = 1.0
      Circle()
        .stroke(Color.primary, lineWidth: border)
        .fill(colour)
        .frame(width: 50.0)
        .padding()
    }
  }
}

#Preview
{
  ColourPickerView(selected: .constant(.blue))
}
