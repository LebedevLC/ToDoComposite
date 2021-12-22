//
//  ToDoViewController.swift
//  ToDoComposite
//
//  Created by Сергей Чумовских  on 20.12.2021.
//

import UIKit

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var currentTask: MainTask? {
        didSet {
        tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTask = MainTask(name: "Root", subTask: [])
        setupTableView()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        currentTask = ToDoSingleton.shared.mainTask
    }
}

// MARK: - TableView

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: ToDoTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ToDoTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentTask?.subTask.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ToDoTableViewCell.identifier,
                for: indexPath) as? ToDoTableViewCell,
            let subTask = currentTask?.subTask[indexPath.row]
        else {
            return UITableViewCell()
        }
        let newMainTask = MainTask(name: subTask.name, subTask: subTask.subTask)
        cell.configure(mainTask: newMainTask, subTask: subTask)
        cell.cellTapped = { [weak self] in
            ToDoSingleton.shared.mainTask = self?.currentTask
            self?.currentTask = cell.mainTask
        }
        return cell
    }
}

// MARK: - Alert

extension ToDoViewController {
    private func showAlert() {
        let alertController = UIAlertController(
            title: "Please write task",
            message: nil,
            preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
        })
        let okAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            guard
                let self = self,
                let name = alertController.textFields?[0].text,
                name != ""
            else { return }
            guard let currentTask = self.currentTask
            else {
                debugPrint("No MainTask!")
                return }
            currentTask.addSubtask(subTask: SubTask(name: name, mainTask: currentTask))
            self.tableView.reloadData()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: {})
    }
}
