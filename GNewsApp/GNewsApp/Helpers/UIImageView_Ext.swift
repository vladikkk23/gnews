//
//  UIImageView_Ext.swift
//  GNewsApp
//
//  Created by vladikkk on 29/11/2021.
//

import UIKit
import RxSwift

extension UIImage {
    func load(url: URL) -> Observable<UIImage?> {
        return URLSession.shared.rx
            .data(request: URLRequest(url: url))
                .map { data in UIImage(data: data) }
                .asObservable()
    }
}

extension UIViewController {
    func configureDismissKeyboard() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        sender?.view?.endEditing(true)
    }
    
    func presentOnTop(_ viewController: UIViewController, animated: Bool) {
        var topViewController = self
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        topViewController.present(viewController, animated: animated)
    }
}
