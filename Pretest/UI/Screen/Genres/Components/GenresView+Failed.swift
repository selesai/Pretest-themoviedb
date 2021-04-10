//
//  GenresView+Failed.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension GenresView {
    struct Failed : View {
        
        var message: String
        
        var body: some View {
            VStack(alignment: .center) {
                Text("Failed")
                    .font(.system(size: 25))
                    .foregroundColor(.black)
                Text(message)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                Button("Refresh") {
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        
    }
}
