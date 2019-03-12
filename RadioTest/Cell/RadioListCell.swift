//
//  RadioListCell.swift
//  RadioTest
//
//  Created by Amir Daliri on 11.03.2019.
//  Copyright © 2019 AmirDaliri. All rights reserved.
//

import UIKit

class RadioListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 78/255, green: 82/255, blue: 93/255, alpha: 0.6)
        selectedBackgroundView  = selectedView
    }

    func configureStationCell(station: RadioList) {
        
        nameLabel.text = station.name
        descLabel.text = station.desc
        
        let imageURL = station.imageURL as NSString
        print(imageURL)
        if imageURL.contains("http") {
            
            if let url = URL(string: station.imageURL) {
                avatarImageView.loadImageWithURL(url: url) { (image) in
                    print(image, url)
                    // station image loaded
                }
            }
            
        } else if imageURL != "" {
            avatarImageView.image = UIImage(named: imageURL as String)
            
        } else {
            avatarImageView.image = UIImage(named: "ic-radioLogo")
        }
        
        avatarImageView.applyShadow()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        nameLabel.text  = nil
        descLabel.text  = nil
        avatarImageView.image = nil
    }

}
