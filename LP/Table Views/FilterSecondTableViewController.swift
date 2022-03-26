//
//  FilterSecondTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.03.2022.
//

import UIKit

// Protocol used for sending data back
protocol FilterChosenDelegate: AnyObject {
    func userDidChoseFilters(filters: [String], type: FilterTableViewController.filterTypes?)
}

class FilterSecondTableViewController: UITableViewController {
    
    var filterData = [Any]()
    var filterType: FilterTableViewController.filterTypes?
    var chosenFilters = [String]()
    var buttonTapped = false
    weak var delegate: FilterChosenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addResultButtonView()
        self.navigationController?.navigationBar.topItem?.title = " "
        title = filterType?.rawValue
    }
    
    private func addResultButtonView() {
        let resultButton = UIButton()

        resultButton.backgroundColor = UIColor(named: "BlackLP")
        resultButton.setTitle("Показать результаты", for: .normal)
        resultButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 14)
        resultButton.addTarget(self, action: #selector(resultTapped), for: .touchUpInside)
        tableView.addSubview(resultButton)

        // set position
        resultButton.translatesAutoresizingMaskIntoConstraints = false
        resultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        resultButton.widthAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.widthAnchor, constant: -30).isActive = true
        resultButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSecondCell", for: indexPath)
        if let cell = cell as? FilterSecondTableViewCell {
            cell.filterParameterTextLabel?.text = filterData[indexPath.row] as? String
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterSecondTableViewCell
        let filter = cell.filterParameterTextLabel.text!
        
        if cell.checkImageView.isHidden {
            chosenFilters.append(filter)
            cell.checkImageView.isHidden = false
        }
        else {
            chosenFilters.remove(at: chosenFilters.firstIndex(of: filter)!)
            cell.checkImageView.isHidden = true
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            if buttonTapped == false {
                delegate?.userDidChoseFilters(filters: chosenFilters, type: filterType)
            }
        }
    }
    
    // MARK: - Parse Chosen Filters
    @IBAction func resultTapped(_ sender: Any) {
        buttonTapped = true
        self.performSegue(withIdentifier: "unwindToShopping", sender: Any?.self)
    }
    
    //MARK: - Parse Chosen Filter Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "unwindToShopping":
            let destination = segue.destination as! ShoppingViewController
            destination.chosenFilters = chosenFilters
            destination.filterType = filterType
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
