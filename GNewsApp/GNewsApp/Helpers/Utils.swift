//
//  Utils.swift
//  GNewsApp
//
//  Created by vladikkk on 02/12/2021.
//

import Foundation
import UIKit

// MARK: - Enum to present view controller using coordinator
enum ViewControllerUtils {
    static func setRootViewController(window: UIWindow, viewController: UIViewController, withAnimation: Bool) {
        if !withAnimation {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }
        
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.75, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
}

// MARK: - Extension to get date as string
class StringDate {
    func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/mm/dd"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Extension to animate view
extension UIView {
    func shift(duration: TimeInterval, toogle: Bool, offset: CGPoint) {
        UIView.animate(withDuration: duration) {
            if toogle {
                self.frame = self.frame.offsetBy(dx: offset.x, dy: -offset.y)
            } else {
                self.frame = self.frame.offsetBy(dx: offset.x, dy: offset.y)
            }
        }
    }
}
