//
//  LoadingManager.swift
//  GetPlaces
//
//  Created by Bola Fayez on 01/01/2023.
//

import UIKit

class LoadingManager {
        
    // MARK: - UI
    private var blurImg = UIImageView()
    private var indicator = UIActivityIndicatorView()
    
    public static let sharedInstance = LoadingManager()

    // MARK: - init
    init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.1
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = .gray
    }
    
    // MARK: - showIndicator
    func showIndicator() {
        DispatchQueue.main.async( execute: {
            if let keyWindow = UIWindow.key {
                keyWindow.addSubview(self.blurImg)
                keyWindow.addSubview(self.indicator)
            }
        })
    }
    
    // MARK: - hideIndicator
    func hideIndicator() {
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
        })
    }
}
