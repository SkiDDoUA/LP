//
//  SettingsTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 03.06.2022.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    private var database: Database?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Аккаунт"
        navigationController?.addBottomLine()
        loadData()
    }

    
    //MARK: - Load Data From Database
    func loadData() {
        database = Database()
        database?.getUserDetails() { userData in self.user = userData }
    }
    
    //MARK: - Parse Cell Data To OrderDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toPersonalInfo":
            let destination = segue.destination as! PersonalInfoViewController
            destination.user = user
        case "toAddressBook":
            let destination = segue.destination as! AddressBookViewController
            destination.user = user
        default: break
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.textColor = UIColor(named: "BlackLP")
        sectionHeaderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        sectionHeaderLabel.frame = CGRect(x: 14, y: 10, width: 250, height: 20)
        
        switch section {
        case 0:
            sectionHeaderLabel.frame = CGRect(x: 14, y: 15, width: 250, height: 20)
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
            return 35.0
        case 1:
            return 30.0
        default:
            return 30.0
        }
    }
}
