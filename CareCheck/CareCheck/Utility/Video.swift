

import UIKit

struct Video {
    
    let authorName: String
    let videoFileName: String
    let fileName: String
    
    static func fetchVideos() -> [Video] {
      
        let v1 = Video(authorName: "Learn about Alzheimer's Disease",
                       videoFileName: "v1",
                       fileName: "v1")
        
        let v2 = Video(authorName: "How to treat Alzheimer's patient",
                       videoFileName: "v2",
                       fileName: "v2")
        
        let v3 = Video(authorName: "How to decrese memory loss",
                       videoFileName: "v3",
                       fileName: "v3")
        
        let v4 = Video(authorName: "Keeping Alzheimer's Patients Safe",
                       videoFileName: "v4",
                       fileName: "v4")
        
        return [v1, v2, v3, v4]
    }
}
