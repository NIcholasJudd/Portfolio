//
//  TileView.swift
//  Assignment 1
//
//  Created by Nicholas Judd on 29/03/2016.
//  Copyright © 2016 Nicholas Judd. All rights reserved.
//
import Foundation
import UIKit
protocol TileViewDelegate: class{
    func didSelectTile(tileView: TileView)
}
class TileView: UIView {
    
    var tileImage: UIImage?
    var tileImageView: UIImageView
    weak var delegate : TileViewDelegate?
    var tileIndex: Int?
    var tileIdentifier: Int?
    var checked: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        tileImageView = UIImageView()
        super.init(coder: aDecoder)
        tileImageView.translatesAutoresizingMaskIntoConstraints = false
        tileImageView.contentMode = .ScaleToFill
        tileIndex = self.tag
        self.addSubview(tileImageView)
        
        
        //Position and size the innerView with these autolayout constraints:
        let bottom = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: tileImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        let trailing = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: tileImageView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let top = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: tileImageView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:0)
        
        let leading = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: tileImageView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        //Add the constraints:
        self.addConstraints([bottom, trailing, top, leading])
    }
    
    
    func revealTile(tileView: TileView) {
        flipTileToImage(tileView)
    }
    func coverTile(tileView: TileView) {
        flipTileToCoverImage(tileView)
        
        //fadeOut(tileView)
        
    }
    
    func hideTiles(tileView: TileView){
        hideTile(tileView)
    }
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.checked == false{
            revealTile(self)
            self.setDefault(self)
        }else{
            return
        }
        
    }
    
    func setDefault(tileView: TileView){
        tileView.tileImageView.image = UIImage(named: "question")
    }
    
    func flipTileToImage(tileView: TileView){
        UIView.animateWithDuration(0.5, animations: {
            tileView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/2, 0.0, 1.0, 0.0)
            } ,completion:{ (false) in
                tileView.tileImageView.image = self.tileImage
                UIView.animateWithDuration(0.5, animations: {
                    tileView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/2, 0.0, 0.0, 0.0)
                    }, completion: { (false) in
                            self.delegate!.didSelectTile(self)
                })
            })
        }
    
    func flipTileToCoverImage(tileView: TileView){
        UIView.animateWithDuration(0.5, animations: {
            tileView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/2, 0.0, 1.0, 0.0)
            } ,completion:{ (true) in
                self.setDefault(tileView)
                UIView.animateWithDuration(0.5, animations: {
                    tileView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/2, 0.0, 0.0, 0.0)
                })
        })
    }
    
    func hideTile(tileView: TileView){
        
        UIView.animateWithDuration(0.5, animations: {
            tileView.alpha = 0.0
            
        })
    }
}



