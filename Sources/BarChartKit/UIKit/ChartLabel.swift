//
//  ChartLabel.swift
//
//  Created by Marek Přidal on 01/01/2020.
//  Copyright © 2020 Marek Pridal. All rights reserved.
//
#if os(iOS)
import UIKit

final class ChartLabel: UILabel {
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
        font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
}
#endif
