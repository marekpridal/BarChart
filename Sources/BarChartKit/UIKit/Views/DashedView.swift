//
//  DashedView.swift
//  
//
//  Created by Marek Přidal on 18/10/2020.
//

#if os(iOS) || os(visionOS)
import UIKit

final class DashedView: UIView {
    private var dashedLayer: CAShapeLayer?

    var strokeColor: CGColor = UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0).cgColor {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()

        dashedLayer?.removeFromSuperlayer()

        // Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [3, 5]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: frame.height / 2), CGPoint(x: frame.width, y: frame.height / 2)])

        shapeLayer.path = path
        shapeLayer.fillColor = UIColor.clear.cgColor

        layer.addSublayer(shapeLayer)
        dashedLayer = shapeLayer
    }
}

#if DEBUG
import SwiftUI

struct DashedViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let dashedView = DashedView()
            return dashedView
        }
        .previewLayout(.fixed(width: 375, height: 3))
    }
}

#endif
#endif
