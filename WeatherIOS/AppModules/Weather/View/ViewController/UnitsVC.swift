//
//  UnitsVC.swift
//  WeatherIOS
//
//  Created by Janaina A on 22/09/2024.
//

import UIKit

protocol UnitsVCDelegate:AnyObject {
    func itemSelected()
}

class UnitsVC: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    weak var delegate: UnitsVCDelegate?
    var selectedIndex = 0 //To show selected row
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Initial settings
    private func configure() {
        // find selected unit index
        if let index = Unit.allCases.firstIndex(where: { $0 == appUnit }) {
            selectedIndex = index
        }
        listTableView.reloadData()
    }
}

// MARK: - TableView Delegates
extension UnitsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Unit.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitTableCell.Id, for: indexPath) as! UnitTableCell
        cell.configure(unit: Unit.allCases[indexPath.row], index: indexPath.row, selectedRow: selectedIndex)
        return cell
    }
}

extension UnitsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            //  highlightIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        tableView.reloadData()
        
        //Save selected unit
        appUnit = Unit.allCases[indexPath.row]
        UserDefaults.standard.appUnit = appUnit.rawValue
        delegate?.itemSelected()
    }
}
