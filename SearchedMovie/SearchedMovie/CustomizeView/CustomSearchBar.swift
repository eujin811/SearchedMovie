//
//  CustomSearchBar.swift
//  SearchedMovie
//
//

import UIKit

import SnapKit

class CustomSearchBar: CustomView {
    let textField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(UIImage.setIcon(.search), for: .normal)
        $0.tintColor = .lightGray
    }
    private let cancelButton = UIButton().then {
        $0.setImage(UIImage.setIcon(.xCircle), for: .normal)
        $0.tintColor = .lightGray
        $0.isHidden = true
    }
    
    private let basicTextFieldHeight: CGFloat = 36
    private let buttonPadding: CGFloat = 4
    
    override func setUI() {
        super.setUI()
        self.addSubview(textField)
        
        self.addSubview(searchButton)
        self.addSubview(cancelButton)
    }
    
    override func setConstraint() {
        super.setConstraint()
                
        let buttonSize: CGFloat = basicTextFieldHeight - buttonPadding
        
        textField.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalTo(basicTextFieldHeight)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(textField).inset(buttonPadding)
            $0.size.equalTo(buttonSize)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.trailing.size.equalTo(searchButton)
        }
    }
    
    func showSearchButton() {
        searchButton.isHidden = false
        cancelButton.isHidden = true
    }
    
    func showCancelButton() {
        cancelButton.isHidden = false
        searchButton.isHidden = true
    }
    
    func setTextFieldHeight(height: CGFloat) {
        let textFieldHeight = height > basicTextFieldHeight ? height : height
        let buttonSize = textFieldHeight - buttonPadding

        textField.snp.updateConstraints {
            $0.height.equalTo(height)
        }

        cancelButton.snp.updateConstraints {
            $0.size.equalTo(buttonSize)
        }
    }
    
    func inset(_ padding: CGFloat) {
        textField.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(padding)
        }
    }
    
    
    func didTapSearchButton(_ action: @escaping() -> Void) {
        let addAction = UIAction { [weak self] _ in
            action()
            self?.showCancelButton()
            print("ui search")
        }
        
        searchButton.addAction(addAction, for: .touchUpInside)
    }
    
    func didTapCancelButton(_ action: @escaping() -> Void) {
        let addAction = UIAction { [weak self] _ in
            action()
            
            self?.clearTextField()
            self?.showSearchButton()
        }
        
        cancelButton.addAction(addAction, for: .touchUpInside)
    }
    
    // MARK: - private
    
    private func clearTextField() {
        textField.text = String.empty
    }
}
