//
//  CapitalCitiesViewController.swift
//  CountriesGame
//
//  Created by Itzik Bar-Noy on 25/05/2020.
//  Copyright © 2020 Itzik Bar-Noy. All rights reserved.
//

import UIKit



class CapitalCitiesViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var userScoreLabel: UILabel!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet var citiesNameButton: [UIButton]!
    
    @IBOutlet weak var timerStackView: UIStackView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var hintbutton: UIButton!
    
    @IBOutlet weak var subRegionLabel: UILabel!
    
    // MARK: Properties
    public static let identifier = "CapitalCityGame"
    
    var userScoreDelegete: UserScoreDelgete!
    var countries = [Country]()
    var maximumTimeToAnswer: Double = 0
    private var userScore = 0 {
        didSet{
            userScoreLabel.text = "Your Score is: \(userScore)"
        }
    }
    private var randomNumber = 0
    private var correctAnswer = ""
    private var timer:Timer!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userScoreDelegete.scoreChange(with: userScore)
    }
    
    // MARK: Actions
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
        }
        isComponnetsEnable(isEnable: false)
        timer.invalidate()
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (_) in
            self.resetGame()
        }
        
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
    }
    
    
    // MARK: Functions
    
    func configurePage() {
        isComponnetsEnable(isEnable: false)
        
        configureButtonsCornerRadiusAndHideLabels()
    }
    
    private func configureButtonsCornerRadiusAndHideLabels() {
        
        startGameButton.layer.cornerRadius = 10
        citiesNameButton.forEach {
            $0.layer.cornerRadius = 10
        }
        hintbutton.layer.cornerRadius = 10
        countryNameLabel.isHidden = true
        subRegionLabel.isHidden = true
        
    }
    
    private func isComponnetsEnable(isEnable: Bool){
        citiesNameButton.forEach {
            $0.isEnabled = isEnable
        }
        hintbutton.isEnabled = isEnable
    }
    
    private func resetGame() {
        subRegionLabel.isHidden = true
        randomNumber = Int.random(in: 0..<countries.count)
        correctAnswer = countries[randomNumber].capital
        if correctAnswer == ""{
            resetGame()
        }
        if timer != nil {
            timer.invalidate()
        }
        isComponnetsEnable(isEnable: true)
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
            if !citiesNames.contains(cityName) || cityName == ""{
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
            
            if seconds == Int(self.maximumTimeToAnswer){
                self.timer.invalidate()
            }
            
            if Double(seconds) > self.maximumTimeToAnswer * 0.66{
                self.timerLabel.textColor = .red
            }
        })
    }
    
    
    
    
}
