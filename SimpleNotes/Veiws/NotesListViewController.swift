//
//  ViewController.swift
//  SimpleNotes
//
//  Created by Kamil Biktineyev on 01.07.2024.
//

import UIKit

protocol NotesListProtocol: AnyObject {
    func refreshTableView()
}

final class NotesListViewController: UIViewController, NotesListProtocol {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.accessibilityLabel = "NotesSearchBar"
        return searchBar
    }()
    
    private lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityLabel = "NotesTableView"
        return tableView
    }()
    
    private var isSearching: Bool = false
    
    var presenter: NotesListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        setupSearchBar()
        setupNotesTableView()
        addLongPressGesture()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isSearching = false
        searchBar.text = ""
        refreshTableView()
    }
    
    // Определяем метод для обновления notesTableView
    func refreshTableView() {
        notesTableView.reloadData()
    }
    
    // Определяем внешний вид NavigationBar
    private func createNavigationBar() {
        view.backgroundColor = .white
        title = "Simple Notes"
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteButtonTapped))
        addNoteButton.accessibilityLabel = "AddNote"
        self.navigationItem.rightBarButtonItem = addNoteButton
    }
    
    // Определяем расроложение searchBar
    private func setupSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    // Определяем расроложение notesTableView
    private func setupNotesTableView() {
        view.addSubview(notesTableView)
        NSLayoutConstraint.activate([
            notesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // Определяем действие при нажатии на "+"
    @objc private func addNoteButtonTapped() {
        let alert = UIAlertController(title: "Create a note", message: "", preferredStyle: .alert)
        alert.addTextField()
        let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
            if let textName = alert.textFields?.first?.text {
                self.presenter.addNote(name: textName)
                self.refreshTableView()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    // Создаем экземпляр Long Press Gesture (переименовать заметку)
    private func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        notesTableView.addGestureRecognizer(longPressGesture)
    }
    
    // Определяем метод для обрабоки Long Press Gesture
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if isSearching == false {
            if gesture.state == .began {
                let location = gesture.location(in: notesTableView) // Возвращает точку, в которой произошло касание в координатах таблицы
                let indexPath = notesTableView.indexPathForRow(at: location) // Позволяет получить IndexPath для ячейки, соответствующей этой точке
                if let indexPath = indexPath {
                    let alert = UIAlertController(title: "Choose a new name for the note \(presenter.notes[indexPath.row].name)?", message: "", preferredStyle: .alert)
                    alert.addTextField()
                    let saveButton = UIAlertAction(title: "Rename", style: .default) { _ in
                        if let textName = alert.textFields?.first?.text {
                            self.presenter.renameNote(newName: textName, index: indexPath.row)
                            self.refreshTableView()
                        }
                    }
                    let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
                    alert.addAction(saveButton)
                    alert.addAction(cancelButton)
                    present(alert, animated: true)
                }
            }
        }
    }
}


extension NotesListViewController: UITableViewDataSource, UITableViewDelegate {
    // Определяем количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false {
            return presenter.notes.count
        } else {
            return presenter.filteredNotes.count
        }
    }
    
    // Определяем как будет выглядеть ячейка таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var listConfig = cell.defaultContentConfiguration()
        
        if isSearching == false {
            listConfig.text = presenter.notes[indexPath.row].name
            listConfig.secondaryText = presenter.notes[indexPath.row].details
        } else {
            listConfig.text = presenter.filteredNotes[indexPath.row].name
            listConfig.secondaryText = presenter.filteredNotes[indexPath.row].details
        }
        
        listConfig.textProperties.font = UIFont.boldSystemFont(ofSize: 18)
        listConfig.textProperties.numberOfLines = 1
        listConfig.secondaryTextProperties.numberOfLines = 1
        cell.contentConfiguration = listConfig
        return cell
    }
    
    // Определяем переход внутрь заметки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delegate = presenter.self as! NotesListPresenterDelegate
        if isSearching == false {
            let note = presenter.notes[indexPath.row]
            let detailedNoteViewController = ViewBuilder.createDetailedNoteView(note: note, noteIndexPath: indexPath.row, delegate: delegate)
            navigationController?.pushViewController(detailedNoteViewController, animated: true)
        } else {
            for index in 0..<presenter.notes.count {
                if presenter.filteredNotes[indexPath.row].id == presenter.notes[index].id {
                    let note = presenter.notes[index]
                    let detailedNoteViewController = ViewBuilder.createDetailedNoteView(note: note, noteIndexPath: index, delegate: delegate)
                    navigationController?.pushViewController(detailedNoteViewController, animated: true)
                }
            }
        }
    }
    
    // Определяем возможность удаления ячейки из таблицы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteNote(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Определяем метод для исчесзновения клавиатуры во время скролинга
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        }
}

extension NotesListViewController: UISearchBarDelegate {
    // Определяем действие при поиске в Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterNotes(searchingText: searchText)
        if searchText == "" {
            isSearching = false
            refreshTableView()
        } else {
            isSearching = true
            refreshTableView()
        }
        
    }
}

