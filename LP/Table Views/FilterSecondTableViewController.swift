//
//  FilterSecondTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 18.03.2022.
//

import UIKit

class FilterSecondTableViewController: UITableViewController {
    
    var filterData = [Any]()
    var titleString = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = " "
        title = titleString
        
        print(filterData)
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
