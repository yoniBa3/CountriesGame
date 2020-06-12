//
//  CapitalCitiesViewController.swift
//  CountriesGame
//
//  Created by Yoni on 01/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit



class CapitalCitiesViewController: UIViewController {

    // MARK: -Outlets

    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet var citiesNameButton: [UIButton]!
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var hintbutton: UIButton!
    @IBOutlet weak var maxLengthLabel: UILabel!
    
    // MARK: -Properties
    public static let identifier = "CapitalCityGame"
    
    var userScoreDelegete: UserScoreDelgete!
    var countries = [Country]()
    var level:Level!
    private var userScore = 0 {
        didSet{
            //userScoreLabel.text = "Your Score is: \(userScore)"
            let message = "Your Score is: \(userScore)"
            var color = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            if userScore < 0{
                color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            userScoreLabel.text = message
            userScoreLabel.textColor = color
        }
    }
    private var randomNumber = 0
    private var correctAnswer = ""
    private var timer:Timer!
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userScoreDelegete.scoreChange(with: userScore)
    }
    

    // MARK: -Actions
    @IBAction func xMarkButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startGameTapped(_ sender: UIButton) {
        isComponnetsEnable(isEnable: true)
        resetGame()
    }
    
    @IBAction func citiesNamesTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == correctAnswer {
            sender.backgroundColor = .green
            userScore += 1
        }else{
            sender.backgroundColor = .red
            if level == Level.hard{
                userScore -= 1
            }
        }
        isComponnetsEnable(isEnable: false)
        timer.invalidate()
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (_) in
            self.resetGame()
        }
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.75) {
            self.showHint()
        }
        sender.isEnabled = false
    }
    

    // MARK: -Functions
    
    func configurePage() {
        isComponnetsEnable(isEnable: false)
        configureButtonsCornerRadiusAndHideLabels()
    }
    
    private func configureButtonsCornerRadiusAndHideLabels() {
        startGameButton.layer.cornerRadius = 10
        citiesNameButton.forEach {
            $0.layer.cornerRadius = 10
        }
        hintbutton.layer.cornerRadius = hintbutton.bounds.size.width / 2
        countryNameLabel.isHidden = true
        maxLengthLabel.isHidden = true
    }
    
    private func isComponnetsEnable(isEnable: Bool){
        citiesNameButton.forEach {
            $0.isEnabled = isEnable
        }
        hintbutton.isEnabled = isEnable
    }
    
    private func resetGame() {
        isComponnetsEnable(isEnable: true)
        hintbutton.isEnabled = level != Level.hard
        maxLengthLabel.isHidden = true
        randomNumber = Int.random(in: 0..<countries.count)
        correctAnswer = countries[randomNumber].capital
        if correctAnswer == ""{
            resetGame()
        }
        if timer != nil {
            timer.invalidate()
        }
        startTimer()
        countryNameLabel.text = countries[randomNumber].name
        countryNameLabel.isHidden = false
        countryNameLabel.text = countries[randomNumber].name
        setCpaitalCitiesNamesButtons()
        
    }
    
    private func setCpaitalCitiesNamesButtons(){
        var citiesNames = [correctAnswer]
        while citiesNames.count < citiesNameButton.count {
            let random = Int.random(in: 0..<countries.count)
            let cityName = countries[random].capital
            if !citiesNames.contains(cityName) && cityName != ""{
                citiesNames.append(cityName)
            }
        }
        citiesNames.shuffle()
        for (index ,button) in citiesNameButton.enumerated() {
            button.setTitle(citiesNames[index], for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.backgroundColor = .white
        }
    }
    
    private func showHint(){
        var amountOfExtraLetters = 0
        switch level {
        case .easy:
            amountOfExtraLetters = 1
        default:
            amountOfExtraLetters = 2
        }
        let message = "The maximum length is: "
        maxLengthLabel.text = message + String(correctAnswer.count + amountOfExtraLetters)
        maxLengthLabel.isHidden = false
    }

    private func startTimer() {
        timerLabel.textColor = .white
        var seconds = 0
        var hundredth = 0
        var secondMessage = ""
        var hundredtMessage = ""
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 100, repeats: true, block: { _ in
            if hundredth == 99 {
                seconds += 1
                hundredth = 0
            }else{
                hundredth += 1
            }
            secondMessage = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            hundredtMessage = hundredth < 10 ? "0\(hundredth)" : "\(hundredth)"
            self.timerLabel.text = secondMessage + ":" + hundredtMessage
            if seconds == Int(self.level.rawValue){
                self.timer.invalidate()
            }
            if Double(seconds) > self.level.rawValue * 0.66{
                self.timerLabel.textColor = .red
            }
        })
    }

}
