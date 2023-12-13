//
//  CircularButton.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import SwiftUI

struct CircularButton: View {
    var foregroundColor: Color = Color(R.color.accentColor()!)
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var imageSystemName: String = "plus"
    var image: UIImage?
    let iconSize: CGFloat = 20
    let backgroundSize: CGFloat = 48
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: backgroundSize, height: backgroundSize)
            } else {
                Image(systemName: imageSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .padding(Spacing.spacingM)
                    .background(backgroundColor)
                    .clipShape(Circle())
                    .foregroundColor(foregroundColor)
                    .frame(width: backgroundSize, height: backgroundSize)
            }
        }
    }
}


struct CircularButton_Preview: PreviewProvider {
    static var previews: some View {
        HStack {
            CircularButton {
                print("clicked")
            }
            
            CircularButton(foregroundColor: .black, imageSystemName: "paperplane.fill") {
                print("clicked")
            }
            
            CircularButton(backgroundColor: Color.primary, imageSystemName: "camera") {
                print("clicked")
            }
        }
        .lightPreview()
        
        HStack {
            CircularButton {
                print("clicked")
            }
            
            CircularButton(foregroundColor: Color.primary, imageSystemName: "paperplane.fill") {
                print("clicked")
            }
            
            CircularButton(backgroundColor: Color.primary, imageSystemName: "camera") {
                print("clicked")
            }
        }
        .darkPreview()
    }
}
