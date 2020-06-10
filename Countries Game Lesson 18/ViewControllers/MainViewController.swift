//
//  MainViewController.swift
//  CountriesGame
//
//  Created by Itzik Bar-Noy on 25/05/2020.
//  Copyright © 2020 Itzik Bar-Noy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var gameButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var sliderLevel: UISlider!
    @IBOutlet weak var stepperLevel: UIStepper!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    //MARK: Properties
    private var countries = [Country]()
    var level:Level = .medium {
        didSet{
            var color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            var levelDescription = ""
            switch level {
            case .easy:
                color = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
                levelDescription = "Easy"
            case.medium:
                color = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
                levelDescription = "Medium"
            case.hard:
                color = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
                levelDescription = "Hard"
            }
            levelLabel.textColor = color
            levelLabel.text = levelDescription
        }
    }
    let pereferces = UserDefaults.standard
    let score = "score"
    let userLevelPref = "Level"
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCountries()
        configurePage()
    }
    
    //MARK: Actions
    
    @IBAction func levelSliderChanged(_ sender: UISlider) {
        let value = sender.value
        if value < 0.25{
            sender.setValue(0.0, animated: true)
            stepperLevel.value = 0.0
            level = .easy
        }
        else if value > 0.25 && value < 0.75 {
            sender.setValue(0.5, animated: true)
            stepperLevel.value = 1.0
            level = .medium
        }else{
            sender.setValue(1, animated: true)
            stepperLevel.value = 2.0
            level = .hard
        }
        
        saveUserLevelInDefaults()
        
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let value = sender.value;
        
        switch value {
        case 0.0:
            sliderLevel.setValue(0.0, animated: true)
            level = .easy
        case 1.0:
            sliderLevel.setValue(0.5, animated: true)
            level = .medium
        default:
            sliderLevel.setValue(1.0, animated: true)
            level = .hard
        }
        saveUserLevelInDefaults()
    }
    
    
    
    //MARK: Functions
    
    private func configurePage() {
        gameButtons.forEach {
            $0.layer.cornerRadius = 10
        }
        loadUserScoreData()
        loadUserLevelFromDefaults()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FlagsViewController.identifier{
            if let vc = segue.destination as? FlagsViewController{
                vc.countries = self.countries
                vc.level = level
                vc.userScoreDelgete = self
            }
        }
        
        if segue.identifier == CapitalCitiesViewController.identifier {
            if let vc = segue.destination as? CapitalCitiesViewController {
                vc.countries = self.countries
                vc.level = level
                vc.userScoreDelegete = self
            }
        }
    }
}

//MARK: Handle data from json
extension MainViewController{
    private func loadCountries() {
        let jsonParser = JsonParser()
        jsonParser.parseCountriesJson { (countries) in
            self.countries = countries
        }
        let country1 = "Saint Helena, Ascension and Tristan daCunha"
        let country2 = "Brazil"
        let country3 = "Nepal"
        let country4 = "Qatar"
        let country5 = "Niue"
        self.countries.removeAll(where: {
            $0.name == country1 ||
                $0.name == country2 ||
                $0.name == country3 ||
                $0.name == country4 ||
                $0.name == country5
        })
    }
}

//MARK userScoreDelgate

extension MainViewController: UserScoreDelgete{
    func scoreChange(with score: Int) {
        
        let scoreKey = "score"
        var newScore = score
        let oldScore = pereferces.object(forKey: scoreKey)
        if oldScore != nil{
            newScore += oldScore as! Int
        }
        self.pereferces.set(newScore, forKey: scoreKey)
        setLabelScoreAndColor(withScore: newScore)
    }
    
    
}

//Mark: Save and Load userData from userDefualts
extension MainViewController{
    private func saveUserLevelInDefaults(){
        pereferces.set(level.rawValue, forKey: userLevelPref)
    }
    
    private func loadUserLevelFromDefaults(){
        let value = pereferces.object(forKey: userLevelPref) as? Double
        if value != nil {
            var setValueforSlider:Float = 0
            var setValueForStepper: Double = 0
            var colorofLevel = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            var levelDescription = ""
            switch value {
            case 16:
                level = .easy
                setValueforSlider = 0
                setValueForStepper = 0
                colorofLevel = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
                levelDescription = "Easy"
            case 12:
                level = .medium
                setValueforSlider = 0.5
                setValueForStepper = 1
                colorofLevel = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
                levelDescription = "Medium"
            default:
                level = .hard
                setValueforSlider = 1
                setValueForStepper = 2
                colorofLevel = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
                levelDescription = "Hard"
            }
            
            sliderLevel.setValue(setValueforSlider, animated: false)
            stepperLevel.value = setValueForStepper
            levelLabel.textColor = colorofLevel
            levelLabel.text = levelDescription
            
        }
    }
    private func loadUserScoreData(){
        let actualScore = (pereferces.object(forKey: score) ?? 0) as! Int
        setLabelScoreAndColor(withScore: actualScore)
    }
    
    private func setLabelScoreAndColor(withScore score: Int){
        var color = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        if score < 0 {
            color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        scoreLabel.textColor = color
        scoreLabel.text = "Your Score: \(score)"
    }
    
}
