//
//  Binding+Extension.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import SwiftUI

extension Binding {
    /// Returns a non-optional binding if the wrapped value is non-nil.
    init?(_ source: Binding<Value?>) {
        guard let value = source.wrappedValue else { return nil }
        self = Binding<Value>(
            get: { source.wrappedValue ?? value },
            set: { newValue in
                source.wrappedValue = newValue
            }
        )
    }
}

