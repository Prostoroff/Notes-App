//
//  NoteTableViewController.swift
//  Notes App
//
//  Created by Иван Осипов on 29.12.2022.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    // MARK: Public Properties
    
    var coreDataManager = CoreDataManager.shared
    
    // MARK: Override Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        coreDataManager.getNote()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notes"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editNoteVC = segue.destination as? EditNoteViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        editNoteVC?.index = indexPath.row
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.notesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let note = coreDataManager.notesArray[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = note.text
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let noteObject = coreDataManager.notesArray[indexPath.row]
        coreDataManager.delete(noteObject, indexPath: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
