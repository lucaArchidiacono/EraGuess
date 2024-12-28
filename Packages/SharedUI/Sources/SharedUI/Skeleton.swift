//
//  Skeleton.swift
//
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import Foundation
import SwiftUI

public struct Skeleton: View {
    @State private var animation = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    public init() {}

    public var body: some View {
        LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.5), .gray.opacity(0.3), .gray.opacity(0.5)]),
                       startPoint: .leading,
                       endPoint: .trailing)
            .mask(Rectangle())
            .opacity(animation ? 1.0 : 0.0)
            .onAppear {
                withAnimation(Animation.linear(duration: 1.0).repeatCount(1, autoreverses: true).speed(2)) {
                    animation.toggle()
                }
            }
            .onReceive(timer) { _ in
                withAnimation(Animation.linear(duration: 1.0).repeatCount(1, autoreverses: true).speed(2)) {
                    animation.toggle()
                }
            }
    }
}
