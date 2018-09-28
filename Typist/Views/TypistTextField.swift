//
//  TypistTextField.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 25/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class TypistTextField: UITextField
{
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        return false
    }
    
    //Have to figure out how to disable force touch on textField...
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
//    {
//        if let touch = touches.first
//        {
//            if traitCollection.forceTouchCapability == UIForceTouchCapability.available
//            {
//                print("FORCE TOUCH VALUE \(touch.force)")
//            }
//        }
//    }
}
