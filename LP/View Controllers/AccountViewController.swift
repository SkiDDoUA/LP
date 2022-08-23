//
//  AccountViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 24.08.2022.
//

import UIKit

class AccountViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Аккаунт"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let sectionHeaderLabelView = UIView()
////        let sectionHeaderBackgroundColor = UIColor(hue: 0.021, saturation: 0.34, brightness: 0.94, alpha: 0.4)
////        sectionHeaderLabelView.backgroundColor = sectionHeaderBackgroundColor
////        let sectionHeaderImage = UIImage(named: "SourceIcon")
////        let sectionHeaderImageView = UIImageView(image: sectionHeaderImage)
////        sectionHeaderImageView.frame = CGRect(x: 3, y: 10, width: 30, height: 30)
////        sectionHeaderLabelView.addSubview(sectionHeaderImageView)
//
//        let sectionHeaderLabel = UILabel()
//        sectionHeaderLabel.textColor = UIColor(named: "BlackLP")
//        sectionHeaderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
//        sectionHeaderLabel.frame = CGRect(x: 14, y: -10, width: 250, height: 20)
//        switch section {
//        case 0:
//            sectionHeaderLabel.text =  "Личный кабинет"
//        case 1:
//            sectionHeaderLabel.text =  "Служба поддержки"
//        default:
//            sectionHeaderLabel.text =  "Настройки"
//        }
//        sectionHeaderLabelView.addSubview(sectionHeaderLabel)
//
//        return sectionHeaderLabelView
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
