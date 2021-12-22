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
    
    var currentTask: TaskProtocol? {
        didSet {
            tableView.reloadData()
            backButton.isEnabled = currentTask?.name == "Root" ?  false : true
        }
    }
    var lastTasks: [TaskProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTask = MainTask(name: "Root", subTasks: [])
        setupTableView()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        currentTask = lastTasks.removeLast()
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
        currentTask?.subTasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ToDoTableViewCell.identifier,
                for: indexPath) as? ToDoTableViewCell,
            let subTask = currentTask?.subTasks[indexPath.row],
            let currentTask = self.currentTask
        else {
            return UITableViewCell()
        }
        let newMainTask = MainTask(name: subTask.name, subTasks: subTask.subTasks)
        cell.configure(mainTask: newMainTask)
        cell.cellTapped = { [weak self] in
            self?.lastTasks.append(currentTask)
            self?.currentTask = subTask
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
            let newSubTask = MainTask(name: name, subTasks: [])
            self.currentTask?.subTasks.append(newSubTask)
            self.tableView.reloadData()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: {})
    }
}
