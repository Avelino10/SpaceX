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
    func applyFilter(year: [String], order: Order)
}

class FilterViewController: UIViewController {
    public var years = [String]()
    private var selectedYears = [FilterViewCell]()
    private var selectedOrder: Order = .ascending
    public weak var delegate: FilterDelegate?

    @IBOutlet var collectionViewFilter: UICollectionView!
    @IBOutlet var buttonApply: UIButton!
    @IBOutlet var orderSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonApplyTapped(_ sender: Any) {
        let order: Order = orderSegmentedControl.selectedSegmentIndex == 0 ? .ascending : .descending
        delegate?.applyFilter(year: selectedYears.map { $0.labelFilterName.text! }, order: order)
        dismiss(animated: true)
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

class FilterViewCell: UICollectionViewCell {
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var labelFilterName: UILabel!

    public var cellSelected: Bool = false

    override func awakeFromNib() {
        viewFilter.addBlackBorderAndCorner()
    }
}

private extension UIView {
    func addBlackBorderAndCorner() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5
    }
}
