//
//  LimitLabel.swift
//  
//
//  Created by Marek Přidal on 18/10/2020.
//

#if os(iOS)
import UIKit

final class LimitLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        font = UIFont.systemFont(ofSize: 10, weight: .medium)
    }
}

#endif
