//
//  FigureViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import UserNotifications

class FigureViewController: AmiiboViewController {
    @IBOutlet weak var amiiboTableView: UITableView!
    //var allAmiiboSeries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amiiboTableView.delegate = self
        amiiboTableView.dataSource = self
        amiiboItens = Amiibo.from(cdAmiibos: CoreDataManager.current.fetchAllFigureAmiibo())
        registerForPreviewing(with: self, sourceView: amiiboTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getNotificationSettings()
    }
    
    override func reloadData() {
        amiiboItens = Amiibo.from(cdAmiibos: CoreDataManager.current.fetchAllFigureAmiibo())
        updateView()
    }
    
    override func updateView() {
        DispatchQueue.main.async {
            self.amiiboTableView.reloadData()
        }
    }
    
    override func source(forLocation location: CGPoint) -> AmiiboDisplayProtocol? {
        guard let indexPath = amiiboTableView.indexPathForRow(at: location), let cell = amiiboTableView.cellForRow(at: indexPath) as? FigureItemTableViewCell else {
            return nil
        }
        return cell
    }
    
    override func new(amiibo: Amiibo) {
        if amiibo.type != "Card" {
            super.new(amiibo: amiibo)
        }
    }
    
    func showNotificationRequiredAlert() {
        let alertController = UIAlertController (title: "Notifications", message: "Notifications are used to inform you when the local Amiibo database is being updated and about any amiibo releases. Your application will still fetch new data without them, but you won't be informed about any updates", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                if !UserDefaults.standard.bool(forKey: "firstTime") {
                    self.showNotificationRequiredAlert()
                    UserDefaults.standard.set(true, forKey: "firstTime")
                }
                return
            }
        }
    }
}

extension FigureViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = amiiboTableView.dequeueReusableCell(withIdentifier: "Figure") as? FigureItemTableViewCell else {
            return FigureItemTableViewCell()
        }
        let amiibo = searchResults[indexPath.row]
        cell.amiibo = amiibo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (tableView.frame.height > 800) {
//            return 120
//        } else {
//            return 85
//        }
//    }
}
