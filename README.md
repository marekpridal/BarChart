# BarChartKit

UIKit / SwiftUI library for creating Bar Chart similar to chart used in iOS Health app.

![Bar Chart screenshot](Resources/Screenshots/BarChart_1.jpg)

## Requirements
- iOS 13.0+ 
- watchOS 6.0+
- macOS 10.15+

## Installation

#### BarChartKit supports [XCFramework](https://developer.apple.com/videos/play/wwdc2019/416/) integration into Xcode project. Just go to [Release page](https://github.com/marekpridal/BarChart/releases), download latest version, drag and drop it into existing Xcode project and you are done 🎉

BarChartKit also supports SwiftPM. You can integrate BarChartKit using SwiftPM directly via Xcode or manually using Package.swift.

### [Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

To add a package dependency to your Xcode project, select File > Swift Packages > Add Package Dependency and enter its repository URL. You can also navigate to your target’s General pane, and in the “Frameworks, Libraries, and Embedded Content” section, click the + button. In the “Choose frameworks and libraries to add” dialog, select Add Other, and choose Add Package Dependency.

Instead of adding a repository URL, you can search for a package on [GitHub](https://github.com/) or [GitHub Enterprise](https://github.com/enterprise). Add your [GitHub](https://github.com/) or [GitHub Enterprise](https://github.com/enterprise) account in Xcode’s preferences, and a list of package repositories appears as you type. The following screenshot shows the list of repositories for the search term ExamplePackage.

## Usage

### UIKit
```swift
import BarChartKit

let mockBarChartDataSet: BarChartView.DataSet? = BarChartView.DataSet(elements: [
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


let barChart = BarChartView()
barChart.dataSet = mockBarChartDataSet

view.addSubview(barChart)
barChart.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    barChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    barChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    barChart.topAnchor.constraint(equalTo: view.topAnchor),
    barChart.bottomAnchor.constraint(equalTo: view.bottomAnchor)
])
```

### SwiftUI
```swift
import BarChartKit

@State private var selectedElement: BarChart.DataSet.DataElement? = mockBarChartDataSet.elements.first

let mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [
    BarChart.DataSet.DataElement(date: nil, xLabel: "Jan", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green, selectionColor: Color.yellow),
                                                          BarChart.DataSet.DataElement.Bar(value: 15000, color: Color.blue, selectionColor: Color.yellow)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Feb", bars: [BarChart.DataSet.DataElement.Bar(value: 0, color: Color.green)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Mar", bars: [BarChart.DataSet.DataElement.Bar(value: 10000, color: Color.green),
                                                          BarChart.DataSet.DataElement.Bar(value: 5000, color: Color.red)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Apr", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green),
                                                          BarChart.DataSet.DataElement.Bar(value: 15000, color: Color.blue)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "May", bars: [BarChart.DataSet.DataElement.Bar(value: 42000, color: Color.green, selectionColor: Color.red),
                                                          BarChart.DataSet.DataElement.Bar(value: 15000, color: Color.blue, selectionColor: Color.yellow)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Jun", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green, selectionColor: Color.yellow)]),
    BarChart.DataSet.DataElement(date: nil, xLabel: "Jul", bars: [BarChart.DataSet.DataElement.Bar(value: 20000, color: Color.green, selectionColor: Color.yellow),
                                                          BarChart.DataSet.DataElement.Bar(value: 0.5555, color: Color.blue, selectionColor: Color.red)])
    ])


BarChart(dataSet: mockBarChartDataSet, selectedElement: $selectedElement)
```
