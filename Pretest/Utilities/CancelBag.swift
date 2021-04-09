//
//  CancelBag.swift
//  CountriesSwiftUI
//
//  Created by Marsudi Widodo on 04.04.2020.
//  Copyright © 2020 Marsudi Widodo. All rights reserved.
//

import Combine

final class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
