//
//  Button.swift
//  UnsplashAPIFetchingApp
//
//  Created by ARMBP on 1/5/23.
//

import UIKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
    convenience init(backgroundcolor: UIColor, title: String){
        self.init(frame: .zero)
        self.backgroundColor    = backgroundcolor
        self.setTitle(title, for: .normal)
    }
    
    
    private func configure(){
        layer.cornerRadius      = 10
        titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor    = backgroundColor
        setTitle(title, for: .normal)
    }
}