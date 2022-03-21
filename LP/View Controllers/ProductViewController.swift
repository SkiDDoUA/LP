//
//  ProductViewController.swift
//  LP
//
//  Created by Anton Kolesnikov on 09.01.2022.
//

import UIKit
import Kingfisher
import Firebase

class ProductViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var sizePickerTextField: СustomUITextField!
    @IBOutlet weak var detailsTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var pageViewControl: UIPageControl!

    var product: StockProduct!
    var viewPicker = UIPickerView()
    let headerID = String(describing: CustomHeaderView.self)
    var arrayOfData = [ExpandedModel]()
    var sizechart: Sizechart!
    private var database: Database?

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfData = [
            ExpandedModel(isExpanded: false, title: "Описание", text: "ID модели: \(product.details.stylecode) \nЦвет: \(product.details.color)"),
            ExpandedModel(isExpanded: false, title: "Доставка", text: "Сроки доставки: \(product.details.delivery)"),
            ExpandedModel(isExpanded: false, title: "Материал", text: "\(product.details.material.map {"\($0): \($1)"}.joined(separator:"\n"))"),
            ExpandedModel(isExpanded: false, title: "Размерная сетка", text: "product.brand.sizechart")
        ]
        
        self.navigationController?.navigationBar.topItem?.title = " "
        detailsTableView.register(SizeChartTableViewCell.nib(), forCellReuseIdentifier: "SizeChartTableViewCell")
        detailsTableView.rowHeight = UITableView.automaticDimension
        tableViewConfig()
        configureTapGesture()
        
        pageViewControl.numberOfPages = self.product.images.count
        viewPicker.dataSource = self
        viewPicker.delegate = self
        viewPicker.backgroundColor = UIColor.systemBackground
        sizePickerTextField.inputView = viewPicker
        sizePickerTextField.setEditActions(only: [])
        self.sizePickerTextField.setInputViewPicker(target: self, selector: #selector(tapDoneViewPicker))
        
        DispatchQueue.main.async {
            self.productBrandLabel.text = self.product.brand.name.uppercased()
            self.productNameLabel.text = self.product.name
            self.productPriceLabel.text = "₴\(self.product.price.description)"
        }
        
        loadSizechart()
    }
    
    //MARK: - Load Data From Database
    func loadSizechart() {
        database = Database()
        database?.getSizechart(docReference: product.brand.sizechart!, docCollection: "sizecharts/\(product.brand.name)/\(product.details.type)/") {
            handler in self.sizechart = handler
        }
    }
    
    // MARK: - UIPageControl
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageViewControl.currentPage = Int((targetContentOffset.pointee.x/view.frame.width).rounded())
    }
    
    //MARK: - Extensions For Product Collection View Cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.product.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImageCell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.kf.setImage(with: URL(string: self.product.images[indexPath.row]))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = productCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - PickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return product.details.size.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return product.details.size[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sizePickerTextField.text = product.details.size[row]
    }
    
    // MARK: - TableView Delegation
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfData.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !arrayOfData[section].isExpanded {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeChartTableViewCell", for: indexPath)
            if let cell = cell as? SizeChartTableViewCell {
                cell.sizechart = sizechart
                cell.productType = product.details.type
                cell.productBrand = product.brand.name
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath)
            if let cell = cell as? DetailsTableViewCell {
                cell.descriptionTextLabel?.text = arrayOfData[indexPath.section].text
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! CustomHeaderView
        header.configure(title: arrayOfData[section].title.uppercased(), section: section)
        header.rotateImage(arrayOfData[section].isExpanded)
        header.bottomLineView.isHidden = arrayOfData[section].isExpanded
        header.delegate = self
        return header
    }
    
    // MARK: - Custom HeaderView
    private func tableViewConfig() {
        let nib = UINib(nibName: headerID, bundle: nil)
        detailsTableView.register(nib, forHeaderFooterViewReuseIdentifier: headerID)
        detailsTableView.tableFooterView = UIView()
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    // MARK: - TapGesture
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    // MARK: - Set ViewPicker
    @objc func tapDoneViewPicker() {
        self.sizePickerTextField.resignFirstResponder()
    }
}

// MARK: - Expend Section and View
extension ProductViewController: HeaderViewDelegate {
    func expandedSection(button: UIButton) {
        let section = button.tag
        let isExpanded = arrayOfData[section].isExpanded
        arrayOfData[section].isExpanded = !isExpanded
        detailsTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        detailsTableView.layoutIfNeeded()
        detailsTableViewConstraint.constant = detailsTableView.contentSize.height
    }
}
