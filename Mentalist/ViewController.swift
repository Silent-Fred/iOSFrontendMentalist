//
//  ViewController.swift
//  Mentalist
//
//  Created by Michael Kühweg on 12.02.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var jumpToDetail: UIBarButtonItem!
    
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var probablyYesButton: UIButton!
    @IBOutlet weak var dunnoButton: UIButton!
    @IBOutlet weak var probablyNoButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var buttonNewGame: UIBarButtonItem!
    
    var nextMove = NextMove()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNextMoveForDisplay(NextMove());
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newGame(_ sender: AnyObject) {
        callNewGameRESTService()
    }
    
    func callNewGameRESTService() {
        return callRESTService(withEndpoint: "http://localhost:8080/game/start")
    }
    
    func callRESTService(withEndpoint endpoint: String?) {
        
        guard let endpoint = endpoint else {
            return
        }
        let url = URL(string: endpoint)
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    let nextMoveFromRestCall = NextMoveJson(fromJson: json).nextMove
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.prepareNextMoveForDisplay(nextMoveFromRestCall)
                    })
                }
            } else {
                let noConnectionAlert = UIAlertController(title: nil, message: "Keine Verbindung zum Server.", preferredStyle: .alert)
                noConnectionAlert.view.tintColor = self.view.tintColor
                noConnectionAlert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    // nothing to do
                })
                self.present(noConnectionAlert, animated: true)
            }
        })
        task.resume()
    }
    
    func prepareNextMoveForDisplay(_ theNextMove: NextMove) {
        self.navigationItem.title = "Fragen & Antworten"
        nextMove = theNextMove
        if nextMove.questionNumber == nil {
            questionCountLabel.text = ""
        } else {
            questionCountLabel.text = "Frage \(nextMove.questionNumber!)"
        }
        if nextMove.questionText == nil {
            questionLabel.text = "Starte ein neues Spiel mit dem Button in der linken unteren Ecke."
        } else {
            questionLabel.text = nextMove.questionText
        }
        yesButton.isEnabled = nextMove.endpointAnswerYes() != nil
        noButton.isEnabled = nextMove.endpointAnswerNo() != nil
        dunnoButton.isEnabled = nextMove.endpointAnswerDunno() != nil
        probablyYesButton.isEnabled = nextMove.endpointAnswerProbablyYes() != nil
        probablyNoButton.isEnabled = nextMove.endpointAnswerProbablyNo() != nil
        
        if let endpointConfirm = theNextMove.endpointConfirm() , let name = theNextMove.myGuess?.name {
            let confirmAlert = UIAlertController(title: nil, message: "Ich würde sagen, du denkst an \(name).", preferredStyle: .actionSheet)
            confirmAlert.view.tintColor = self.view.tintColor
            confirmAlert.addAction(UIAlertAction(title: "Stimmt", style: .default) { action in
                self.callRESTService(withEndpoint: endpointConfirm)
            })
            confirmAlert.addAction(UIAlertAction(title: "Falsch", style: .cancel) { action in
                // perhaps use action.title here
            })
            self.present(confirmAlert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "jumpToRatingsSegue" {
            let ratingsController = segue.destination as! TableViewController
            ratingsController.nextMove = nextMove
        }
    }
    
    @IBAction func doButtonYes() {
        callRESTService(withEndpoint: nextMove.endpointAnswerYes())
    }
    
    @IBAction func doButtonNo() {
        callRESTService(withEndpoint: nextMove.endpointAnswerNo())
    }
    
    @IBAction func doButtonDunno() {
        callRESTService(withEndpoint: nextMove.endpointAnswerDunno())
    }
    
    @IBAction func doButtonProbablyYes() {
        callRESTService(withEndpoint: nextMove.endpointAnswerProbablyYes())
    }
    
    @IBAction func doButtonProbablyNo() {
        callRESTService(withEndpoint: nextMove.endpointAnswerProbablyNo())
    }
}

