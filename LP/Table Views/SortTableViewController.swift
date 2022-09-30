//
//  SortTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 15.02.2022.
//

import UIKit
import DLRadioButton

// MARK: - Protocol used for sending data back from SortTableViewController to ShoppingViewController
protocol SortDataDelegate: AnyObject {
    func returnSortData(sort: Sort)
}

class SortTableViewController: UITableViewController {
    
    @IBOutlet weak var recommendationButton: DLRadioButton!
    @IBOutlet weak var newButton: DLRadioButton!
    @IBOutlet weak var lowpriceButton: DLRadioButton!
    @IBOutlet weak var highpriceButton: DLRadioButton!
    var sortStructure = Sort(sortType: .recommendation)
    weak var delegate: SortDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        title = "Сортировка"
        addResultButtonView()
        switch sortStructure.sortType {
        case .recommendation:
            recommendationButton.isSelected = true
        case .new:
            newButton.isSelected = true
        case .lowprice:
            lowpriceButton.isSelected = true
        default:
            highpriceButton.isSelected = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.returnSortData(sort: sortStructure)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            sortStructure = Sort(sortType: .recommendation)
            recommendationButton.sendActions(for: .touchUpInside)
        case 1:
            sortStructure = Sort(sortType: .new)
            newButton.sendActions(for: .touchUpInside)
        case 2:
            sortStructure = Sort(sortType: .highprice)
            highpriceButton.sendActions(for: .touchUpInside)
        default:
            sortStructure = Sort(sortType: .lowprice)
            lowpriceButton.sendActions(for: .touchUpInside)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    //MARK: - Parse Filter Data To ShoppingViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "unwindToShopping":
            let destination = segue.destination as! ShoppingViewController
            destination.sortStructure = sortStructure
        default: break
        }
    }
    
    // MARK: - Parse Chosen Filters
    @IBAction func resultTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToShopping", sender: Any?.self)
    }
    
    public func addResultButtonView() {
        let resultButton = UIButton()
        resultButton.backgroundColor = UIColor(named: "BlackLP")
        resultButton.setTitle("Показать результаты", for: .normal)
        resultButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 14)
        resultButton.addTarget(self, action: #selector(resultTapped), for: .touchUpInside)
        tableView.addSubview(resultButton)
        resultButton.translatesAutoresizingMaskIntoConstraints = false
        resultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        resultButton.widthAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.widthAnchor, constant: -30).isActive = true
        resultButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
