//
//  DownloadTask.swift
//  Dispatching
//
//  Created by William on 02/08/19.
//  Copyright © 2019 William. All rights reserved.
//

import Foundation

class DownloadTask {

    var progress: Int = 0
    let id: String
    let stateUpdatedHandler: (DownloadTask) -> ()
    var state = TaskState.pending {
        didSet {
            self.stateUpdatedHandler(self)
        }
    }

    init(id: String, stateUpdatedHandler: @escaping (DownloadTask) -> ()) {
        self.id = id
        self.stateUpdatedHandler = stateUpdatedHandler
    }

    func startTask(queue: DispatchQueue, group: DispatchGroup, semaphore: DispatchSemaphore, randomizeTime: Bool = true) {
    }

    private func startSleep(randomizeTime: Bool = true) {
        Thread.sleep(forTimeInterval: randomizeTime ? Double(Int.random(in: 1...3)) : 1.0)
    }
}

enum TaskState {
    case pending
    case inProgress(Int)
    case completed

    var description: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress(_):
            return "Downloading"
        case .completed:
            return "Completed"
        }
    }
}

extension Array where Element == DownloadTask {
    func downloadTaskWith(id: String) -> DownloadTask? {
        return self.first { $0.id == id }
    }

    func indexOfTaskWith(id: String) -> Int? {
        return self.firstIndex(where: {$0.id == id })
    }
}
