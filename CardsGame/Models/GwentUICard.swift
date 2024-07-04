//
//  GwentUICard.swift
//  CardsGame
//
//  Created by Vadim Kandaurov on 04/07/2024.
//
import UIKit
/**
 This class represents the UI element of the card
 */
class GwentUICard {
    let label: UILabel // The name of the card and power
    let img: UIImageView // The image
    let defaultImgName : String // The name of the default card (back side of it)
    
    init(label: UILabel, img: UIImageView,defaultImg:String) {
        self.label = label
        self.img = img
        self.defaultImgName = defaultImg
        self.flipCard()
    }
    
    /**
     This function will flip the card to look like it's the backside of the card
     */
    func flipCard(){
        print("Flipping card...")
        self.img.image = UIImage(named: self.defaultImgName)
    }
}
