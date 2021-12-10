//
//  FiltersInputView.swift
//  GNewsApp
//
//  Created by vladikkk on 06/12/2021.
//

import UIKit
import RxSwift

// MARK: - FiltersInputView
class FiltersInputView: UIView {
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Date"
        lbl.font = UIFont(name: "Avenir-Medium", size: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var fromDateInputView: DateInputView = {
        let view = DateInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "From"
        return view
    }()
    
    lazy var toDateInputView: DateInputView = {
        let view = DateInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "To"
        return view
    }()
    
    lazy var searchInButton: SearchInView = {
        let view = SearchInView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        setupTitleLabelLayout()
        setupFromDateInputViewLayout()
        setupToDateInputViewLayout()
        setupSearchButtonLayout()
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupFromDateInputViewLayout() {
        addSubview(fromDateInputView)
        
        NSLayoutConstraint.activate([
            fromDateInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            fromDateInputView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fromDateInputView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            fromDateInputView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupToDateInputViewLayout() {
        addSubview(toDateInputView)
        
        NSLayoutConstraint.activate([
            toDateInputView.topAnchor.constraint(equalTo: fromDateInputView.bottomAnchor, constant: 30),
            toDateInputView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toDateInputView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            toDateInputView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupSearchButtonLayout() {
        addSubview(searchInButton)
        
        NSLayoutConstraint.activate([
            searchInButton.topAnchor.constraint(equalTo: toDateInputView.bottomAnchor, constant: 30),
            searchInButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchInButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            searchInButton.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

// MARK: - DateInputView
class DateInputView: UIView {
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Avenir", size: 12)
        lbl.textAlignment = .left
        lbl.textColor = .orange
        return lbl
    }()
    
    lazy var inputDateView: CustomDatePickerView = {
        let view = CustomDatePickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .orange
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    lazy var bottomBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        setupInputTextFieldLayout()
        setupTitleLabelLayout()
        setupImageLayout()
        setupBottomBorderView()
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupInputTextFieldLayout() {
        addSubview(inputDateView)
        
        NSLayoutConstraint.activate([
            inputDateView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputDateView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            inputDateView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            inputDateView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupImageLayout() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            image.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupBottomBorderView() {
        addSubview(bottomBorderView)
        
        NSLayoutConstraint.activate([
            bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomBorderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
            bottomBorderView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

// MARK: - CustomDatePickerView
class CustomDatePickerView: UIView {
    // MARK: Properties
    lazy var textField: UILabel = {
        let textField = UILabel()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "yyyy/mm/dd"
        textField.textColor = .lightGray
        textField.font = UIFont(name: "Avenir-Heavy", size: 15)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .white
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.timeZone = NSTimeZone.local
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        setupDatePickerLayout()
        setupTextFieldLayout()
    }
    
    private func setupDatePickerLayout() {
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            datePicker.heightAnchor.constraint(equalTo: self.heightAnchor),
            datePicker.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupTextFieldLayout() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor),
            textField.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

// MARK: - SearchInView
class SearchInView: UIView {
    // MARK: - Properties
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Search in"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 15)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "All"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 15)
        lbl.textAlignment = .right
        lbl.textColor = .lightGray
        return lbl
    }()
    
    lazy var bottomBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0.25
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        setupButtonLayout()
        setupTitleLabelLayout()
        setupValueLabelLayout()
        setupBottomBorderView()
    }
    
    private func setupButtonLayout() {
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.heightAnchor.constraint(equalTo: self.heightAnchor),
            button.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupValueLabelLayout() {
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            valueLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
            valueLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65)
        ])
    }
    
    private func setupBottomBorderView() {
        addSubview(bottomBorderView)
        
        NSLayoutConstraint.activate([
            bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomBorderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
            bottomBorderView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

// MARK: - CustomRoundedButton
class CustomRoundedButton: UIView {
    // MARK: - Properties
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Avenir-Black", size: 16)
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        setupTitleLabelLayout()
        setupButtonLayout()
    }
    
    private func setupButtonLayout() {
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.heightAnchor.constraint(equalTo: self.heightAnchor),
            button.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupTitleLabelLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
}

// MARK: - Extension to make rounded corners
extension CustomRoundedButton {
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
    }
}
