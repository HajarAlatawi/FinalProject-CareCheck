

import UIKit

class WebCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var webImageView: UIImageView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var webTitleLabel: UILabel!
    
    
    var webPage: WebPage? {
        didSet {
            updateUI()
        }
    }
    
    
    private func updateUI(){
        webImageView.image = UIImage(named: webPage!.image)
        webTitleLabel.text = webPage!.title
        
    }
    
}
