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
    var currentLocationLat:Double = 100.0 // Location latitude variable (-90,90)
    var currentLocationLon :Double = 200.0 // Location longitude variable (-180,180)
    var playerName = "" // Variable to store the players name
    var playerSide = "" // Variable to save the users side East or West
    
    override func viewDidLoad() {
        print("Main view loaded")
        super.viewDidLoad()
        //        Tools.resetUserDefaults() // TODO: Uncomment if you want to clear the UserDefaults for testing
        
        fetchSavedData(database:Tools.USER_DEFAULTS) // Check if we know the current user
        // Detect taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    /**
     This function will fetch the saved data depending where from. Could be from the cloud or from the shared prefferences
     */
    func fetchSavedData(database:String){
        print("fetchingSavedData from: \(database)")
        
        if(database==Tools.USER_DEFAULTS){ // Fetch data from user default
            if let name = fetchDataFromUserDefaults() {
                playerName = name
                setUIForKnownPlayer()
            } else {
                setUIForNewPlayer()
            }
        }
        if(database==Tools.CLOUD){
            fetchDataFromCloud()
        }
    }
    
    
    /**
     This function will update the UI for a known player scenario
     */
    func setUIForKnownPlayer(){
        print("setUIForKnownPlayer...")
        // Display the stored name
        launch_LBL_title.text = "Welcome back, \(playerName)!"
        launch_LBL_title.isHidden = false
        launch_TXT_name.isHidden = true
        launch_TXT_name.isHidden = true
        launch_BTN_start.isHidden=true
        LocationController.shared.stopUpdatingLocation()
        
        // Wait for 5 seconds before moving to the next scene so user can understand what's going on
        Tools.waitForCallback(seconds: 5) {
            Tools.moveToScene(scene: Tools.startToGameTransition, controller: self)
        }
    }
    
    /**
     This function will update the UI for a known player scenario
     */
    func setUIForNewPlayer(){
        print("setUIForNewPlayer...")
        // Show the text field and button for name input
        launch_LBL_title.isHidden = false
        launch_TXT_name.isHidden = false
        launch_BTN_start.isHidden = false
        // Handle location
        LocationController.shared.delegate = self
        LocationController.shared.requestLocationAccess()
    }
    
    
    
    /**
     This function will fetch the data from the shared prefferences
     */
    func fetchDataFromUserDefaults()->String?{
        print("fetchDataFromUserDefaults...")
        if let name = UserDefaults.standard.string(forKey: Tools.userNameKey) {
            print("Player is known: \(name)!")
            return name
        } else {
            print("New Player!")
            return nil
        }
    }
    
    /**
     This function will fetch the data from the cloud
     */
    func fetchDataFromCloud(){
        print("fetchDataFromCloud...")
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
        print("Clicked start")
        validateInput()
    }
    
    /**
     This function validates the various inputs in the launch page
     */
    func validateInput(){
        print("Validating input...")
        if(validateLocation()&&validateName()){
            startGame()
        }
    }
    /**
     This function will validate the location services
     */
    func validateLocation()->Bool{
        print("Validating location...")
        // atm will validate that the location exists
        
        if (currentLocationLat==100.0) &&  (currentLocationLon == 200.0){
            print("No location")
            Tools.showToast(message: "Please enable your location", time: 3, controller: self)
            return false
        } else {
            print("Player location: \(playerName)")
            return true
        }
    }
    
    /**
     This function will validate the location services
     */
    func validateName()->Bool{
        print("Validating name...")
        if let playerName = launch_TXT_name.text, !playerName.isEmpty {
            print("Player name: \(playerName)")
            return true
        } else {
            print("Player name is nil or empty")
            Tools.showToast(message: "Please enter your name", time: 3, controller: self)
            return false
        }
    }
    
    /**
     This function will start the game
     */
    func startGame(){
        print("Starting game...")
        playerName = launch_TXT_name.text!
        print("Selected name: \(playerName)")
        // Stop updating location
        LocationController.shared.stopUpdatingLocation()
        print("Stopped updating location. Last known location: \(currentLocationLat), \(currentLocationLon)")
        decideUsersSide()
        saveUserData()
        // Wait for 3 seconds before moving to the next scene so user can understand what's going on
        Tools.waitForCallback(seconds: 3) {
            Tools.moveToScene(scene: Tools.startToGameTransition, controller: self)
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
