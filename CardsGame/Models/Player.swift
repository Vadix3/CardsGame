//
//  Player.swift
//  CardsGame
//
//  Created by Vadim Kandaurov on 04/07/2024.
//

import Foundation

class Player {
    private var name: String // The name of the card and power
    private var side: String // The image
    private var score:Int // The hp of the player
    private var deck: [GwentCard] = [] // Players deck
    private var currentCard : GwentCard // The currentCard
    
    init() {
        self.name = ""
        self.side = ""
        self.score = 0
        self.deck = []
        self.currentCard = GwentCard(name: "", fileName: "", power: 0)
    }
    
    
    func setName(name:String){
        self.name=name
    }
    func getName()->String{
        return self.name
    }
    
    func setSide(side:String)
    {
        self.side=side
    }
    
    func setDeck(deck:[GwentCard]){
        self.deck=deck
    }
    
    func getDeck()->[GwentCard]{
        return self.deck
    }
    
    func getDeckCount()->Int{
        return self.deck.count
    }
    /**
     This function will increase the score
     */
    func addScore(score:Int){
        print("Player: \(self.name) adding score: \(score)")
        self.score+=score
    }
    
    func getScore()->Int{
        return self.score
    }
}
