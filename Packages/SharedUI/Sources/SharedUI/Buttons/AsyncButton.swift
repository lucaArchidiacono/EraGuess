//
//  AsyncButton.swift
//
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import Foundation
import SwiftUI

public struct AsyncButton<Label: View>: View {
    var action: () async -> Void
    var actionOptions = Set(ActionOption.allCases)

    @ViewBuilder var label: () -> Label

    @State private var isDisabled = false
    @State private var showProgressView = false

    public init(
        actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
        action: @escaping () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.actionOptions = actionOptions
        self.label = label
    }

    public var body: some View {
        Button(
            action: {
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }

                Task {
                    var progressViewTask: Task<Void, Error>?

                    if actionOptions.contains(.showProgressView) {
                        progressViewTask = Task {
                            try await Task.sleep(nanoseconds: 150_000_000)
                            showProgressView = true
                        }
                    }

                    await action()
                    progressViewTask?.cancel()

                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                ZStack {
                    label().opacity(showProgressView ? 0 : 1)

                    if showProgressView {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isDisabled)
    }
}

public extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}

public extension AsyncButton where Label == Text {
    init(
        _ label: String,
        actionOptions _: Set<ActionOption> = Set(ActionOption.allCases),
        action: @escaping () async -> Void
    ) {
        self.init(action: action) {
            Text(label)
        }
    }
}
