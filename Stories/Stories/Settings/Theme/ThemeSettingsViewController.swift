//
//  ThemeSettingsViewController.swift
//  Stories
//
//
//
//

import Foundation
import UIKit
import RxSwift

class ThemeSettingsViewController: UIViewController,
                                   UITableViewDataSource,
                                   UITableViewDelegate,
                                   UIGestureRecognizerDelegate {
    private let cellID = "ID"
    private let tableView = UITableView()
    private let options: [StoriesDesignTheme] = StoriesDesignTheme.allCases
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "com.test.Stories.settings.theme.title".localized()
        
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
        tableView.alwaysBounceVertical = false
        // required to remove top separator line
        tableView.tableHeaderView = UIView()
        
        setupDesign()
        
        // select row
        selectThemeRow()
    }
    
    private func setupDesign() {
        StoriesDesign.shared.output.theme
            .drive { [weak self] theme in
                guard let strongSelf = self else { return }
                strongSelf.view.backgroundColor = theme.attributes.colors.primary()
                strongSelf.tableView.separatorColor = theme.attributes.colors.primaryFill()
                strongSelf.tableView.backgroundColor = theme.attributes.colors.primary()
            }
            .disposed(by: disposeBag)
    }
    
    private func selectThemeRow() {
        let selectedIndex = options.firstIndex(of: ApplicationManager.shared.theme) ?? 0
        tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: false, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: self.cellID)
        cell.textLabel?.text = option.getText()
        // TODO: Move to custom cell to reset disposeBag
        StoriesDesign.shared.output.theme
            .drive { theme in
                cell.backgroundColor = theme.attributes.colors.primary()
                cell.textLabel?.textColor = theme.attributes.colors.primaryFill()
            }
            .disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = options[indexPath.row]
        StoriesDesign.shared.changeToTheme(theme)
    }
}
