//
//  CelebritiesWithRatingTableViewController.swift
//  Mentalist
//
//  Created by Michael Kühweg on 05.03.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation
import UIKit

class CelebritiesWithRatingTableViewController: UITableViewController {
    
    var rating = EvaluationStatus()
    var celebrities = [Celebrity]()
    
    override func viewDidLoad() {
        self.navigationItem.title = ""
        celebrities.removeAll()
        celebrities.append(Celebrity(withName: "loading...", andDescription: "contacting service..."))
        callEndpointAndUpdateView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celebrityNameCell", for: indexPath)
        
        let celebrity = celebrities[indexPath.row]
        cell.textLabel?.text = celebrity.name
        cell.detailTextLabel?.text = celebrity.description
        
        return cell
    }
    
    func callEndpointAndUpdateView() {
        callRESTService(withEndpoint: rating.endpoint)
    }
    
    func callRESTService(withEndpoint endpoint: String) {
        
        let url = URL(string: endpoint)
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.prepareForDisplay(celebritiesToPutInView: self.celebrities(fromJson: json))
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
    
    func prepareForDisplay(celebritiesToPutInView: [Celebrity]) {
        celebrities = celebritiesToPutInView
        self.tableView.reloadData()
    }
    
    func celebrities(fromJson: Any?) -> [Celebrity] {
        var celebritiesFromJson = [Celebrity]()
        if let array = fromJson as? [Any] {
            for item in array {
                let celebrityJson = CelebrityJson(fromJson: item)
                celebritiesFromJson.append(celebrityJson.celebrity)
            }
        }
        return celebritiesFromJson
    }
}
