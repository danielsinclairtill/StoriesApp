//
//  SettingsViewController.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

class SettingsViewController: UIViewController,
                              UITableViewDataSource,
                              UITableViewDelegate,
                              UIGestureRecognizerDelegate {
    private let cellID = "ID"
    private let tableView = UITableView()
    private let options = ["Profile", "Theme"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "com.test.Stories.settings.title".localized()
        view.backgroundColor = StoriesDesign.shared.attributes.colors.primary()

        // tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: self.cellID)
        cell.selectionStyle = .none
        cell.textLabel?.text = option
        cell.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        if option == "Theme" {
            navigationController?.pushViewController(ThemeSettingsViewController(), animated: true)
        }
    }
}