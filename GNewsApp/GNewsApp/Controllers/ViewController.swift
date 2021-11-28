//
//  ViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 26/11/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebService.shared.getTopHeadlines()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
    }


}

