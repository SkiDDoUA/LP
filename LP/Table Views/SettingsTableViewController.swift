//
//  SettingsTableViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 03.06.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionHeaderLabelView = UIView()
//        let sectionHeaderBackgroundColor = UIColor(hue: 0.021, saturation: 0.34, brightness: 0.94, alpha: 0.4)
//        sectionHeaderLabelView.backgroundColor = sectionHeaderBackgroundColor
//        let sectionHeaderImage = UIImage(named: "SourceIcon")
//        let sectionHeaderImageView = UIImageView(image: sectionHeaderImage)
//        sectionHeaderImageView.frame = CGRect(x: 3, y: 10, width: 30, height: 30)
//        sectionHeaderLabelView.addSubview(sectionHeaderImageView)

        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.textColor = UIColor(named: "BlackLP")
        sectionHeaderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        sectionHeaderLabel.frame = CGRect(x: 14, y: -10, width: 250, height: 20)
        switch section {
        case 0:
            sectionHeaderLabel.text =  "Личный кабинет"
        case 1:
            sectionHeaderLabel.text =  "Служба поддержки"
        default:
            sectionHeaderLabel.text =  "Настройки"
        }
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)

        return sectionHeaderLabelView
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
