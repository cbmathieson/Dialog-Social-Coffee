//
//  ActivityIndicator.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-06-14.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
