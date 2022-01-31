

import UIKit
import AVKit
import AVFoundation

class TutorialTableViewController: UITableViewController {
    
    var videos: [Video] = Video.fetchVideos()
    var player = AVPlayer()
    var playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
  
        return videos.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell",
                                                 for: indexPath) as! TutorialTableCell
        
        let video = videos[indexPath.row]
        cell.video = video
        
        return cell
    }
    
  
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        playVideo(at: indexPath)
    }
    
    
    func playVideo(at indexPath: IndexPath){
        
        let selectedVideo = videos[indexPath.row]
        
      let videoPath = Bundle.main.path(forResource: selectedVideo.videoFileName,
                                         ofType: "mp4")
      
        let vedioPathURL = URL(fileURLWithPath: videoPath!)
      
        player = AVPlayer(url: vedioPathURL)
        playerViewController.player = player
        
        self.present(playerViewController,
        animated: true,
                     completion: {
            self.playerViewController.player?.play()
        })
    }
    
}
