//
//  ThemeSettingsViewController.swift
//  Stories
//
//
//
//

import Foundation
import UIKit

class ThemeSettingsViewController: UIViewController,
                                   UITableViewDataSource,
                                   UITableViewDelegate,
                                   UIGestureRecognizerDelegate {
    private let cellID = "ID"
    private let tableView = UITableView()
    private let options: [DesignTheme] = DesignTheme.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "com.test.Stories.settings.theme.title".localized()
        view.backgroundColor = StoriesDesign.shared.attributes.colors.primary()

        // tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
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
        cell.textLabel?.text = option.rawValue.capitalized
        cell.backgroundColor = StoriesDesign.shared.attributes.colors.primary()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = options[indexPath.row]
        StoriesDesign.shared.changeToTheme(theme)
    }
}
