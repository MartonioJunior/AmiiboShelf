//
//  AmiiboViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import UserNotifications

#warning("Clean up all of the old implementation for future compatibility work")
#warning("Check which features need to be brought to SwiftUI")
// MARK: SearchType enum
enum SearchType: String {
    case shelfItem = "shelf"
    case figure = "figure"
    case card = "card"
}

// MARK: AmiiboViewController class
class AmiiboViewController: UIViewController, AmiiboDataDelegate {
    // MARK: References
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: Properties
    var amiiboItens: [Amiibo] = [] {
        didSet {
            searchResults = amiiboItens
        }
    }

    // MARK: Variables
    var listType: SearchType?
    var searchResults: [Amiibo] = []
    var selectedIndex = 0

    // MARK: ViewController Lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let destination = segue.destination as? AmiiboDetailViewController
            destination?.amiibo = searchResults[selectedIndex]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        UNUserNotificationCenter.current().delegate = self
        AmiiboCoreDataManager.current.dataDelegate = self
//        AmiiboAPI.current.dataDelegate = self

        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.primary.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        AmiiboAPI.current.reloadImages(from: &self.amiiboItens)

        self.updateView()
    }

    // MARK: Methods
    func search(searchTerm: String) {
        searchResults = amiiboItens.filter { amiibo in
            return amiibo.name.lowercased().contains(searchTerm.lowercased())
        }

        updateView()
    }

    func updateView() {}
    func reloadData() {}

    func source(forLocation location: CGPoint) -> AmiiboDisplayProtocol? {
        return nil
    }

    func downloaded(imageFor amiiboID: String) {
        guard let indexItens = (self.amiiboItens.firstIndex { amiibo in return amiibo.id == amiiboID }) else { return }

        guard let indexSearch = (self.searchResults.firstIndex { $0.id == amiiboID }) else { return }

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

// MARK: AmiiboViewController Search
extension AmiiboViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            search(searchTerm: searchTerm)
            searchResults = amiiboItens.sorted(by: {
                $1.name.lowercased().hasPrefix(searchTerm.lowercased())
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

// MARK: AmiiboViewController Notifications
extension AmiiboViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        if let amiiboToReload = notification.request.content.userInfo["updateAmiibo"] as? String {
            self.reloadData()
        }

        completionHandler(.banner)
    }
}

// MARK: AmiiboViewController Previews
extension AmiiboViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint
    ) -> UIViewController? {
        guard let displayInfo = source(forLocation: location),
              let amiiboPreview = storyboard?.instantiateViewController(withIdentifier: "AmiiboPreview")
                as? AmiiboPreviewViewController else { return nil }

        previewingContext.sourceRect = displayInfo.frame
        amiiboPreview.amiibo = displayInfo.amiibo
        amiiboPreview.preferredContentSize = CGSize(width: 375, height: 500)
        return amiiboPreview
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        showDetailViewController(viewControllerToCommit, sender: nil)
    }
}

#Preview {
    let controller = AmiiboViewController()
    return controller
}
