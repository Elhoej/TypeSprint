//
//  Utils.swift
//  Task App
//
//  Created by Simon Elhoej Steinmejer on 8/20/17.
//  Copyright © 2017 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

extension String
{
    subscript (i: Int) -> Character
    {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension Int
{
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func secondsToMinutesAndSecondsString() -> String
    {
        let (_, m, s) = secondsToHoursMinutesSeconds(seconds: self)
        if self < 60
        {
            return "\(s) seconds"
        }
        else
        {
            return "\(m) minutes, \(s) seconds"
        }
    }
}

extension UIViewController
{
    func showAlert(with text: String)
    {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

func generateRandomNumber(min: Int, max: Int) -> Int
{
    let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
    return randomNum
}

extension UIView
{
    func setGradientBackground(colorOne: CGColor, colorTwo: CGColor)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorTwo, colorOne, colorTwo]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientButton(colorOne: CGColor, colorTwo: CGColor, startPoint: CGPoint, endPoint: CGPoint)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension CGFloat
{
    static func random() -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor
{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func random() -> UIColor
    {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    static let gold = UIColor(red: 255/255, green: 204/255, blue: 51/255, alpha: 1.0)
    static let dark = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1.0)
}

extension UIView
{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat)
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top
        {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left
        {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right
        {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom
        {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if width != 0
        {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0
        {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView
{
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage
        {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error
            {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!)
                {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}

extension UIView
{
    func dropShadow()
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
    }
    
    func noShadow()
    {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0
    }
}


