//
//  FilterViewCell.swift
//  SpaceXiOS
//
//  Created by Avelino Rodrigues on 23/09/2021.
//

import UIKit

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
