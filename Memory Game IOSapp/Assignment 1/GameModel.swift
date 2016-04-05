//
//  GameModel.swift
//  Assignment 1
//
//  Created by Nicholas Judd on 27/03/2016.
//  Copyright © 2016 Nicholas Judd. All rights reserved.
//

import Foundation
import UIKit
//http://ijoshsmith.com/2014/06/17/randomly-shuffle-a-swift-array/
extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

protocol GameModelDelegate: class {
    func gameDidComplete(gameModel: GameModel)
    func didMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int)
    func didFailToMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int)
    func scoreDidUpdate(gameModel: GameModel, newScore: Int)
}

struct TileData {
    var tileImage: String // Used to create the images for use later.
    var imageIdentifier: Int // The identifier of the stored image.
    init ( name: String, id: Int){
        tileImage = name
        imageIdentifier = id
    }
}

class GameModel: CustomStringConvertible {
    
    var numberOfTile: Int
    var lastTileTapped: Int
    var secondLastTileTapped: Int
    var tileArray: [TileData] = [TileData]()
    var turn: Bool //false is first turn | true is second turn
    var numberOfMatched: Int
    var delegate : GameModelDelegate?
    var score: Int
    
    init(numOfTile: Int, imageList: [String]) {
        numberOfTile = numOfTile
        lastTileTapped = 0
        secondLastTileTapped = 0
        turn = false
        numberOfMatched = 0
        score = 0
        reset(imageList)
    }
    
    func reset(imageNameList: [String]) {
        lastTileTapped = 0
        secondLastTileTapped = 0
        turn = false
        numberOfMatched = 0
        score = 0
        tileArray.removeAll()
        var counter: Int = 0
        for _ in 1...(numberOfTile / 2) {
            tileArray.append(TileData(name: imageNameList[counter], id: counter))
            tileArray.append(TileData(name: imageNameList[counter], id: counter))
            if (counter == imageNameList.count-1){
                counter = 1
            }else {
                counter += 1
            }
        }
        tileArray.shuffle()
    }
    
    var description: String {
        var printableString: String = ""
        for index in 0...tileArray.count-1 {
            printableString += (" | " + (String)(tileArray[index].imageIdentifier) + " : " + (tileArray[index].tileImage))
        }
        return printableString
    }
    
    func pushTileIndex(index: Int) {
        secondLastTileTapped = lastTileTapped
        lastTileTapped = index
    }
    func getIdentifier(index: Int)->Int{
        return tileArray[index-1].imageIdentifier
    }
    
    func getImage(index: Int)-> String {
        return tileArray[index].tileImage
    }
    
    
    
}


