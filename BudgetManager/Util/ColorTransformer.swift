//
//  ColorTransformer.swift
//  BudgetManager
//
//  Created by JACK HOGG on 10/11/2023.
//

import Foundation
import SwiftUI

enum ColorTransformer
{
  static func toComponents(color: Color) -> [CGFloat]
  {
    if let components = UIColor(color).cgColor.components
    {
      return components
    }
    // Return default blue
    return [0.0, 0.4784314036369324, 0.9999999403953552, 1.0]
  }

  static func toColor(components: [CGFloat]) -> Color
  {
    Color(.sRGB,
          red: components[0],
          green: components[1],
          blue: components[2],
          opacity: components[3])
  }
}
