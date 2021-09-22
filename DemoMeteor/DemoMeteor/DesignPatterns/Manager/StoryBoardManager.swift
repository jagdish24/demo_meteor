//
//  StoryBoardManager.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    case main = "Main"

    var instance: UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T{
        let storyboardId = (viewControllerClass as UIViewController.Type).storyBoardId
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
    func intialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
