
import SwiftUI

public struct BarChart: View {
    // MARK: Structs
    public struct Bar: Equatable, Identifiable {
        public let value: Double
        public let color: Color

        public var id: String {
            UUID().uuidString
        }
    }

    public struct DataElement: Equatable, Identifiable {
        public var id: String {
            xLabel
        }

        public static func == (lhs: DataElement, rhs: DataElement) -> Bool {
            return lhs.bars == rhs.bars &&
                   lhs.xLabel == rhs.xLabel
        }

        public let date: Date?
        public let xLabel: String
        public let bars: [Bar]
    }

    public struct DataSet: Equatable {
        public let elements: [DataElement]
        public let selectionColor: Color?
    }

    public let dataSet: DataSet
    @Binding public var selectedElement: DataElement

    private var maxDataSetValue: Double {
        dataSet.elements.flatMap { $0.bars.map { $0.value } }.max() ?? Double.leastNonzeroMagnitude
    }

    public var body: some View {
        HStack {
            ForEach(dataSet.elements) { element in
                VStack {
                    HStack {
                        ForEach(element.bars) { bar in
                            GeometryReader { geometry in
                                VStack() {
                                    Spacer()
                                        Rectangle()
                                            .frame(width: 6, height: self.height(for: bar, viewHeight: geometry.size.height, maxValue: self.maxDataSetValue))
                                            .cornerRadius(3, antialiased: false)
                                            .foregroundColor(bar.color)
                                }
                                .frame(height: geometry.size.height, alignment: .bottom)
                            }
                        }
                    }
                    Text(element.xLabel)
                }
            }
        }
    }

    private func height(for bar: Bar, viewHeight: CGFloat, maxValue: Double) -> CGFloat {
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
    BarChart.DataElement(date: nil, xLabel: "Jan", bars: [BarChart.Bar(value: 20000, color: Color.green),
                                            BarChart.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataElement(date: nil, xLabel: "Feb", bars: [BarChart.Bar(value: 0, color: Color.green)]),
    BarChart.DataElement(date: nil, xLabel: "Mar", bars: [BarChart.Bar(value: 10000, color: Color.green),
                                            BarChart.Bar(value: 5000, color: Color.red)]),
    BarChart.DataElement(date: nil, xLabel: "Apr", bars: [BarChart.Bar(value: 20000, color: Color.green),
                                            BarChart.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataElement(date: nil, xLabel: "May", bars: [BarChart.Bar(value: 42000, color: Color.green),
                                            BarChart.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataElement(date: nil, xLabel: "Jun", bars: [BarChart.Bar(value: 20000, color: Color.green)]),
    BarChart.DataElement(date: nil, xLabel: "Jul", bars: [BarChart.Bar(value: 20000, color: Color.green),
                                            BarChart.Bar(value: 0.5555, color: Color.blue)])
    ], selectionColor: Color.yellow)
// swiftlint:enable all

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(dataSet: mockBarChartDataSet, selectedElement: Binding<BarChart.DataElement>(get: { () -> BarChart.DataElement in
            .init(date: nil, xLabel: "Jul", bars: [BarChart.Bar(value: 20000, color: .green),
                                                   BarChart.Bar(value: 0.5555, color: .blue)])
        }, set: { (_) in
            // DEBUG
        }))
            .padding(10)
//            .previewLayout(.sizeThatFits)
            .previewLayout(PreviewLayout.fixed(width: 200, height: 118))
    }
}
#endif
