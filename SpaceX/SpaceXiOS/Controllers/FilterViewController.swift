//
//  FilterViewController.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 21/09/2021.
//

import UIKit

public enum Order {
    case ascending
    case descending
}

protocol FilterDelegate: NSObject {
    func applyFilter(year: [String], order: Order, launchSuccess: Bool?)
}

class FilterViewController: UIViewController {
    public var years = [String]()
    private var selectedYears = [FilterViewCell]()
    private var selectedOrder: Order = .ascending
    public weak var delegate: FilterDelegate?

    @IBOutlet var collectionViewFilter: UICollectionView!
    @IBOutlet var buttonApply: UIButton!
    @IBOutlet var orderSegmentedControl: UISegmentedControl!
    @IBOutlet var launchStatusSegmentedControl: UISegmentedControl!

    @IBOutlet var orderByLabel: UILabel!
    @IBOutlet var launchStatusLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        applyLocalization()
        applyButtonCustomization()
    }

    @IBAction func buttonApplyTapped(_ sender: Any) {
        let order: Order = orderSegmentedControl.selectedSegmentIndex == 0 ? .ascending : .descending
        var launchSuccess: Bool?

        if launchStatusSegmentedControl.selectedSegmentIndex == 0 {
            launchSuccess = true
        } else if launchStatusSegmentedControl.selectedSegmentIndex == 1 {
            launchSuccess = false
        }

        delegate?.applyFilter(year: selectedYears.map { $0.labelFilterName.text! }, order: order, launchSuccess: launchSuccess)
        navigationController?.popViewController(animated: true)
    }

    private func applyLocalization() {
        let bundle = Bundle(for: FilterViewController.self)

        orderByLabel.text = NSLocalizedString("FILTER_VIEW_ORDER", tableName: "Launch", bundle: bundle, comment: "")
        launchStatusLabel.text = NSLocalizedString("FILTER_VIEW_LAUNCH_STATUS", tableName: "Launch", bundle: bundle, comment: "")
        yearLabel.text = NSLocalizedString("FILTER_VIEW_YEAR", tableName: "Launch", bundle: bundle, comment: "")

        title = NSLocalizedString("FILTER_VIEW_TITLE", tableName: "Launch", bundle: bundle, comment: "")

        orderSegmentedControl.setTitle(NSLocalizedString("FILTER_VIEW_ORDER_OPTION_0", tableName: "Launch", bundle: bundle, comment: ""), forSegmentAt: 0)
        orderSegmentedControl.setTitle(NSLocalizedString("FILTER_VIEW_ORDER_OPTION_1", tableName: "Launch", bundle: bundle, comment: ""), forSegmentAt: 1)

        launchStatusSegmentedControl.setTitle(NSLocalizedString("FILTER_VIEW_LAUNCH_OPTION_0", tableName: "Launch", bundle: bundle, comment: ""), forSegmentAt: 0)
        launchStatusSegmentedControl.setTitle(NSLocalizedString("FILTER_VIEW_LAUNCH_OPTION_1", tableName: "Launch", bundle: bundle, comment: ""), forSegmentAt: 1)

        buttonApply.setTitle(NSLocalizedString("FILTER_VIEW_BUTTON", tableName: "Launch", bundle: bundle, comment: ""), for: .normal)
    }

    private func applyButtonCustomization() {
        buttonApply.backgroundColor = .black
        buttonApply.setTitleColor(.white, for: .normal)
        buttonApply.layer.cornerRadius = 25
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return years.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterViewCell else { return UICollectionViewCell() }

        cell.labelFilterName.text = years[indexPath.item]
        if cell.cellSelected {
            cell.labelFilterName.textColor = .white
            cell.viewFilter.backgroundColor = .black
        } else {
            cell.labelFilterName.textColor = .black
            cell.viewFilter.backgroundColor = .white
        }
        cell.tag = indexPath.row
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FilterViewCell
        if cell.cellSelected {
            if let index = selectedYears.firstIndex(of: cell) {
                selectedYears.remove(at: index)
            }

            cell.cellSelected = false
            cell.labelFilterName.textColor = .black
            cell.viewFilter.backgroundColor = .white
        } else {
            selectedYears.append(cell)
            cell.cellSelected = true
            cell.labelFilterName.textColor = .white
            cell.viewFilter.backgroundColor = .black
        }
    }
}
