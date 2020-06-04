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
    @IBOutlet weak var yourScoreLabel: UILabel!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet var citiesNameButton: [UIButton]!
    
    @IBOutlet weak var timerStackView: UIStackView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var hintbutton: UIButton!
    
    @IBOutlet weak var subRegionLabel: UILabel!
    
    // MARK: Properties
    var userScoreDelegete: UserScoreDelgete!
    var countries = [Country]()
    
    private var userScore = 0 {
        didSet{
            
        }
    }
    private var randomNumber = 0
    private var correctAnswer = ""
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: Actions
    @IBAction func xMarkButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startGameTapped(_ sender: UIButton) {
    }
    
    @IBAction func citiesNamesTapped(_ sender: UIButton) {
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
    }
    
    
    // MARK: Functions
    
    func configurePage() {
        isComponnetsEnable(isEnable: false)
        
        configureButtonsCornerRadius()
    }
    
    private func configureButtonsCornerRadius() {
        
        startGameButton.layer.cornerRadius = 10
        citiesNameButton.forEach {
            $0.layer.cornerRadius = 10
        }
        hintbutton.layer.cornerRadius = 10
    }
    
    private func isComponnetsEnable(isEnable: Bool){
        citiesNameButton.forEach {
            $0.isEnabled = isEnable
        }
        hintbutton.isEnabled = isEnable
    }
    
    private func resetGame() {
        randomNumber = Int.random(in: 0..<countries.count)
        correctAnswer = countries[randomNumber].capital
        var countriesNames = [countries[randomNumber].name]
        
    }
    
    
    
    
}
