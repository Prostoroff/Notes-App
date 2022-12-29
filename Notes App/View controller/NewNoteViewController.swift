//
//  NewNoteViewController.swift
//  Notes App
//
//  Created by Иван Осипов on 29.12.2022.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    // MARK: Public Properties

    var coreDataManager = CoreDataManager.shared
    
    // MARK: Private Properties
    
    private lazy var textView : UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        textView.keyboardType = .default
        textView.returnKeyType = .default
        textView.autocapitalizationType = .sentences
        textView.becomeFirstResponder()
        return textView
    }()
    
    // MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        createNotificationCenter()
        setupTextView()
        setupView()
    }
    
    // MARK: Objc Methods
    
    @objc func doneActionButton() {
        textView.resignFirstResponder()
        coreDataManager.save(text: textView.text)
    }
    
    @objc func updateTextView(param: Notification) {
        let userInfo = param.userInfo
        
        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)
        
        if param.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    // MARK: Private Methods
    
    private func setupNavigationController() {
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneActionButton))
    }
    
    private func createNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTextView() {
        textView.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: view.bounds.height - 120)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(textView)
    }

}
