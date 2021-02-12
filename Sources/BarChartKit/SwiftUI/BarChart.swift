import SwiftUI

/// Creates a Bar Chart similar to the chart used in iOS Health app
public struct BarChart: View {
    // MARK: Structs
    /// Provides data for the BarChart
    public struct DataSet {
        /// Single data element for BarChart. Can consist of multiple bars
        public struct DataElement {
            /// Single bar to be displayed in the BarChart
            public struct Bar {
                /// Any floating point number to be represented in the bar
                public let value: Double
                /// Default color for the bar in not selected state
                public let color: Color

                /// Create a single bar to be displayed in the BarChart
                /// - Parameters:
                ///   - value: Any floating point number to be represented in the bar
                ///   - color: Default color for the bar in not selected state
                public init(value: Double, color: Color) {
                    self.value = value
                    self.color = color
                }
            }

            public let date: Date?
            public let xLabel: String
            public let bars: [Bar]

            /// Create a new data element grouped by common value on the x axis, containing one or more bars.
            /// - Parameters:
            ///   - date: Date for the element
            ///   - xLabel: Label to display on the x axis
            ///   - bars: Bars to be shown as part of thie element
            public init(date: Date?, xLabel: String, bars: [BarChart.DataSet.DataElement.Bar]) {
                self.date = date
                self.xLabel = xLabel
                self.bars = bars
            }
        }

        public let elements: [DataElement]
        public let selectionColor: Color?

        /// Create a set of data to be displayed in the BarChart
        /// - Parameters:
        ///   - elements: Data to be displayed
        ///   - selectionColor: Color of the bars when in selected state
        public init(elements: [BarChart.DataSet.DataElement], selectionColor: Color?) {
            self.elements = elements
            self.selectionColor = selectionColor
        }
    }

    public let dataSet: DataSet
    @Binding public var selectedElement: DataSet.DataElement?
    public let barWidth: CGFloat

    private var maxDataSetValue: Double {
        dataSet.elements.flatMap { $0.bars.map { $0.value } }.max() ?? Double.leastNonzeroMagnitude
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ForEach(dataSet.elements) { element in
                VStack {
                    HStack {
                        ForEach(element.bars) { bar in
                            GeometryReader { geometry in
                                VStack {
                                        Rectangle()
                                            .frame(width: barWidth, height: self.height(for: bar, viewHeight: geometry.size.height, maxValue: self.maxDataSetValue))
                                            .cornerRadius(barWidth / 2, antialiased: false)
                                            .foregroundColor(self.selectedElement == element ? self.dataSet.selectionColor ?? bar.color : bar.color)
                                }
                                .frame(maxWidth: .infinity, maxHeight: geometry.size.height, alignment: .bottom)
                            }
                        }
                    }
                    .onTapGesture {
                        self.selectedElement = element
                    }
                    Text(element.xLabel)
                        .font(.system(size: 10))
                        .lineLimit(1)
                }
            }
        }
    }

    /// Create a BarChart similar to the one used in the Health app
    /// - Parameters:
    ///   - dataSet: Data to be displayed
    ///   - selectedElement: Element that has been selected by the user by tapping
    public init(dataSet: BarChart.DataSet, selectedElement: Binding<DataSet.DataElement?>, barWidth: CGFloat = 6) {
        self.dataSet = dataSet
        self._selectedElement = selectedElement
        self.barWidth = barWidth
    }

    private func height(for bar: DataSet.DataElement.Bar, viewHeight: CGFloat, maxValue: Double) -> CGFloat {
        let height = viewHeight * CGFloat(bar.value / self.maxDataSetValue)

        if height < barWidth {
            return barWidth
        } else if height >= viewHeight {
            return viewHeight
        } else {
            return height
        }
    }
}

extension BarChart.DataSet.DataElement: Identifiable {
    public var id: String {
        xLabel
    }
}

extension BarChart.DataSet.DataElement: Equatable {
    public static func == (lhs: BarChart.DataSet.DataElement, rhs: BarChart.DataSet.DataElement) -> Bool {
        lhs.id == rhs.id
    }
}

extension BarChart.DataSet.DataElement.Bar: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}

extension BarChart.DataSet.DataElement.Bar: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
// swiftlint:disable all
fileprivate var mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [
    BarChart.DataSet.DataElement(date: nil, xLabel: "Jan", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green),
                                                          BarChart.DataSet.DataElement.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Feb", bars: [BarChart.DataSet.DataElement.Bar(value: 0, color: Color.green)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Mar", bars: [BarChart.DataSet.DataElement.Bar(value: 10000, color: Color.green),
                                                          BarChart.DataSet.DataElement.Bar(value: 5000, color: Color.red)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Apr", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green),
                                                          BarChart.DataSet.DataElement.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "May", bars: [BarChart.DataSet.DataElement.Bar(value: 42000, color: Color.green),
                                                          BarChart.DataSet.DataElement.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Jun", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Jul", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green),
                                                          BarChart.DataSet.DataElement.Bar(value: 0.5555, color: Color.blue)])
    ], selectionColor: Color.yellow)
// swiftlint:enable all

struct ParentView: View {
    @State private var selectedElement: BarChart.DataSet.DataElement? = mockBarChartDataSet.elements.first

    var body: some View {
        VStack(spacing: 10) {
            BarChart(dataSet: mockBarChartDataSet,
                     selectedElement: $selectedElement,
                     barWidth: 16)
    //            .previewLayout(.sizeThatFits)
                .previewLayout(PreviewLayout.fixed(width: 200, height: 118))
            Text("Selected element \(selectedElement?.xLabel ?? "none")")
        }
        .padding()
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}
#endif
