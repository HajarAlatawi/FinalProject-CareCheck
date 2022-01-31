

import UIKit
import SafariServices

private let reuseIdentifier = "Cell"

class ExercisesCollectionViewController: UICollectionViewController {

    let exercises: [WebPage] = WebPage.fetchWebPages()
    
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 20.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let widthOfCell = ((collectionView!.frame.width) - leftAndRightPaddings) / numberOfItemsPerRow
        
        let layoutOfCell = collectionViewLayout as! UICollectionViewFlowLayout
        layoutOfCell.itemSize = CGSize(width: widthOfCell,
                                       height: widthOfCell + heightAdjustment)
        
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self,
                                      forCellWithReuseIdentifier: reuseIdentifier)
    }



    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }

  
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "webCell", for: indexPath) as! WebCollectionViewCell
        
        let webPage = exercises[indexPath.row]
        
        cell.webPage = webPage
    
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let selectedExercise = exercises[indexPath.row]
        
        let webVC = SFSafariViewController(url: URL(string: selectedExercise.url)!)
        webVC.title = selectedExercise.title
        present(webVC, animated: true, completion: nil)
        

    }


}
