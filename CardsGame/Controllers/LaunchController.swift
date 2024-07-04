//
//  ViewController.swift
//  CardsGame
//
//  Created by Vadim Kandaurov on 30/06/2024.
//

import UIKit
import CoreLocation

class LaunchController: UIViewController , LocationControllerDelegate {
    @IBOutlet weak var launch_LBL_title: UILabel!
    @IBOutlet weak var launch_TXT_name: UITextField!
    @IBOutlet weak var launch_BTN_start: UIButton!
    
    let middleLon = 34.817549168324334 // The middle location for the test
    var currentLocationLat:Double = 0.0 // Location latitude variable
    var currentLocationLon :Double = 0.0 // Location longitude variable
    var playerName = "" // Variable to store the players name
    var playerSide = "" // Variable to save the users side East or West
    
    override func viewDidLoad() {
        print("Main view loaded")
        super.viewDidLoad()
//        Tools.resetUserDefaults() // TODO: Uncomment if you want to clear the UserDefaults for testing
        checkIfUserIsKnown() // Check if we know the current user
        // Detect taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    /**
     This function will check if the user is already known to use and if so just display his name
     */
    func checkIfUserIsKnown(){
        // Check if the user's name is already stored

        if let name = UserDefaults.standard.string(forKey: Tools.userNameKey) {
            print("Player is known: \(name)!")
            // Display the stored name
            launch_LBL_title.text = "Welcome back, \(name)!"
            launch_LBL_title.isHidden = false
            launch_TXT_name.isHidden = true
            launch_TXT_name.isHidden = true
            launch_BTN_start.isHidden=true
            LocationController.shared.stopUpdatingLocation()
            
            // Wait for 5 seconds before moving to the next scene so user can understand what's going on
            Tools.waitForCallback(seconds: 5) {
                self.moveToNextScene()
            }
        } else {
            print("New Player!")
            // Show the text field and button for name input
            launch_LBL_title.isHidden = false
            launch_TXT_name.isHidden = false
            launch_BTN_start.isHidden = false
            // Handle location
            LocationController.shared.delegate = self
            LocationController.shared.requestLocationAccess()
        }
    }
    
    /**
     This function will dismiss the keyboard
     */
    @objc func dismissKeyboard() {
        print("Closing keyboard")
        view.endEditing(true)
    }
    
    /**
     This function will save the name and will invoke the
     */
    @IBAction func onStartClick(_ sender: Any) {
        
        // TODO: Validate name input
        // TODO: Validate location existance
        
        print("Clicked start")
        playerName = launch_TXT_name.text!
        print("Selected name: \(playerName)")
        
        // Stop updating location
        LocationController.shared.stopUpdatingLocation()
        print("Stopped updating location. Last known location: \(currentLocationLat), \(currentLocationLon)")
        
        decideUsersSide()
        saveUserData()

        
        // Wait for 3 seconds before moving to the next scene so user can understand what's going on
        Tools.waitForCallback(seconds: 3) {
            self.moveToNextScene()
        }
    }
    
    /**
     This function will save any relevant data to the UserDefauls
     */
    func saveUserData(){
        print("Saving user data...")
        // Save the user name to the UserDefaults
        Tools.saveToUserDefaults(key: Tools.userNameKey, value: self.playerName)
        Tools.saveToUserDefaults(key: Tools.sideKey, value: self.playerSide)
    }
    /**
     This is the move to next scene callback function
     */
    func moveToNextScene(){
        print("Moving to next scene")
        self.performSegue(withIdentifier: "showNextScene", sender: self)
    }
    
    func decideUsersSide(){
        print("decideUsersSide")
        // We need to understand if we are east or west of the given longitude
        print("Selected longitude: \(currentLocationLon)")
        self.playerSide = currentLocationLon < middleLon ? "East" : "West" // Get the position
        print("You will be playing: \(self.playerSide)")
        launch_LBL_title.text = "\(playerName), you will be playing: \(self.playerSide)!"
        launch_TXT_name.isHidden = true // Hide the name textbox
        launch_BTN_start.isHidden = true // Hide the start button
    }
    
    
    
    
    /** ============================= Location functions ============================= */
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        currentLocationLat = latitude
        currentLocationLon = longitude
        print("Location: \(currentLocationLat), \(currentLocationLon)")
    }
    
    func didFailWithError(error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func didChangeAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            LocationController.shared.startUpdatingLocation()
        case .denied, .restricted:
            // Handle the case where the user denied location access
            print("Location access denied or restricted.")
        case .notDetermined:
            LocationController.shared.requestLocationAccess()
        @unknown default:
            break
        }
    }
    
}
