//
//  View+AnyViewExtension.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension View {
    var toAnyView: AnyView {
        return AnyView(self)
    }
}
