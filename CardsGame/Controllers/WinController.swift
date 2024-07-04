//
//  ViewController.swift
//  CardsGame
//
//  Created by Vadim Kandaurov on 30/06/2024.
//

import UIKit

class WinController: UIViewController  {

    @IBOutlet weak var win_LBL_winnerName: UILabel! // The name of the winner
    @IBOutlet weak var win_LBL_winnerScore: UILabel! // The score of the winner
    @IBOutlet weak var win_BTN_menuBtn: UIButton! // The main menu button
    
    override func viewDidLoad() {
        print("Win view loaded")
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        print("Setting ui...")
        let winnerName = Tools.getFromUserDefaults(key: Tools.winnerName, as: String.self)!
        let winnerScore = Tools.getFromUserDefaults(key: Tools.winnerScore, as: Int.self)!
//        let winnerName = "Player won!" // Mock
//        let winnerScore = "Score: 60" // Mock
        print("Winner: \(winnerName) Score: \(winnerScore)")
        win_LBL_winnerName.text = "\(winnerName) wins!"
        win_LBL_winnerScore.text = "Score: \(winnerScore)"
    }
    /**
     Button onClick callback
     */
    @IBAction func goToMainMenu(_ sender: Any) {
        print("menuButtonClick")
        Tools.showToast(message: "Starting new game...", time: 3, controller: self)
        Tools.waitForCallback(seconds: 3){
            self.moveToMainMenu()
        }
    }
    
    /**
     This function will go to the main menu and clear the shared prefferences
     */
    func moveToMainMenu(){
        print("Going to main menu...")
        Tools.resetUserDefaults() // Reset the shared prefferences
        Tools.moveToScene(scene: Tools.winToStartTransition, controller: self) // Move to start scene
    }
}
