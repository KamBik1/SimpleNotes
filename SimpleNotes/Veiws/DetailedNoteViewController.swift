//
//  DetailedNoteViewController.swift
//  SimpleNotes
//
//  Created by Kamil Biktineyev on 02.07.2024.
//

import UIKit

protocol DetailedNoteProtocol: AnyObject {
}

final class DetailedNoteViewController: UIViewController, DetailedNoteProtocol {

    private lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = presenter.note.details
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textAlignment = .left
        textView.isEditable = true
        textView.isSelectable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.accessibilityLabel = "NoteTextView"
        return textView
    }()
    
    var presenter: DetailedNotePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        setupNoteTextField()
        addNotificationCenter()
        addSwipeGesture()
    }
    
    // Определяем внешний вид NavigationBar
    private func createNavigationBar() {
        view.backgroundColor = .white
        title = presenter.note.name
    }
    
    // Определяем расроложение noteTextField
    private func setupNoteTextField() {
        view.addSubview(noteTextView)
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // Добавляем NoteViewController в центр сообщений как наблюдателя за сообщениями о появлении и исчезновении клавиатуры
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveTextViewUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveTextViewDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Определяем метод для поднятия контента в TextView при появлении клавиатуры
    @objc private func moveTextViewUp(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardFrame!.size.height
        
        noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    // Определяем метод для опускания контента в TextView при исчезновении клавиатуры
    @objc private func moveTextViewDown(notification: NSNotification) {
        noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // Создаем экземпляр Swipe Gesture (убрать клавиатуру)
    func addSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .right
        noteTextView.addGestureRecognizer(swipeGesture)
    }
    
    // Определяем метод для обрабоки Swipe Gesture
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        noteTextView.resignFirstResponder()
    }
}

extension DetailedNoteViewController: UITextViewDelegate {
    // Определяем метод, который вызывается каждый раз, когда изменяется текст в UITextView
    func textViewDidChange(_ textView: UITextView) {
        presenter.delagate?.updateNoteDetails(details: noteTextView.text, index: presenter.noteIndexPath)
    }
}
