//
//  BannerPopup.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

struct BannerPopup: View {

    enum PopupType {
        case warning, success, failure, info, `default`
    }

    private var withImage: Bool = true
    private var imageNamed: String = "icon_exclamation_circle_white"
    private var message: String = ""
    private var type: PopupType = .default
    
    init(withImage: Bool = true, imageNamed: String = "icon_exclamation_circle_white", message: String, type: PopupType = .default) {
        self.withImage = withImage
        self.imageNamed = imageNamed
        self.message = message
        self.type = type
    }
    
    var backgroundColor: Color {
        switch type {
        case .default:
            return Color.white
        case .warning:
            return Color.orange
        case .success:
            return Color.green
        case .failure:
            return Color.red
        case .info:
            return Color.blue
        }
    }
    
    var body: some View {
        HStack {
            if withImage {
                Image(imageNamed)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            Text(message)
                .font(.system(size: 13))
                .foregroundColor(type == PopupType.default ? Color.black : Color.white)
        }
        .padding(10)
        .background(backgroundColor)
        .cornerRadius(16)
        .shadow(color: backgroundColor.opacity(0.5), radius: 5, x: 0, y: 3)
    }
}
