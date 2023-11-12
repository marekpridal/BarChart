//
//  BarChartView.swift
//
//  Created by Marek Pridal on 22/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol BarChartViewDelegate: AnyObject {
    func didSelect(dataElement: BarChartView.DataSet.DataElement, dataSet: BarChartView.DataSet)
}

public final class BarChartView: UIView {

    // MARK: Structs
    public struct DataSet: Equatable {
        public struct DataElement: Equatable {
            public struct Bar: Equatable {
                public let value: Double
                public let color: UIColor
                public let selectionColor: UIColor

                public init(value: Double, color: UIColor, selectionColor: UIColor) {
                    self.value = value
                    self.color = color
                    self.selectionColor = selectionColor
                }
            }

            public static func == (lhs: BarChartView.DataSet.DataElement, rhs: BarChartView.DataSet.DataElement) -> Bool {
                return lhs.bars == rhs.bars &&
                       lhs.xLabel == rhs.xLabel
            }

            public let date: Date?
            public let xLabel: String
            public let bars: [Bar]

            public init(date: Date?, xLabel: String, bars: [BarChartView.DataSet.DataElement.Bar]) {
                self.date = date
                self.xLabel = xLabel
                self.bars = bars
            }
        }

        public struct Limit: Equatable {
            public let color: UIColor
            public let label: String?
            public let value: Double

            public init(color: UIColor, label: String?, value: Double) {
                self.color = color
                self.label = label
                self.value = value
            }
        }

        public let elements: [DataElement]
        public let limit: Limit?

        public init(elements: [BarChartView.DataSet.DataElement], limit: Limit? = nil) {
            self.elements = elements
            self.limit = limit
        }
    }

    private struct ElementView {
        let bars: [UIView]
    }

    // MARK: - Public properties
    public var dataSet: DataSet? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }

    public var barWidth: CGFloat = 6 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }

    public weak var delegate: BarChartViewDelegate?

    // MARK: - Private properties
    private let chartStackView = UIStackView()
    private var elementViews: [ElementView] = []
    private var graphInConstruction = false

    // MARK: - Init
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    // MARK: - Override
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    public override func layoutSubviews() {
        guard let dataSet = dataSet else { return }
        constructGraph(dataSet: dataSet)
    }

    // MARK: Public func
    public func select(element: DataSet.DataElement) {
        guard let elementIndex = dataSet?.elements.firstIndex(where: { element == $0 }) else { return }
        select(index: elementIndex)
    }

    public func select(index: Int) {
        deselectAll()
        let dataElement = dataSet?.elements.safe(at: index)
        elementViews.safe(at: index)?.bars.enumerated().forEach({ offsetElementView, elementView in
            elementView.backgroundColor = dataElement?.bars.safe(at: offsetElementView)?.selectionColor
        })
    }

    public func deselectAll() {
        elementViews.enumerated().forEach { arg in
            let (offsetElementView, elementView) = arg

            elementView.bars.enumerated().forEach({ arg in
                let (offsetBar, element) = arg
                guard let color = dataSet?.elements.safe(at: offsetElementView)?.bars.safe(at: offsetBar)?.color else { return }
                element.backgroundColor = color
            })
        }
    }

    // MARK: - Private funcs
    private func commonInit() {
        addSubview(chartStackView)
        chartStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            chartStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            chartStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        chartStackView.distribution = .equalCentering
    }

    private func constructGraph(dataSet: DataSet) {
        guard !graphInConstruction else { return }
        graphInConstruction = true
        defer {
            graphInConstruction = false
        }
        chartStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        chartStackView.subviews.forEach { $0.removeFromSuperview() }
        elementViews.removeAll()

        var values = dataSet.elements.map { $0.bars.map { $0.value } }.flatMap { $0 }
        if let limit = dataSet.limit {
            values.append(limit.value)
        }

        let maxValue = values.max() ?? 0.0

        dataSet.elements.forEach { element in
            let parentView = BarParentControl()
            parentView.isUserInteractionEnabled = true
            chartStackView.addArrangedSubview(parentView)

            let label = ChartLabel()
            add(label: label, parentView: parentView, element: element, dataSet: dataSet)

            let barStackView = UIStackView()
            barStackView.isUserInteractionEnabled = false
            add(barStackView: barStackView, label: label, parentView: parentView, element: element)

            let barViews = element.bars.compactMap { bar -> UIView in
                let view = UIView()
                view.isUserInteractionEnabled = false

                return add(barView: view, barStackView: barStackView, bar: bar, maxValue: maxValue)
            }
            elementViews.append(BarChartView.ElementView(bars: barViews))
        }

        // If limit is set, get parent view of element. It has same dimension for all bars  and is transparent.
        // It occupies space between ChartLabel and top of ChartStackView and is background of each bar.
        if let limit = dataSet.limit, let elementParentView = elementViews.first?.bars.first?.superview {
            draw(limit: limit, elementParentView: elementParentView, maxValue: CGFloat(maxValue))
        }

        guard let firstNonZeroElement = Array(dataSet.elements.reversed()).first(where: { !$0.bars.filter({ $0.value > 0 }).isEmpty }) else { return }
        select(element: firstNonZeroElement)
    }

    private func draw(limit: DataSet.Limit, elementParentView: UIView, maxValue: CGFloat) {
        elementParentView.setNeedsLayout()
        elementParentView.layoutIfNeeded()

        let point = elementParentView.bounds.size.height / maxValue

        var bottomPadding = CGFloat(limit.value) * point

        let limitView = LimitView()
        limitView.label.text = limit.label
        limitView.label.textColor = limit.color
        limitView.strokeColor = limit.color
        chartStackView.addSubview(limitView)
        limitView.translatesAutoresizingMaskIntoConstraints = false

        if bottomPadding < barWidth {
            bottomPadding = barWidth
        }

        NSLayoutConstraint.activate([
            limitView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            limitView.bottomAnchor.constraint(equalTo: elementParentView.bottomAnchor, constant: -bottomPadding),
            limitView.leadingAnchor.constraint(equalTo: chartStackView.leadingAnchor),
            limitView.trailingAnchor.constraint(equalTo: chartStackView.trailingAnchor)
        ])
    }

    private func add(label: ChartLabel, parentView: BarParentControl, element: DataSet.DataElement, dataSet: DataSet) {
        label.text = element.xLabel
        parentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])

        parentView.touchHandler = { [weak self] in
            self?.delegate?.didSelect(dataElement: element, dataSet: dataSet)
        }
    }

    private func add(barStackView: UIStackView, label: ChartLabel, parentView: UIView, element: DataSet.DataElement) {
        barStackView.distribution = .equalSpacing
        barStackView.spacing = 5
        parentView.addSubview(barStackView)
        barStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barStackView.topAnchor.constraint(equalTo: parentView.topAnchor),
            barStackView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10),
            barStackView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor)
        ])
    }

    private func add(barView: UIView, barStackView: UIStackView, bar: DataSet.DataElement.Bar, maxValue: Double) -> UIView {
        let divider: Double = maxValue / bar.value
        let barParentView = UIView()
        barParentView.isUserInteractionEnabled = false
        barStackView.addArrangedSubview(barParentView)
        barParentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barParentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            barParentView.widthAnchor.constraint(equalToConstant: barWidth)
        ])

        barView.layer.cornerRadius = barWidth / 2
        barView.backgroundColor = bar.color
        barParentView.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barView.bottomAnchor.constraint(equalTo: barParentView.bottomAnchor),
            barView.trailingAnchor.constraint(equalTo: barParentView.trailingAnchor),
            barView.leadingAnchor.constraint(equalTo: barParentView.leadingAnchor)
        ])
        if (self.frame.size.height / 1.3) / CGFloat(divider) < barWidth || maxValue < 1 {
            barView.heightAnchor.constraint(equalToConstant: barWidth).isActive = true
        } else if self.frame.size.height / CGFloat(divider) > superview?.frame.size.height ?? 0.0 {
            barView.heightAnchor.constraint(equalTo: barParentView.heightAnchor).isActive = true
        } else {
            barView.heightAnchor.constraint(equalTo: barParentView.heightAnchor, multiplier: CGFloat(1 / divider)).isActive = true
        }

        return barView
    }
}

#if DEBUG
// swiftlint:disable all
fileprivate var mockBarChartDataSet: BarChartView.DataSet? = BarChartView.DataSet(elements: [
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Jan", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0)),
                                                              BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0))]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Feb", bars: [BarChartView.DataSet.DataElement.Bar(value: 0, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0))]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Mar", bars: [BarChartView.DataSet.DataElement.Bar(value: 10000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0)),
                                                              BarChartView.DataSet.DataElement.Bar(value: 5000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0))]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Apr", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0)),
                                                              BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0))]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "May", bars: [BarChartView.DataSet.DataElement.Bar(value: 32010, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0)),
                                                              BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0))]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Jun", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor(red: 214/255, green: 40/255, blue: 57/255, alpha: 1.0))]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Jul", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor.systemGreen),
                                                                      BarChartView.DataSet.DataElement.Bar(value: 10000, color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), selectionColor: UIColor.systemBlue)])
], limit: .init(color: UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1.0), label: "YOUR LIMIT", value: 15_010))
// swiftlint:enable all

import SwiftUI

struct BarChartPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let barChart = BarChartView()
            barChart.dataSet = mockBarChartDataSet
            return barChart
        }
        .padding()
        .previewLayout(.fixed(width: 375, height: 172))
    }
}
#endif
#endif
