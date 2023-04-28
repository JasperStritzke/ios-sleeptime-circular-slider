//
//  Extensions.swift
//  PracticeAppleSleep
//
//  Created by Jasper Stritzke on 26.10.22.
//

import Foundation
import SwiftUI

struct ButtonPressHandler: ButtonStyle {
    var action: () -> ()
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ?
                  Color.blue.opacity(0.7) : Color.blue)   // just to look like system
            .onChange(of: configuration.isPressed) {
                if $0 {
                    action()
                }
            }
    }
}

extension Button {
    func onTapEnded(_ action: @escaping () -> Void) -> some View {
        buttonStyle(ButtonPressHandler(action: action))
    }
}
