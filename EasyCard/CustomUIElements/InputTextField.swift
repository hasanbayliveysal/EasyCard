//
//  InputTextField.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//


import UIKit

class InputTextField: UITextField {
    let inset: CGFloat = 10
   
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: "buttonBackground")?.cgColor
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        autocorrectionType = .no
    }
    
}
