//
//  ViewController.swift
//  WildDogIntegration
//
//  Created by Brian Voong on 8/5/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Wilddog

class ClassroomMessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var messages = [ClassroomMessage]()
    
    var classroom: student? {
        didSet {
            navigationItem.title = classroom?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        guard let classroomId = classroom?.name else { return }
        
        let ref = WDGSync.sync().reference().child("classroom-messages").child(classroomId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let text = dictionary["text"] as? String ?? ""
            let message = ClassroomMessage(text: text)
            self.messages.append(message)
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to observe messages:", err)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter text"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    func handleSend() {
        guard let classroomId = classroom?.name else { return }
        let ref = WDGSync.sync().reference().child("classroom-messages").child(classroomId).childByAutoId()
        ref.updateChildValues(["text": inputTextField.text!])
        inputTextField.text = ""
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return textInputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    lazy var textInputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        containerView.backgroundColor = .white
        //        containerView.frame = CGRect(x: 0, y: self.view.frame.height - 50 - 64, width: self.view.frame.width, height: 50)
        //
        containerView.addSubview(self.inputTextField)
        containerView.addSubview(self.sendButton)
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dividerView)
        dividerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        dividerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        dividerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        self.sendButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        self.inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
        
        return containerView
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MessageCell
        cell.textLabel.text = messages[indexPath.item].text
        return cell
    }
}


