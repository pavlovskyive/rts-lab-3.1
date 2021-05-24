//
//  NumberView.swift
//  rts-lab-3
//
//  Created by Vsevolod Pavlovskyi on 16.05.2021.
//

import SwiftUI

fileprivate enum Config {
    
    static let foreground: Color = .white
    
    static let background: Color = .white
    static let opacity: Double = 0.2
    
    static let cornerRadius: CGFloat = 8
    
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 10
    
    static let borderWidth: CGFloat = 2
    
}

struct NumberStyle: ViewModifier {
    
    enum Style {
        
        case original
        case bordered

    }
    
    let style: Style

    private let font: Font = .title3.bold()

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(Config.foreground)
            .padding(.horizontal, Config.horizontalPadding)
            .padding(.vertical, Config.verticalPadding)
            .background(Config.background.opacity(Config.opacity))
            .cornerRadius(Config.cornerRadius)
            .overlay(borderOverlay)
            .accentColor(Config.foreground)
    }
    
}

private extension NumberStyle {
    
    var borderOverlay: some View {
        RoundedRectangle(cornerRadius: Config.cornerRadius)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    var borderColor: Color {
        style == .bordered ? Config.foreground : .clear
    }
    
    var borderWidth: CGFloat {
        style == .bordered ? Config.borderWidth : 0
    }
    
}

extension View {

    func numberStyle(style: NumberStyle.Style = .original) -> some View {
        self.modifier(NumberStyle(style: style))
    }

}
