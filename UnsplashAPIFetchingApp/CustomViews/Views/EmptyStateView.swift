//
//  EmptyStateView.swift
//  UnsplashAPIFetchingApp
//
//  Created by ARMBP on 1/5/23.
//

import UIKit

class EmptyStateView: UIView {
    
    let messageLabel = TitleLabel(textAlignment: .center, fontSize: 28)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func configure(){
        addSubview(messageLabel)
        messageLabel.textColor = Colors.WhiteandFluffyColor
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 150),
            messageLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
        
    }
}

