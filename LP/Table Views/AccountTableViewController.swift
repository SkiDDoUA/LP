//
//  SettingsTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 03.06.2022.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Аккаунт"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.textColor = UIColor(named: "BlackLP")
        sectionHeaderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        sectionHeaderLabel.frame = CGRect(x: 14, y: 10, width: 250, height: 20)
        switch section {
        case 0:
            sectionHeaderLabel.frame = CGRect(x: 14, y: 20, width: 250, height: 20)
            sectionHeaderLabel.text =  "Личный кабинет"
        case 1:
            sectionHeaderLabel.text =  "Настройки"
        default:
            sectionHeaderLabel.text =  "Информация"
        }
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)

        return sectionHeaderLabelView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40.0
        case 1:
            return 30.0
        default:
            return 30.0
        }
    }
}
