//
//  GenresView+Failed.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

struct FailedView : View {
    
    var message: String
    var onRefresh: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Failed")
                .font(.system(size: 25))
                .foregroundColor(.black)
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Button("Refresh", action: onRefresh)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
}
