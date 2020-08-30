//
//  BarChartView.swift
//  MyExpenses
//
//  Created by Marek Pridal on 22/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol BarChartViewDelegate: class {
    func didSelect(dataElement: BarChartView.DataSet.DataElement, dataSet: BarChartView.DataSet)
}

public final class BarChartView: UIView {

    // MARK: Structs
    public struct DataSet: Equatable {
        public struct DataElement: Equatable {
            public struct Bar: Equatable {
                public let value: Double
                public let color: UIColor
            }

            public static func == (lhs: BarChartView.DataSet.DataElement, rhs: BarChartView.DataSet.DataElement) -> Bool {
                return lhs.bars == rhs.bars &&
                       lhs.xLabel == rhs.xLabel
            }

            public let date: Date?
            public let xLabel: String
            public let bars: [Bar]
        }

        public let elements: [DataElement]
        public let selectionColor: UIColor?
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
        elementViews.safe(at: index)?.bars.forEach { $0.backgroundColor = dataSet?.selectionColor }
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
        elementViews.removeAll()

        let maxValue = dataSet.elements.map { $0.bars.map { $0.value } }.flatMap { $0 }.max() ?? 0.0

        dataSet.elements.forEach { element in
            let parentView = UIView()
            chartStackView.addArrangedSubview(parentView)

            let label = ChartLabel()
            add(label: label, parentView: parentView, element: element, dataSet: dataSet)

            let barStackView = UIStackView()
            add(barStackView: barStackView, label: label, parentView: parentView, element: element)

            let barViews = element.bars.compactMap { add(barView: UIView(), barStackView: barStackView, bar: $0, maxValue: maxValue) }
            elementViews.append(BarChartView.ElementView(bars: barViews))
        }
        guard let firstNonZeroElement = Array(dataSet.elements.reversed()).first(where: { !$0.bars.filter({ $0.value > 0 }).isEmpty }) else { return }
        select(element: firstNonZeroElement)
    }

    private func add(label: ChartLabel, parentView: UIView, element: DataSet.DataElement, dataSet: DataSet) {
        label.text = element.xLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        parentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])

        parentView.addTapGestureRecognizer { [weak self] in
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
        barStackView.addArrangedSubview(barParentView)
        barParentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barParentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            barParentView.widthAnchor.constraint(equalToConstant: 6)
        ])

        let barView = UIView()
        barView.layer.cornerRadius = 3
        barView.backgroundColor = bar.color
        barParentView.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barView.bottomAnchor.constraint(equalTo: barParentView.bottomAnchor),
            barView.trailingAnchor.constraint(equalTo: barParentView.trailingAnchor),
            barView.leadingAnchor.constraint(equalTo: barParentView.leadingAnchor)
        ])
        if (self.frame.size.height / 1.3) / CGFloat(divider) < 6 || maxValue < 1 {
            barView.heightAnchor.constraint(equalToConstant: 6).isActive = true
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
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Jan", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green),
                                                              BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor.blue)]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Feb", bars: [BarChartView.DataSet.DataElement.Bar(value: 0, color: UIColor.green)]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Mar", bars: [BarChartView.DataSet.DataElement.Bar(value: 10000, color: UIColor.green),
                                                              BarChartView.DataSet.DataElement.Bar(value: 5000, color: UIColor.blue)]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Apr", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green),
                                                              BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor.blue)]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "May", bars: [BarChartView.DataSet.DataElement.Bar(value: 32000, color: UIColor.green),
                                                              BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor.blue)]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Jun", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green)]),
    BarChartView.DataSet.DataElement(date: nil, xLabel: "Jul", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green),
                                                              BarChartView.DataSet.DataElement.Bar(value: 0.5555, color: UIColor.blue)])
    ], selectionColor: UIColor.yellow)
// swiftlint:enable all

import SwiftUI

struct BarChartPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let barChart = BarChartView()
            barChart.dataSet = mockBarChartDataSet
            return barChart
        }
        .padding(10)
        .previewLayout(.sizeThatFits)
    }
}
#endif
#endif
