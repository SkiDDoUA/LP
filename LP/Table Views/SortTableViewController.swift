//
//  SortTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 15.02.2022.
//

import UIKit
import DLRadioButton

class SortTableViewController: UITableViewController {
    @IBOutlet weak var recommendationButton: DLRadioButton!
    @IBOutlet weak var newButton: DLRadioButton!
    @IBOutlet weak var lowpriceButton: DLRadioButton!
    @IBOutlet weak var highpriceButton: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = " "
        title = "Сортировка"
        
        recommendationButton.isSelected = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            recommendationButton.sendActions(for: .touchUpInside)
        case 1:
            newButton.sendActions(for: .touchUpInside)
        case 2:
            lowpriceButton.sendActions(for: .touchUpInside)
        default:
            highpriceButton.sendActions(for: .touchUpInside)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

}
