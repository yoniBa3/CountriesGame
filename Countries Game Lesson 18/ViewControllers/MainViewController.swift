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
    
    //MARK: Properties
    private var countries = [Country]()
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCountries()
        configurePage()
        
        let pereferces = UserDefaults.standard
        let score = "score"
        
        scoreLabel.text = "Your Score:  \(pereferces.object(forKey: score) ?? "0")"
        
        
    }
    
    private func configurePage() {
        gameButtons.forEach {
            $0.layer.cornerRadius = 10
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FlagsViewController.identifier{
            if let vc = segue.destination as? FlagsViewController{
                vc.countries = self.countries
                vc.userScoreDelgete = self
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
        self.countries.removeAll(where: {
            $0.name == country1 ||
            $0.name == country2 ||
            $0.name == country3 ||
            $0.name == country4
            })
        
        

    }
}

//MARK userScoreDelgate

extension MainViewController: UserScoreDelgete{
    func scoreChange(with score: Int) {
        
        
        let perfernces = UserDefaults.standard
        let scoreKey = "score"
        var newScore = score
        let oldScore = perfernces.object(forKey: scoreKey)
        if oldScore != nil{
            newScore += oldScore as! Int
        }
        perfernces.set(newScore, forKey: scoreKey)
        scoreLabel.text = "Your score: \(newScore)"
    }
    
    
}
