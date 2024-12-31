//
//  Artist.swift
//  Models
//
//  Created by Luca Archidiacono on 29.12.2024.
//

public struct Artist: Identifiable, Sendable {
    public let id: String
    public let name: String

    public init(
        id: String,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
