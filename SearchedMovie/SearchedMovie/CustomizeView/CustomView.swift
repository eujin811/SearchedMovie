//
//  CustomView.swift
//  SearchedMovie
//
//

import UIKit

class CustomView: UIView {
    let screenSize = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = .clear
    }
    
    func setConstraint() {
        
    }
}
