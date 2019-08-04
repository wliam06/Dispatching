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
    }

    private func setupNavigationItems() {
        let startButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startOperation))
    }

    @objc func startOperation() {
        // TODO: Simulate download tasks with dispatch group and semaphore
    }

    // MARK: - Private method
    private func didSetJobLabel() {
    }

    private func didSetAsyncTaskLabel() {
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
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
