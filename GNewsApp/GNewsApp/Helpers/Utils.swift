//
//  Utils.swift
//  GNewsApp
//
//  Created by vladikkk on 02/12/2021.
//

import UIKit
import RxSwift

// MARK: - Cache images
let imageCache = NSCache<NSString, UIImage>()

// MARK: - Extension to download image view url, asynchronous
extension UIImageView {
    func loadImage(withUrl url: URL) {
        if let cachedImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
                        
                        self?.image = image
                    }
                }
            }
        }
    }
}

// MARK: - Extension to present view controller
extension UIViewController {    
    func presentOnTop(_ viewController: UIViewController, animated: Bool) {
        var topViewController = self
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        topViewController.present(viewController, animated: animated)
    }
}

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
            
            UIView.animate(withDuration: 0.25, animations: {
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
                self.frame = self.frame.offsetBy(dx: -offset.x, dy: -offset.y)
            } else {
                self.frame = self.frame.offsetBy(dx: offset.x, dy: offset.y)
            }
        }
    }
}

// MARK: - Enum to differentiate between primary and secodnary filters view
enum FilterViewTypeEnum {
    case primary
    case secondary
    case none
}

// MARK: - PersistentDataTypes
enum PersistentDataTypes: String {
    case news
    case articles
    case sources
    case filters
    case sort
}

// MARK: - CircleLoadingIndicator
class CircleLoadingIndicator: UIView {
    // MARK: - Properties
    private let circleTrackShapeLayer = CAShapeLayer()
    private let circleLineShapeLayer = CAShapeLayer()
    
    var radius: CGFloat {
        get {
            return self.bounds.height
        }
    }
    
    var trackColor = UIColor.red.cgColor
    var lineColor = UIColor.orange.cgColor
    var lineWidth: CGFloat = 10
    
    // MARK: - Methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        // Draw cirlce
        let trackPath = UIBezierPath(arcCenter: center, radius: self.radius, startAngle: -(CGFloat.pi / 2), endAngle: (CGFloat.pi * 2), clockwise: true)
        
        // Initialize layer path
        self.circleTrackShapeLayer.path = trackPath.cgPath
        
        // Customize layer
        self.circleTrackShapeLayer.strokeColor = self.trackColor
        self.circleTrackShapeLayer.lineWidth = self.lineWidth
        self.circleTrackShapeLayer.fillColor = UIColor.clear.cgColor
        self.circleTrackShapeLayer.lineCap = .round
        
        // Setup end point
        self.circleTrackShapeLayer.strokeEnd = 1
        
        // Add layer to view
        self.layer.addSublayer(self.circleTrackShapeLayer)
        
        // Draw cirlce
        let linePath = UIBezierPath(arcCenter: center, radius: self.radius, startAngle: -(CGFloat.pi / 2), endAngle: (CGFloat.pi * 2), clockwise: true)
        
        // Initialize layer path
        self.circleLineShapeLayer.path = linePath.cgPath
        
        // Customize layer
        self.circleLineShapeLayer.strokeColor = self.lineColor
        self.circleLineShapeLayer.lineWidth = self.lineWidth
        self.circleLineShapeLayer.fillColor = UIColor.clear.cgColor
        self.circleLineShapeLayer.lineCap = .round
        
        // Setup end point
        self.circleLineShapeLayer.strokeEnd = 0.15
        
        // Add layer to view
        self.layer.addSublayer(self.circleLineShapeLayer)
    }
}

// MARK: - Extension to add loading animation to CircleLoadingIndicator
extension CircleLoadingIndicator {
    func startLoad() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = 2
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        
        self.layer.add(rotateAnimation, forKey: "start_loading")
    }
    
    func stopLoad() {
        self.layer.removeAllAnimations()
    }
}
