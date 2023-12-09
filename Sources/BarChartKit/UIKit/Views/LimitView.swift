//
//  LimitView.swift
//  
//
//  Created by Marek Přidal on 18/10/2020.
//

#if os(iOS) || os(visionOS)
import UIKit

final class LimitView: UIView {
    lazy var label: LimitLabel = {
        .init()
    }()

    var strokeColor: UIColor {
        get {
            UIColor(cgColor: dashedView.strokeColor)
        }
        set {
            dashedView.strokeColor = newValue.cgColor
        }
    }

    private lazy var dashedView: DashedView = {
        .init()
    }()

    // MARK: - Init
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    // MARK: - Override
#if os(iOS)
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
#endif
    private func commonInit() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 16),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15)
        ])

        addSubview(dashedView)
        dashedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dashedView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
            dashedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dashedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dashedView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            dashedView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

#if DEBUG
import SwiftUI

struct LimitViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let limitView = LimitView()
            limitView.label.text = "YOUR LIMIT"
            return limitView
        }
        .previewLayout(.fixed(width: 375, height: 20))
    }
}

#endif
#endif
