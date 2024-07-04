//
//  Tools.swift
//  CardsGame
//  This is a tools class
//  Created by Vadim Kandaurov on 04/07/2024.
//

import Foundation
import UIKit

class Tools {
    
    static let userNameKey :String = "userName"
    static let sideKey :String = "userSide"
    static let winnerName :String = "winnerName"
    static let winnerScore :String = "winnerScore"
    static let startToGameTransition = "startToGame"
    static let gameToWinTransition = "gameToWin"
    static let winToStartTransition = "winToStart"
    static let USER_DEFAULTS = "userDefaults"
    static let CLOUD = "cloud"

    private init() { }
    
    /**
     This is the move to next scene callback function
     */
    static func moveToScene(scene:String,controller:UIViewController){
        print("Moving to next scene")
        controller.performSegue(withIdentifier: scene, sender: controller)
    }
    
    /**
     This function will show a toast with a message
     */
    static func showToast(message: String, time: Int, controller: UIViewController) {
        print("Showing toast with message: \(message)")
        Toast.show(message: message, controller: controller)
    }
    
    /**
     This function will save the key value pair to the UserDefaults
     */
    static func saveToUserDefaults<T>(key: String, value: T) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /**
     This function will retrieve a value from the UserDefaults
     */
    static func getFromUserDefaults<T>(key: String, as type: T.Type) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
    
    /**
     This function will hold the current view for the given amount of seconds
     */
    static func waitForCallback(seconds: Int, callback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            callback()
        }
    }
    
    /**
     This function will reset all UserDefaults
     */
    static func resetUserDefaults() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
}
