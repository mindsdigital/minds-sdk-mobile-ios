//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 19/07/22.
//

import SwiftUI

extension View {

    func disableRotation() -> some View {
        let rotationChangePublisher = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)

        return onReceive(rotationChangePublisher) { _ in
            changeOrientation(to: .portrait)
        }.onAppear {
            changeOrientation(to: .portrait)
        }
    }
    
    func changeOrientation(to orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }
}
