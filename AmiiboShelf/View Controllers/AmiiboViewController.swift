//
//  AmiiboViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import UserNotifications

enum SearchType: String {
    case shelfItem = "shelf"
    case figure = "figure"
    case card = "card"
}

class AmiiboViewController: UIViewController, AmiiboDataDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var amiiboItens: [Amiibo] = [] {
        didSet {
            searchResults = amiiboItens
        }
    }
    var searchResults: [Amiibo] = []
    var listType: SearchType?
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        UNUserNotificationCenter.current().delegate = self
        CoreDataManager.current.dataDelegate = self
        AmiiboImageManager.dataDelegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(red: 68.0/255, green: 135.0/255, blue: 117/255.0, alpha: 1).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AmiiboImageManager.reloadImages(from: &self.amiiboItens)
        self.updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let destination = segue.destination as? AmiiboDetailViewController
            destination?.amiibo = searchResults[selectedIndex]
        }
    }
    
    func search(searchTerm: String) {
        searchResults = amiiboItens.filter { amiibo in
            return amiibo.name.lowercased().contains(searchTerm.lowercased())
        }
        self.updateView()
    }
    
    func updateView() {
        
    }
    
    func reloadData() {
        
    }
    
    func source(forLocation location: CGPoint) -> AmiiboDisplayProtocol? {
        return nil
    }
    
    func imageDownloaded(for amiiboID: String) {
        guard let indexItens = (self.amiiboItens.index { amiibo in return amiibo.id == amiiboID }) else {
            return
        }
        AmiiboImageManager.reloadImage(from: &amiiboItens[indexItens])
        guard let indexSearch = (self.searchResults.index { amiibo in return amiibo.id == amiiboID }) else {
            return
        }
        AmiiboImageManager.reloadImage(from: &searchResults[indexSearch])
        updateView()
    }
    
    func new(amiibo: Amiibo) {
        amiiboItens.append(amiibo)
        updateView()
    }
    
    func amiiboDataUpdated() {
        reloadData()
    }
}

extension AmiiboViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            search(searchTerm: searchTerm)
            searchResults = amiiboItens.sorted(by: { a1, a2 in
                return a2.name.lowercased().hasPrefix(searchTerm.lowercased())
            })
        } else {
            searchResults = amiiboItens
            updateView()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            search(searchTerm: searchText)
        } else {
            searchResults = amiiboItens
            updateView()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
    }
}

extension AmiiboViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let amiiboToReload = notification.request.content.userInfo["updateAmiibo"] as? String {
            if let index = (self.amiiboItens.index { amiibo in return amiibo.id == amiiboToReload }) {
                AmiiboImageManager.reloadImage(from: &amiiboItens[index])
            }
            self.reloadData()
        }
        
        completionHandler(.alert)
    }
}

extension AmiiboViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let displayInfo = source(forLocation: location), let amiiboPreview = storyboard?.instantiateViewController(withIdentifier: "AmiiboPreview") as? AmiiboPreviewViewController else {
            return nil
        }
        previewingContext.sourceRect = displayInfo.sourceRect
        amiiboPreview.amiibo = displayInfo.amiibo
        amiiboPreview.preferredContentSize = CGSize(width: 375, height: 500)
        return amiiboPreview
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        showDetailViewController(viewControllerToCommit, sender: nil)
    }
}
