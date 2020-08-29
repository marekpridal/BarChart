
import SwiftUI

struct BarChart: View {
    // MARK: Structs
    public struct Bar: Equatable {
        public let value: Double
        public let color: Color
    }

    public struct DataElement: Equatable {
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

    let dataSet: DataSet
    @Binding var selectedElement: DataElement

    var body: some View {
        Text("Hello World")
    }
}

#if DEBUG
// swiftlint:disable all
fileprivate var mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [
    BarChart.DataElement(date: nil, xLabel: "Jan", bars: [BarChart.Bar(value: 20000, color: Color.green),
                                            BarChart.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataElement(date: nil, xLabel: "Feb", bars: [BarChart.Bar(value: 0, color: Color.green)]),
    BarChart.DataElement(date: nil, xLabel: "Mar", bars: [BarChart.Bar(value: 10000, color: Color.green),
                                            BarChart.Bar(value: 5000, color: Color.blue)]),
    BarChart.DataElement(date: nil, xLabel: "Apr", bars: [BarChart.Bar(value: 20000, color: Color.green),
                                            BarChart.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataElement(date: nil, xLabel: "May", bars: [BarChart.Bar(value: 32000, color: Color.green),
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
            .previewLayout(.sizeThatFits)
    }
}
#endif
