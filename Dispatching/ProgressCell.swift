//
//  ProgressCell.swift
//  Dispatching
//
//  Created by Wiliam on 04/08/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()

        downloadImageView.layer.masksToBounds = true
        downloadImageView.clipsToBounds = true
        downloadImageView.layer.cornerRadius = 5.0
    }

    func configure(_ task: DownloadTask) {
        titleLabel.text = "\(task.state.description) #\(task.id)"
        downloadImageView.image = UIImage.randomImage(seed: Int(task.id) ?? 0)

        switch task.state {
        case .pending:
            progressView.isHidden = true
            downloadImageView.isHidden = true
            subtitleLabel.isHidden = true
        case .inProgress(let complete):
            progressView.isHidden = false
            progressView.progress = Float(Double(complete) / 100.0)
            subtitleLabel.isHidden = false
            subtitleLabel.text = "\(complete)%"
            downloadImageView.isHidden = false
        case .completed:
            subtitleLabel.isHidden = true
            downloadImageView.isHidden = false
        }
    }
}
