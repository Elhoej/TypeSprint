//
//  ViewController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 30/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import Firebase

class TypeController: UIViewController, UITextFieldDelegate, CountDownViewControllerDelegate, YouWonViewControllerDelegate
{
    //MARK: - Properties
    var wpmResultController: WpmResultController?
    var quote: Quote?
    {
        didSet
        {
            guard let quote = quote else { return }
            quoteString = quote.contents.quote
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            
            attributedText = NSMutableAttributedString(string: quoteString, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.9, alpha: 1), NSAttributedString.Key.paragraphStyle: paragraphStyle])
            toTypelabel.attributedText = attributedText
        }
    }
    private var quoteString = "You, me, or nobody is gonna hit as hard as life. But it ain't how hard you hit; it's about how hard you can get hit, and keep moving forward."
    private var index = 0
    private var attributedText: NSMutableAttributedString?
    private var containsWrongLetter = false
    private var wrongLetterIndex = 0
    private var duration: Double = 0
    private var timer: Timer?
    private var wpm = 0
    private var wordCounter: Double = 0
    {
        didSet
        {
            if wordCounter == 0 || duration < 1
            {
                return
            }
            
            let minutes: Double = duration / 60
            let wpm: Int = Int(wordCounter / minutes)
            self.wpm = wpm
            wpmLabel.text = "wpm: \(wpm)"
        }
    }
    
    //MARK: - UI Objects
    let wpmLabel: UILabel =
    {
        let label = UILabel()
        label.font = Appearance.titleFont(with: 28)
        label.sizeToFit()
        label.text = "wpm: 0"
        label.textColor = .white
        
        return label
    }()
    
    let restartButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "restart-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleRestart), for: .touchUpInside)
        
        return button
    }()
    
    let quitButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "quit-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleQuit), for: .touchUpInside)
        
        return button
    }()
    
    lazy var progressView: ProgressView =
    {
        let pv = ProgressView()
        
        return pv
    }()
    
    lazy var countDownViewController: CountDownViewController =
    {
        let cdvc = CountDownViewController()
        cdvc.delegate = self
        
        return cdvc
    }()
    
    lazy var toTypelabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    lazy var typeTextField: TypistTextField =
    {
        let tf = TypistTextField()
        tf.placeholder = "Write your text here..."
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.autocapitalizationType = .sentences
        tf.autocorrectionType = .no
        tf.tintColor = .lightBlue
        
        return tf
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    //MARK: - Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: UIColor.darkBlue.cgColor, colorTwo: UIColor.rgb(red: 0, green: 23, blue: 40).cgColor)
        
        setupViews()
        fetchQuote()
    }
    
    private func fetchQuote()
    {
        countDownViewController.tapToStartLabel.isHidden = true
        countDownViewController.tapToStartLabel.isUserInteractionEnabled = false
        countDownViewController.loadingIndicator.startAnimating()
        
        NetworkManager.shared.fetchRandomQuote { (error, quote) in
            
            if let _ = error
            {
                DispatchQueue.main.async {
                    self.showAlert(with: "Ooops, we couldn't find you any quote to type, please try again!")
                    self.dismiss(animated: true, completion: nil)
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.countDownViewController.tapToStartLabel.isHidden = false
                self.countDownViewController.tapToStartLabel.isUserInteractionEnabled = true
                self.countDownViewController.loadingIndicator.stopAnimating()
                self.quote = quote
            }
        }
    }
    
    @objc private func handleRestart()
    {
        typeTextField.resignFirstResponder()
        countDownViewController = CountDownViewController()
        countDownViewController.delegate = self
        view.addSubview(countDownViewController.view)
        countDownViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        resetAllVariables()
        
        UIView.animate(withDuration: 0.3) {
            self.countDownViewController.view.alpha = 1
        }
    }
    
    private func resetAllVariables()
    {
        index = 0
        containsWrongLetter = false
        wrongLetterIndex = 0
        duration = 0.0
        wordCounter = 0.0
        timer?.invalidate()
        typeTextField.text = nil
        wpm = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedText = NSMutableAttributedString(string: quoteString, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.9, alpha: 1), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        toTypelabel.attributedText = attributedText
        wpmLabel.text = "wpm: 0"
        progressView.imageViewLeftAnchor?.constant = 0
        view.layoutIfNeeded()
    }
    
    @objc private func handleQuit()
    {
        typeTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateTimer()
    {
        duration += 1
    }
    
    func countdownFinished()
    {
        self.typeTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            
            self.countDownViewController.view.alpha = 0
            
        }) { (completed) in
            
            self.countDownViewController.view.removeFromSuperview()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    private func addBackground(color: UIColor, from: Int, to: Int)
    {
        attributedText?.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: NSMakeRange(from, to))
        toTypelabel.attributedText = attributedText
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let char = string.cString(using: String.Encoding.utf8) else { return true }
        let keyPressed = strcmp(char, "\\b")
        if keyPressed == -92
        {
            addBackground(color: .clear, from: index - 1, to: 1)
            index -= 1
            
            if index < wrongLetterIndex
            {
                wrongLetterIndex = 0
                containsWrongLetter = false
            }
        }
        else if keyPressed == -82
        {
            return false
        }
        else
        {
            if index == quoteString.count
            {
                return false
            }
            
            if charactersDoesMatch(letter: string, i: index)
            {
                if containsWrongLetter
                {
                    if index == wrongLetterIndex && charactersDoesMatch(letter: string, i: index)
                    {
                        containsWrongLetter = false
                        addBackground(color: .correctGreen, from: index, to: 1)
                        handleWPM(index: index)
                        progressView.animateAvatar(index: index, count: quoteString.count - 1)
                    }
                    else
                    {
                        addBackground(color: .incorrectRed, from: index, to: 1)
                    }
                }
                else
                {
                    addBackground(color: .correctGreen, from: index, to: 1)
                    handleWPM(index: index)
                    progressView.animateAvatar(index: index, count: quoteString.count - 1)
                }
            }
            else
            {
                addBackground(color: .incorrectRed, from: index, to: 1)
                
                if !containsWrongLetter
                {
                    containsWrongLetter = true
                    wrongLetterIndex = index
                }
            }
            
            index += 1
            if won(index, quoteString.count, containsWrongLetter)
            {
                handleWon()
            }
        }
        return true
    }
    
    private func handleWon()
    {
        timer?.invalidate()
        typeTextField.resignFirstResponder()
        
        wpmResultController?.createNewResult(wpm: Int32(wpm))
        uploadResult()
        
        let intDuration = Int(duration)
        let timeString = intDuration.secondsToMinutesAndSecondsString()
        
        let normalAttributes = [NSAttributedString.Key.font: Appearance.titleFont(with: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let attributedString = NSMutableAttributedString(string: "You just typed a quote by ", attributes: normalAttributes)
        attributedString.append(NSAttributedString(string: quote?.contents.author ?? "Unknown author", attributes: [NSAttributedString.Key.font: Appearance.titleFont(with: 24), NSAttributedString.Key.foregroundColor: UIColor.incorrectRed]))
        attributedString.append(NSAttributedString(string: " with a time of ", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: timeString, attributes: [NSAttributedString.Key.font: Appearance.titleFont(with: 24), NSAttributedString.Key.foregroundColor: UIColor.correctGreen]))
        attributedString.append(NSAttributedString(string: " and a speed of ", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: "\(wpm) wpm!", attributes: [NSAttributedString.Key.font: Appearance.titleFont(with: 24), NSAttributedString.Key.foregroundColor: UIColor.lightBlue]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.string.count))
        
        let youWonController = YouWonViewController()
        youWonController.delegate = self
        youWonController.wonLabel.attributedText = attributedString
        youWonController.modalPresentationStyle = .overCurrentContext
        present(youWonController, animated: true, completion: nil)
    }
    
    private func uploadResult()
    {
        let values = ["name": "Simon", "wpm": wpm] as [String: Any]
        Database.database().reference().child("leaderboard").childByAutoId().updateChildValues(values)
    }
    
    private func won(_ index: Int,_ count: Int,_ incorrect: Bool) -> Bool
    {
        if index == count && incorrect == false
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func handleWPM(index: Int)
    {
        if index == 0
        {
            return
        }
        
        if index % 5 == 0
        {
            wordCounter += 1
        }
    }
    
    private func charactersDoesMatch(letter: String, i: Int) -> Bool
    {
        if letter == String(quoteString[i])
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func dismissToMenu()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startNewRace()
    {
        handleRestart()
        fetchQuote()
    }
    
    //MARK: - AutoLayout
    private func setupViews()
    {
        view.addSubview(wpmLabel)
        view.addSubview(quitButton)
        view.addSubview(restartButton)
        view.addSubview(progressView)
        view.addSubview(toTypelabel)
        view.addSubview(typeTextField)
        
        wpmLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        quitButton.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 16, paddingBottom: 0, width: 30, height: 30)
        quitButton.centerYAnchor.constraint(equalTo: wpmLabel.centerYAnchor, constant: -3).isActive = true
        
        restartButton.anchor(top: nil, left: nil, bottom: nil, right: quitButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 16, paddingBottom: 0, width: 30, height: 30)
        restartButton.centerYAnchor.constraint(equalTo: wpmLabel.centerYAnchor, constant: -3).isActive = true
        
        progressView.anchor(top: wpmLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 60)

        toTypelabel.anchor(top: progressView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12, paddingBottom: 0, width: 0, height: 0)
        
        typeTextField.anchor(top: toTypelabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 50, paddingLeft: 12, paddingRight: 12, paddingBottom: 0, width: 0, height: 50)
        
        view.addSubview(countDownViewController.view)
        countDownViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
    }

}




















