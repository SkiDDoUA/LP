//
//  ViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 10.06.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        //MARK: - Setup SearchBar
        self.navigationItem.titleView = searchBar
        searchBar.searchTextField.layer.cornerRadius = 4
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.backgroundImage = UIImage()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
