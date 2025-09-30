//
//  PhotoEditor+Font.swift
//
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    
    //Resources don't load in main bundle we have to register the font
    func registerFont(){
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: PhotoEditorViewController.self)
        #endif

        guard let url = bundle.url(forResource: "icomoon", withExtension: "ttf") else {
            print("⚠️ Font file not found in bundle")
            return
        }

        guard let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("⚠️ Failed to create font from file")
            return
        }

        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            print("⚠️ Failed to register font: \(error.debugDescription)")
            return
        }
    }
}
