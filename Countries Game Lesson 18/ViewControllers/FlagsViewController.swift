//
//  FlagsViewController.swift
//  CountriesGame
//
//  Created by Itzik Bar-Noy on 25/05/2020.
//  Copyright © 2020 Itzik Bar-Noy. All rights reserved.
//

import UIKit

protocol UserScoreDelgete {
    func scoreChange(with score:Int)
}

class FlagsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var flagCustomImageView: CustomImageView!
    @IBOutlet var countriesNamesButtons: [UIButton]!
    
    @IBOutlet weak var timerStackView: UIStackView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var useScoreLabel: UILabel!
    
    // MARK: Activity Indicator
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: Properties
    var userScoreDelgete:UserScoreDelgete!
    public static var identifier = "FlagsGame"
    
    var randomIndex = 0
    var countries = [Country]()
    var level: Level!
    private var userScore = 0 {
        didSet{
            let message = "Your Score is: \(userScore)"
            var color = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            if userScore < 0{
                color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            useScoreLabel.text = message
            useScoreLabel.textColor = color
            
        }
    }
    
    private var correctAnswerCountry: String = ""
    private let radiusSize: CGFloat = 80
    private let shapeLayer = CAShapeLayer()
    private var timer: Timer!
    
    private var percentage = 0 {
        didSet {
            percentageLabel.text = "\(percentage) %"
            if percentage == 100 {
                timer.invalidate()
                showMainView()
            }
        }
    }
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "\(percentage) %"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 28)
        
        return label
    }()
    
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateCircle()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        userScoreDelgete.scoreChange(with: userScore)
    }
    
    
    // MARK: Actions
    @IBAction func xMarkButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        UIView.animate(withDuration: 0.75) {
            self.disappearButtons()
        }
    }
    
    @IBAction func countriesNamesButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == correctAnswerCountry {
            sender.backgroundColor = .green
            userScore += 1
        }else{
            if level == Level.hard{
                userScore -= 1
            }
            sender.backgroundColor = .red
        }
        timer.invalidate()
        mainView.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { _  in
            self.resetCountry()
            
            
        }
    }
    
    
    
    
    // MARK: Functions
    private func configurePage() {
        view.addSubview(percentageLabel)
        
        percentageLabel.frame = CGRect(x: 0, y: 0, width: radiusSize, height: radiusSize)
        percentageLabel.center = view.center
        
        createTrackLayer()
        flagCustomImageView.layer.cornerRadius = 10
        configureContriesNamesButtons()
        
        
        
    }
    
    private func showMainView() {
        mainView.alpha = 0
        view.addSubview(mainView)
        
        UIView.animate(withDuration: 0.75, animations: {
            self.mainView.alpha = 1
        },completion: { _ in
            self.resetCountry()
            self.showMainViewComponnets(isHidden: false)
        })
        
        activityIndicator.setup(view: flagCustomImageView)
        activityIndicator.startAnimating()
        
    }
    
    
    
    private func resetCountry() {
        resterCountriesNamesButton()
        hintButton.isEnabled = level != Level.hard
        randomIndex = ( 0 ..< self.countries.count).randomElement() ?? 0
        let urlString = countries[randomIndex].flag
        correctAnswerCountry = countries[randomIndex].name
        flagCustomImageView.loadImageUsingUrlString(urlString: urlString) { (finish) in
            if finish != nil ,finish! {
                self.activityIndicator.stopAnimating()
                self.mainView.isUserInteractionEnabled = true
                self.startTimer()
                self.setCountriesNameButtonsContent()
            }
        }
        
        
        
    }
    
    
    private func configureContriesNamesButtons() {
        countriesNamesButtons.forEach {
            $0.layer.cornerRadius = 10
        }
        
        showMainViewComponnets(isHidden: true)
        hintButton.layer.cornerRadius = hintButton.bounds.size.width / 2
    }
    
    private func showMainViewComponnets(isHidden: Bool) {
        countriesNamesButtons.forEach {
            $0.isHidden = isHidden
        }
        useScoreLabel.isHidden = isHidden
        timerStackView.isHidden = isHidden
        hintButton.isHidden = isHidden
        
    }
    
    private func setCountriesNameButtonsContent(){
        let correctAnswer = [correctAnswerCountry]
        var names = [String]()
        names.append(contentsOf: correctAnswer)
        
        while names.count < countriesNamesButtons.count {
            let num = Int.random(in: 0..<countries.count)
            let name = countries[num].name
            if !names.contains(name){
                names.append(name)
            }
            
            
        }
        names.shuffle()
        for (index ,button) in countriesNamesButtons.enumerated() {
            button.setTitle(names[index], for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.alpha = 1
        }
        
    }
    
    private func startTimer(){
        timerLabel.textColor = .white
        var seconds = 0
        var hundredth = 0
        var secondsMessage = ""
        var hundredthMessage = ""
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 100, repeats: true, block: { (_) in
            if hundredth == 99{
                seconds += 1
                hundredth = 0
                
            }else{
                hundredth += 1
            }
            secondsMessage = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
            hundredthMessage = (hundredth < 10) ? "0\(hundredth)" : "\(hundredth)"
            self.timerLabel.text = secondsMessage + ":" + hundredthMessage
            
            if seconds == Int(self.level.rawValue){
                self.timer.invalidate()
                self.resetCountry()
            }
            
            if Double(seconds) >= self.level.rawValue * 0.66{
                self.timerLabel.textColor = .red
            }
        })
    }
    
    private func resterCountriesNamesButton(){
        countriesNamesButtons.forEach { (button) in
            button.backgroundColor = .white
            button.setTitle("?", for: .normal)
        }
    }
    
    private func disappearButtons() {
        var numberOfBtnsToDisappear = 0
        var countriesName = [String]()
        var counter = 0
        switch level {
        case .easy:
            numberOfBtnsToDisappear = 2
        default:
            numberOfBtnsToDisappear = 1
        }
        
        while counter < numberOfBtnsToDisappear {
            let random = Int.random(in: 0..<countriesNamesButtons.count)
            let country = countriesNamesButtons[random].titleLabel?.text
            if country == correctAnswerCountry{
                continue
            }
            if !countriesName.contains(country!){
                countriesName.append(country!)
                counter += 1
            }
        }
        countriesNamesButtons.forEach { (button) in
            let country = (button.titleLabel?.text)!
            if countriesName.contains(country){
                button.alpha = 0
            }
        }
        
    }
    
    
    
}



//MARK: handle circule load

extension FlagsViewController{
    
    private func createTrackLayer() {
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radiusSize, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = #colorLiteral(red: 0.1013573185, green: 0.1013607755, blue: 0.1013589278, alpha: 1)
        trackLayer.lineWidth = 10
        trackLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        trackLayer.position = view.center
        
        view.layer.addSublayer(trackLayer)
        createShapeLayer(cgPath: circularPath.cgPath)
    }
    
    private func createShapeLayer(cgPath: CGPath) {
        shapeLayer.path = cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        shapeLayer.position = view.center
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
    }
    
    
    
    private func animateCircle() {
        let duration: CFTimeInterval = 2
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = duration
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "")
        
        timer = Timer.scheduledTimer(timeInterval: duration / 100, target: self, selector: #selector(percentageHandle), userInfo: nil, repeats: true)
    }
    
    @objc private func percentageHandle() {
        percentage += 1
    }
}
