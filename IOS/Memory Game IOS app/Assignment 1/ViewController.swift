//
//  ViewController.swift
//  Assignment 1
//
//  Created by Nicholas Judd on 27/03/2016.
//  Copyright © 2016 Nicholas Judd. All rights reserved.
//
import Foundation
import UIKit

let imageList: [String] = ["baldhill", "lake", "cathedral"]

class ViewController: UIViewController, GameModelDelegate, TileViewDelegate{
    @IBAction func restButton(sender: UIButton) {
        scoreIBOutlet.text=String("0")
        start()
    }
    @IBOutlet weak var scoreIBOutlet: UILabel!
    var gameModelRefrence: GameModel?
    var tileViewRefrence: TileView?
    let myGameModel = GameModel(numOfTile: 12, imageList: imageList)
    var tileViewArray: [TileView] = []
    let numberOfTiles = 12
    var gameModelDelegate = self
    //var tileViewDelegate = self
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    func start(){
        gameModelRefrence = myGameModel
        myGameModel.reset(imageList)
        for index in 1...12{
            let tileViewReference = view.viewWithTag(index) as! TileView
            tileViewArray.append(tileViewReference)
            let tileData = gameModelRefrence?.tileArray[index-1]
            self.tileViewArray[index-1].tileImage = UIImage(named: tileData!.tileImage)
            self.tileViewArray[index-1].tileIndex = index
            self.tileViewArray[index-1].delegate = self as TileViewDelegate
            self.tileViewArray[index-1].setDefault(self.tileViewArray[index-1])
            self.tileViewArray[index-1].checked = false
            self.tileViewArray[index-1].alpha = 0.0
            UIView.animateWithDuration(0.5, animations: {
                self.tileViewArray[index-1].alpha = 1.0
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fix this add score and shit
    func gameDidComplete(gameModel: GameModel){
        scoreIBOutlet.text=String("0")
        let alert = UIAlertView();
        alert.title = "WINNER"
        if (1200 - (gameModelRefrence?.score)!) == 0{
            alert.message = "WOW A PERFECT SCORE YOU TRULY ARE AMAZING"
        }else {
            alert.message = "congragulations you won with a score of: " + String(gameModelRefrence!.score) + " points you were: " + String(1200-gameModelRefrence!.score) + " points off a perfect score"
        }
        alert.addButtonWithTitle("Reset")
        alert.show()
        gameModelRefrence?.reset(imageList)
        start()
    }
    
    func didMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int){
        tileViewArray[tileIndex-1].checked = true;
        tileViewArray[previousTileIndex-1].checked = true;
        scoreDidUpdate(gameModel, newScore: 200)
        gameModel.numberOfMatched += 1
        tileViewArray[tileIndex-1].hideTiles(tileViewArray[tileIndex-1])
        tileViewArray[previousTileIndex-1].hideTiles(tileViewArray[previousTileIndex-1])
        if (gameModel.numberOfMatched == 6){
            gameDidComplete(gameModel)
        }
    }
    
    func didFailToMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int){
        tileViewArray[previousTileIndex-1].coverTile(tileViewArray[previousTileIndex-1])
        tileViewArray[tileIndex-1].coverTile(tileViewArray[tileIndex-1])
        scoreDidUpdate(gameModel, newScore: -100)
        
    }
    
    func scoreDidUpdate(gameModel: GameModel, newScore: Int){
        gameModel.score += newScore
        scoreIBOutlet.text = String(gameModel.score)
    }
    
    func didSelectTile(tileView: TileView){
        gameModelRefrence?.pushTileIndex(tileView.tileIndex!)
        if gameModelRefrence?.turn == true {
            //gets the image identifier for both tapped tiles
            let tile1 = gameModelRefrence?.getIdentifier((gameModelRefrence?.lastTileTapped)!)
            let tile2 = gameModelRefrence?.getIdentifier((gameModelRefrence?.secondLastTileTapped)!)
            // checks if the two tiles images matched
            if tile1 == tile2{
                //calss the function for when the two tiles match
                print("Match")
                self.didMatchTile(self.gameModelRefrence!,
                                  tileIndex: self.gameModelRefrence!.lastTileTapped,
                                  previousTileIndex: self.gameModelRefrence!.secondLastTileTapped)
                
            }else {
                print("no match")
                //calls the function for when the tiles do not match
                self.didFailToMatchTile(self.gameModelRefrence!,
                                        tileIndex: self.gameModelRefrence!.lastTileTapped,
                                        previousTileIndex: self.gameModelRefrence!.secondLastTileTapped)
                
            }
            //sets the turn indicator back to the first turn
            gameModelRefrence?.turn = false
        }else {
            //sets the turn indicator stating its the second turn
            gameModelRefrence?.turn = true
            
        }
        }
}

