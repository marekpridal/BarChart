import SwiftUI

public struct BarChart: View {

    // MARK: Structs
    public struct DataSet {
        public struct DataElement: Equatable, Identifiable {
            public static func == (lhs: BarChart.DataSet.DataElement, rhs: BarChart.DataSet.DataElement) -> Bool {
                lhs.id == rhs.id
            }

            public struct Bar: Identifiable {
                public let value: Double
                public let color: Color

                public var id: String {
                    UUID().uuidString
                }

                public init(value: Double, color: Color) {
                    self.value = value
                    self.color = color
                }
            }

            public var id: String {
                xLabel
            }

            public let date: Date?
            public let xLabel: String
            public let bars: [Bar]

            public init(date: Date?, xLabel: String, bars: [BarChart.DataSet.DataElement.Bar]) {
                self.date = date
                self.xLabel = xLabel
                self.bars = bars
            }
        }

        public let elements: [DataElement]
        public let selectionColor: Color?

        public init(elements: [BarChart.DataSet.DataElement], selectionColor: Color?) {
            self.elements = elements
            self.selectionColor = selectionColor
        }
    }

    public let dataSet: DataSet
    @State public var selectedElement: DataSet.DataElement?

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
                                    Spacer()
                                        Rectangle()
                                            .frame(width: 6, height: self.height(for: bar, viewHeight: geometry.size.height, maxValue: self.maxDataSetValue))
                                            .cornerRadius(3, antialiased: false)
                                            .foregroundColor(self.selectedElement == element ? self.dataSet.selectionColor ?? bar.color : bar.color)
                                }
                                .frame(height: geometry.size.height, alignment: .bottom)
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

    public init(dataSet: BarChart.DataSet, selectedElement: State<DataSet.DataElement?>) {
        self.dataSet = dataSet
        self._selectedElement = selectedElement
    }

    private func height(for bar: DataSet.DataElement.Bar, viewHeight: CGFloat, maxValue: Double) -> CGFloat {
        let height = viewHeight * CGFloat(bar.value / self.maxDataSetValue)

        if height < 6.0 {
            return 6.0
        } else if height >= viewHeight {
            return viewHeight
        } else {
            return height
        }
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

struct BarChart_Previews: PreviewProvider {
    @State static var selectedElement: BarChart.DataSet.DataElement? = mockBarChartDataSet.elements.first

    static var previews: some View {
        BarChart(dataSet: mockBarChartDataSet, selectedElement: _selectedElement)
            .padding(5)
//            .previewLayout(.sizeThatFits)
            .previewLayout(PreviewLayout.fixed(width: 200, height: 118))
    }
}
#endif
