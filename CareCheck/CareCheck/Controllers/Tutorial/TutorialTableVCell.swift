

import UIKit

class TutorialTableCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var video: Video! {
        didSet {
            updateUI()
        }
    }
     
   private func updateUI() {
        thumbnailImageView.image = UIImage(named: video.fileName)
        thumbnailImageView.layer.cornerRadius = 0.5
        thumbnailImageView.layer.masksToBounds = true
        userNameLabel.text = video.authorName
    }
}

