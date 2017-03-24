//
//  Extensions.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/22/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}

extension UIImageView {
    override func applyCircleShadow(shadowRadius: CGFloat = 2,
                                    shadowOpacity: Float = 0.3,
                                    shadowColor: CGColor = UIColor.black.cgColor,
                                    shadowOffset: CGSize = CGSize.zero) {
        
        // Use UIImageView.hashvalue as background view tag (should be unique)
        let background: UIView = superview?.viewWithTag(hashValue) ?? UIView()
        background.frame = frame
        background.backgroundColor = backgroundColor
        background.tag = hashValue
        background.applyCircleShadow(shadowRadius: shadowRadius, shadowOpacity: shadowOpacity, shadowColor: shadowColor, shadowOffset: shadowOffset)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 6
        layer.cornerRadius = background.layer.cornerRadius
        layer.masksToBounds = true
        superview?.insertSubview(background, belowSubview: self)
    }
    
    func applyCircleShadowSmall(shadowRadius: CGFloat = 2,
                                shadowOpacity: Float = 0.3,
                                shadowColor: CGColor = UIColor.black.cgColor,
                                shadowOffset: CGSize = CGSize.zero) {
        
        // Use UIImageView.hashvalue as background view tag (should be unique)
        let background: UIView = superview?.viewWithTag(hashValue) ?? UIView()
        background.frame = frame
        background.backgroundColor = backgroundColor
        background.tag = hashValue
        background.applyCircleShadow(shadowRadius: shadowRadius, shadowOpacity: shadowOpacity, shadowColor: shadowColor, shadowOffset: shadowOffset)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = background.layer.cornerRadius
        layer.masksToBounds = true
        superview?.insertSubview(background, belowSubview: self)
    }
}

extension UIView {
    func applyCircleShadow(shadowRadius: CGFloat = 3,
                           shadowOpacity: Float = 0.3,
                           shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize.init(width: 0, height: 0)) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        var data = self
        if self.range(of: ".") == nil {
            //Case where the string doesnt contain the optional milliseconds
            data = data.replacingOccurrences(of: "Z", with: ".000000Z")
        }
        return Date.Formatter.iso8601.date(from: data)
    }
}

extension NSString {
    var dateFromISO8601: Date? {
        return (self as String).dateFromISO8601
    }
}

public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}
