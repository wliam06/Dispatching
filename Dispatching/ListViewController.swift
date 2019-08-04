//
//  ViewController.swift
//  Dispatching
//
//  Created by William on 18/07/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var downloadTableView: UITableView!
    @IBOutlet weak var completedTableView: UITableView!
    @IBOutlet weak var countSlider: UISlider!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var randomSwitch: UISwitch!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskSlider: UISlider!

    struct SimulationOption {
        var jobCount: Int
        var maxAsyncTasks: Int
        var isRandomizedTime: Bool
    }

    var option: SimulationOption! {
        didSet {
            didSetJobLabel()
            didSetAsyncTaskLabel()
        }
    }

    var downloadTasks = [DownloadTask]() {
        didSet {
            downloadTableView.reloadData()
        }
    }

    var completedTasks = [DownloadTask]() {
        didSet {
            completedTableView.reloadData()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        option = SimulationOption(jobCount: Int(countSlider.value),
                                  maxAsyncTasks: Int(taskSlider.value), isRandomizedTime: randomSwitch.isOn)
        downloadTableView.tableFooterView = UIView()
        completedTableView.tableFooterView = UIView()
        setupNavigationItems()
    }

    private func setupNavigationItems() {
        let startButtonItem = UIBarButtonItem(title: "Start",
                                              style: .plain, target: self,
                                              action: #selector(startOperation))
        navigationItem.rightBarButtonItem = startButtonItem
    }

    @objc func startOperation() {
        downloadTasks = []
        completedTasks = []

        navigationItem.rightBarButtonItem?.isEnabled = true
        randomSwitch.isEnabled = false
        taskSlider.isEnabled = false
        countSlider.isEnabled = false

        let dispatchQueue = DispatchQueue(label: "com.william.dispatchQueue", qos: .userInitiated, attributes: .concurrent)
        let dispatchGroup = DispatchGroup()
        let dispatchSemaphore = DispatchSemaphore(value: option.maxAsyncTasks)

        downloadTasks = (1...option.jobCount).map({ (i) -> DownloadTask in
            let id = "\(i)"

            return DownloadTask(id: id, stateUpdatedHandler: { (task) in
                DispatchQueue.main.async { [unowned self] in
                    guard let index = self.downloadTasks.indexOfTaskWith(id: id) else {
                        return
                    }

                    switch task.state {
                    case .completed:
                        self.downloadTasks.remove(at: index)
                        self.completedTasks.insert(task, at: 0)
                    case .pending, .inProgress(_):
                        guard let cell = self.downloadTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ProgressCell else {
                            return
                        }

                        cell.configure(task)
                        self.downloadTableView.beginUpdates()
                        self.downloadTableView.endUpdates()
                    }
                }
            })
        })

        downloadTasks.forEach {
            $0.startTask(queue: dispatchQueue, group: dispatchGroup, semaphore: dispatchSemaphore, randomizeTime: self.option.isRandomizedTime)
        }

        dispatchGroup.notify(queue: .main) { [unowned self] in
            self.presentAlertWith(title: "Info", message: "All download tasks has been completed")
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.randomSwitch.isEnabled = true
            self.countSlider.isEnabled = true
            self.taskSlider.isEnabled = true
        }
    }

    // MARK: - Private method
    private func didSetJobLabel() {
        countLabel.text = "\(option.jobCount) Tasks"
    }

    private func didSetAsyncTaskLabel() {
        taskLabel.text = "\(option.maxAsyncTasks) Max Parallel Running Tasks"
    }

    @IBAction func taskSliderDidChanged(_ sender: UISlider) {
        option.maxAsyncTasks = Int(sender.value)
    }

    @IBAction func countSliderDidChanged(_ sender: UISlider) {
        option.jobCount = Int(sender.value)
    }

    @IBAction func timeSwitchDidChanged(_ sender: UISwitch) {
        option.isRandomizedTime = sender.isOn
    }

    private func presentAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == downloadTableView {
            return downloadTasks.count
        } else if tableView == completedTableView {
            return completedTasks.count
        } else {
            fatalError("Undefined numberOfRowsInSection")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProgressCell
        let task: DownloadTask

        if tableView == downloadTableView {
            task = downloadTasks[indexPath.row]
        } else if tableView == completedTableView {
            task = completedTasks[indexPath.row]
        } else {
            fatalError()
        }

        cell.configure(task)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == downloadTableView {
            return "Download Queue \(downloadTasks.count)"
        } else if tableView == completedTableView {
            return "Completed \(completedTasks.count)"
        } else {
            return nil
        }
    }
}
