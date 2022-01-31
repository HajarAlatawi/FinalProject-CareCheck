

import UIKit

struct WebPage {
    
    var title: String
    var url: String
    var image: String

    
    static func fetchWebPages() -> [WebPage] {
        let wP1 = WebPage(title: "Jigsaw Puzzle",
                         url: "https://www.jigsawexplorer.com/online-jigsaw-puzzle-player.html?puzzle_id=tre-cime-di-lavaredo",
                         image: "Jigsaw Puzzle")
      
        let wP2 = WebPage(title: "Picture Match",
                          url: "https://www.tinytap.com/activities/g3of1/play/matching-pic-to-word",
                          image: "Picture Match")
      
        let wP3 = WebPage(title: "Solitaire",
                          url: "https://solitaired.com",
                          image: "Solitaire")
      
        let wP4 = WebPage(title: "Dominoes",
                          url: "http://www.onlinedominogames.com/draw-dominoes",
                          image: "Dominoes")
      
        let wP5 = WebPage(title: "Colors Word Match",
                         url: "https://www.tinytap.com/activities/g480e/play/colors-word-match",
                         image: "Colors Word Match")
      
        let wP6 = WebPage(title: "Sudoku",
                          url: "https://sudoku.com",
                          image: "Sudoku")
      
        let wP7 = WebPage(title: "Picture Perfect",
                          url: "https://www.cbc.ca/kids/games/pictureperfect/",
                          image: "Picture Perfect")
      
        let wP8 = WebPage(title: "Crossword Puzzle",
                          url: "https://www.boatloadpuzzles.com/playcrossword",
                          image: "Crossword Puzzle")

        
        return [wP1, wP2, wP3, wP4, wP5, wP6, wP7, wP8]
    }
}
