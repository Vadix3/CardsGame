import UIKit



class GameController: UIViewController {
        
    @IBOutlet weak var game_IMG_pic1: UIImageView! // Left card image
    @IBOutlet weak var game_LBL_title1: UILabel! // Left card title
    @IBOutlet weak var game_IMG_pic2: UIImageView! // Right card image
    @IBOutlet weak var game_LBL_title2: UILabel! // Right card title
    
    // Variables
    private var leftCard: GwentUICard! // Left card class
    private var rightCard: GwentUICard! // Right card class
    private var gwentCards: [GwentCard] = [] // The plain cards
    private var currentIndex = 0
    private var playerSide: String = "" // East or west depending on previous controller
    private var playerName: String = "" // The name of the player
     
    
    private var leftPlayer = Player()
    private var rightPlayer = Player()
    
    // Constants
    private let NUM_OF_TURNS = 5 // This is the number of turns
    private let HIDDEN_CARDS_DELAY = 1 // This is the delay we wait for the hidden cards (TODO: 5 for the task)
    private let SHOWN_CARDS_DELAY = 1 // This is the delay we wait for the shown cards (TODO: 3 for the tesk)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded...\n")
        // Ensure labels can handle multiline text
        game_LBL_title1.numberOfLines = 0
        game_LBL_title1.lineBreakMode = .byWordWrapping
        game_LBL_title2.numberOfLines = 0
        game_LBL_title2.lineBreakMode = .byWordWrapping
        self.initGame()
    }
    
    /**
     This function will initialize the game
     */
    func initGame(){
        print("initGame...")

        // Hide the labels at start
        self.hideLabels()
        
        // Load the cards from JSON
        loadGwentCards()
        print("Gwent cards: \(gwentCards)\n")
        
        let sideKey = Tools.sideKey
        let userNameKey = Tools.userNameKey
        
        print("Side: \(sideKey)")
        print("Key: \(userNameKey)")
        // Retrieve values from UserDefaults
        let playerSide = Tools.getFromUserDefaults(key: Tools.sideKey, as: String.self)
        let playerName = Tools.getFromUserDefaults(key: Tools.userNameKey, as: String.self)
        print("Player side: \(playerSide!)")
        print("Player name: \(playerName!)")
        
        if (playerSide=="East"){
            print("Player is on the left, AI on the right")
            leftPlayer.setName(name: "Player")
            rightPlayer.setName(name: "AI")
            
        }else{
            print("Player is on the right, AI is on the left")
            rightPlayer.setName(name: "Player")
            leftPlayer.setName(name: "AI")
        }
        
        distributeDeck()
        // Show welcome toast with string
        Tools.showToast(message: "Good luck \(playerName!)!", time: 3, controller: self)
        
        hideCards()
    }
    
    /**
     This function will hide the cards for
     */
    func hideCards(){
        print("Hiding cards...")
        self.hideLabels()
        // Initialize GwentUICard objects
        let leftCardDefaultImage = "green_runestone" // West player will have the green deck
        let rightCardDefaultImage = "red_runestone" // East player will have the red deck
        leftCard = GwentUICard(label: game_LBL_title1, img: game_IMG_pic1,defaultImg: leftCardDefaultImage)
        rightCard = GwentUICard(label: game_LBL_title2, img: game_IMG_pic2,defaultImg:rightCardDefaultImage)
        Tools.waitForCallback(seconds: HIDDEN_CARDS_DELAY){
            self.next()
        }
    }
    
    /**
     This function will show the labels of the card names
     */
    func showLabels(){
        print("showLabels...")
        game_LBL_title1.alpha = 1
        game_LBL_title2.alpha = 1
    }
    
    /**
     This function will show the labels of the card names
     */
    func hideLabels(){
        print("hideLabels...")
        game_LBL_title1.alpha = 0
        game_LBL_title2.alpha = 0
    }
    
    /**
     This function will perform the next action
     */
    func next() {
        currentIndex += 1
        print("Next turn, current index: \(currentIndex)\n")
        if currentIndex > NUM_OF_TURNS {
            // TODO: ADD WIN LOGIC HERE
            currentIndex = 0
            finishGame()
        }else{ // Play another turn
            handleTurn(index: currentIndex)
            self.showLabels()
            showCard(at: currentIndex)
            Tools.waitForCallback(seconds: SHOWN_CARDS_DELAY){
                self.hideCards()
            }
        }
    }
    
    /**
     This function will handle the current turn
     */
    func handleTurn(index: Int){
        Tools.showToast(message: "Handle turn: \(index)", time: 2, controller: self)
        let leftCard = leftPlayer.getDeck()[index]
        let rightCard = rightPlayer.getDeck()[index]
        leftPlayer.addScore(score: leftCard.power)
        rightPlayer.addScore(score: rightCard.power)
    }
    
    
    /**
     This function will handle the end of the game
     */
    func finishGame(){
        print("Finishing game...\n")
        var message = ""
        if(leftPlayer.getScore()>=rightPlayer.getScore()){
            print("Left player wins!")
            message = "\(leftPlayer.getName()) wins with \(leftPlayer.getScore()) points!"
        }else{
            print("Right player wins!")
            message = "\(rightPlayer.getName()) wins with \(rightPlayer.getScore()) points!"
        }
        Tools.showToast(message: message, time: 10, controller: self)
    }
    
    /**
     This function will update the UI to display the card of each player
     */
    func showCard(at index: Int) {
        print("Showing cards for index: \(index)...\n")
        let card1 = leftPlayer.getDeck()[index]
        leftCard.img.image = UIImage(named: card1.fileName)
        leftCard.label.text = "\(card1.name) - Power: \(card1.power)"
        
        let card2 = rightPlayer.getDeck()[index]
        rightCard.img.image = UIImage(named: card2.fileName)
        rightCard.label.text = "\(card2.name) - Power: \(card2.power)"
    }
    
    /**
     This function will distribute the deck evenly for the 2 players
     */
    func distributeDeck() {
        print("Distributing deck...\n")
        let shuffledDeck = gwentCards.shuffled()
        let half = shuffledDeck.count / 2
        leftPlayer.setDeck(deck: Array(shuffledDeck[..<half]))
        rightPlayer.setDeck(deck: Array(shuffledDeck[half...]))
    }
    
    /**
     This function will load the gwent cards from the json file
     */
    func loadGwentCards() {
        if let url = Bundle.main.url(forResource: "cards", withExtension: "json") {
            print("Path to cards.json: \(url.path)\n")
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                gwentCards = try decoder.decode([GwentCard].self, from: data)
                print("Gwent cards from import: \(gwentCards)\n")
            } catch {
                print("Error loading cards.json: \(error)\n")
            }
        } else {
            print("PROBLEM GETTING CARDS: File not found in bundle\n")
        }
    }
}
