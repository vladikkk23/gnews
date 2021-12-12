//
//  ImageDataViewModel.swift
//  GNewsApp
//
//  Created by vladikkk on 12/12/2021.
//

import UIKit
import RxSwift

class ImageDataViewModel {
    // MARK: Properties
    let image = PublishSubject<UIImage>()
    let imageService = ImageService.shared
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    func fetchImage(usingStringUrl stringUrl: String) {
        let result = imageService.loadImage(usingStringUrl: stringUrl)
        
        result
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                
                self.image.onNext(image ?? UIImage(systemName: "photo")!)
            })
            .disposed(by: disposeBag)
    }
}
