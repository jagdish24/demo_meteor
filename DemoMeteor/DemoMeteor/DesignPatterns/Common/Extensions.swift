//
//  Extensions.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import Foundation
import UIKit


extension UIViewController {
    class var storyBoardId: String{
        return "\(self)"
    }
    static func instatiateFromStoryBoard(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

extension UIView {
    
    class func fromXib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
