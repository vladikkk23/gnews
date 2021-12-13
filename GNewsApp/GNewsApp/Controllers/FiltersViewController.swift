//
//  FiltersViewController.swift
//  GNewsApp
//
//  Created by vladikkk on 05/12/2021.
//

import UIKit
import RxSwift

class FiltersViewController: UIViewController {
    // MARK: - Properties
    var navigationViewModel: NavigationViewModel! {
        didSet {
            bindNavigationData()
        }
    }
    
    var viewModel: DataViewModel! {
        didSet {
            bindData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    lazy var filtersInputView: MainFiltersView = {
        let view = MainFiltersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.filtersView.fromDateInputView.inputDateView.datePicker.addTarget(self, action: #selector(fromDatePickerChanged(sender:)), for: .valueChanged)
        view.filtersView.toDateInputView.inputDateView.datePicker.addTarget(self, action: #selector(toDatePickerChanged(sender:)), for: .valueChanged)
        return view
    }()
    
    lazy var contentFiltersSelectionView: SecondaryFiltersView = {
        let view = SecondaryFiltersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        setupFiltersInputViewLayout()
        setupContentFiltersSelectionViewLayout()
    }
    
    private func setupFiltersInputViewLayout() {
        view.addSubview(filtersInputView)
        
        NSLayoutConstraint.activate([
            filtersInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersInputView.topAnchor.constraint(equalTo: view.topAnchor),
            filtersInputView.heightAnchor.constraint(equalTo: view.heightAnchor),
            filtersInputView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupContentFiltersSelectionViewLayout() {
        view.addSubview(contentFiltersSelectionView)
        
        NSLayoutConstraint.activate([
            contentFiltersSelectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentFiltersSelectionView.topAnchor.constraint(equalTo: view.topAnchor),
            contentFiltersSelectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            contentFiltersSelectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
}

// MARK: - Extension to hide sortSelectionView before view did load
extension FiltersViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentFiltersSelectionView.shift(duration: 0, toogle: false, offset: CGPoint(x: view.frame.width, y: 0))
    }
}

// MARK: - Bind Navigation Data
extension FiltersViewController {
    private func bindNavigationData() {
        bindFiltersInputViewNavigationData()
        bindContentFiltersSelectionViewNavigationData()
    }
    
    private func bindFiltersInputViewNavigationData() {
        filtersInputView.navigationView.backButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.navigationViewModel.isFiltersViewActive.onNext(.none)
            }
            .disposed(by: disposeBag)
        
        filtersInputView.filtersView.searchInButton.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.contentFiltersSelectionView.shift(duration: 0.5, toogle: true, offset: CGPoint(x: self.view.frame.width, y: 0))
            }
            .disposed(by: disposeBag)
        
        filtersInputView.applyButton.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.saveFilters.onNext(())
                self.navigationViewModel.primaryFilterSelected.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
    private func bindContentFiltersSelectionViewNavigationData() {
        contentFiltersSelectionView.navigationView.backButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.fetchFilters.onNext(())
                self.navigationViewModel.isFiltersViewActive.onNext(.primary)
            }
            .disposed(by: disposeBag)
        
        contentFiltersSelectionView.applyButton.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.saveFilters.onNext(())
                self.navigationViewModel.primaryFilterSelected.onNext(())
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind View Data
extension FiltersViewController {
    private func bindData() {
        bindFiltersInputViewData()
        bindContentFiltersSelectionViewData()
    }
    
    private func bindFiltersInputViewData() {
        filtersInputView.navigationView.clearButton.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.clearFilters.onNext(())
            }
            .disposed(by: disposeBag)
        
        viewModel.fromDateSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] stringDate in
                guard let self = self else { return }
                
                if stringDate.count > 0 {
                    self.filtersInputView.filtersView.fromDateInputView.inputDateView.textField.text = stringDate
                    self.filtersInputView.filtersView.fromDateInputView.inputDateView.textField.textColor = .black
                } else {
                    self.filtersInputView.filtersView.fromDateInputView.inputDateView.textField.text = "yyyy/mm/dd"
                    self.filtersInputView.filtersView.fromDateInputView.inputDateView.textField.textColor = .lightGray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.toDateSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] stringDate in
                guard let self = self else { return }
                
                if stringDate.count > 0 {
                    self.filtersInputView.filtersView.toDateInputView.inputDateView.textField.text = stringDate
                    self.filtersInputView.filtersView.toDateInputView.inputDateView.textField.textColor = .black
                } else {
                    self.filtersInputView.filtersView.toDateInputView.inputDateView.textField.text = "yyyy/mm/dd"
                    self.filtersInputView.filtersView.toDateInputView.inputDateView.textField.textColor = .lightGray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.searchInSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                
                switch title.count {
                case 0...3:
                    self.filtersInputView.filtersView.searchInButton.valueLabel.text = "None"
                case 4...20:
                    self.filtersInputView.filtersView.searchInButton.valueLabel.text = title
                default:
                    self.filtersInputView.filtersView.searchInButton.valueLabel.text = "All"
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindContentFiltersSelectionViewData() {
        contentFiltersSelectionView.navigationView.clearButton.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.clearFilters.onNext(())
            }
            .disposed(by: disposeBag)
        
        contentFiltersSelectionView.contentSelectionView.titleSwitchView.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.contentFiltersSelectionView.contentSelectionView.titleSwitchView.valueSwitch.isOn.toggle()
                self.viewModel.inTitleSelected.onNext(self.contentFiltersSelectionView.contentSelectionView.titleSwitchView.valueSwitch.isOn)
            }
            .disposed(by: disposeBag)
        
        contentFiltersSelectionView.contentSelectionView.descriptionSwitchView.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.contentFiltersSelectionView.contentSelectionView.descriptionSwitchView.valueSwitch.isOn.toggle()
                self.viewModel.inDescriptionSelected.onNext(self.contentFiltersSelectionView.contentSelectionView.descriptionSwitchView.valueSwitch.isOn)
            }
            .disposed(by: disposeBag)
        
        contentFiltersSelectionView.contentSelectionView.contentSwitchView.button.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.contentFiltersSelectionView.contentSelectionView.contentSwitchView.valueSwitch.isOn.toggle()
                self.viewModel.inContentSelected.onNext(self.contentFiltersSelectionView.contentSelectionView.contentSwitchView.valueSwitch.isOn)
            }
            .disposed(by: disposeBag)
        
        viewModel.inTitleSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.contentFiltersSelectionView.contentSelectionView.titleSwitchView.valueSwitch.isOn = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.inDescriptionSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.contentFiltersSelectionView.contentSelectionView.descriptionSwitchView.valueSwitch.isOn = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.inContentSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.contentFiltersSelectionView.contentSelectionView.contentSwitchView.valueSwitch.isOn = $0
            })
            .disposed(by: disposeBag)
    }
}

extension FiltersViewController {
    @objc func fromDatePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let somedateString = dateFormatter.string(from: sender.date)
        
        viewModel.fromDateSelected
            .onNext(somedateString)
    }
    
    @objc func toDatePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let somedateString = dateFormatter.string(from: sender.date)
        
        viewModel.toDateSelected
            .onNext(somedateString)
    }
}
