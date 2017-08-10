//
//  StudentCell.swift
//  WildDogIntegration
//
//  Created by Brian Voong on 8/5/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

