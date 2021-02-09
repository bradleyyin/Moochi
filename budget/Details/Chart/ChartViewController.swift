//
//  ViewController.swift
//  budget
//
//  Created by Bradley Yin on 10/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
//import ScrollableGraphView
import Charts
import RxSwift
import RealmSwift

class ChartViewController: UIViewController {

    var expensesTableView: UITableView!

    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    private var viewModel: ChartViewModel
    //weak var delegate: AddEntryViewControllerDelegate?

    init(category: Category, dependency: Dependency) {
        self.dependency = dependency
        self.viewModel = ChartViewModel(category: category, dependency: dependency)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(chartView)
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(seperatorView)

        setupConstraints()
        updateChartData()
        //NotificationCenter.default.addObserver(self, selector: #selector(loadExpenses), name: NSNotification.Name("changedEntry"), object: nil)
        // Do any additional setup after loading the view.
    }

    private func setupBinding() {

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupUI()
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(top)
            make.leading.equalToSuperview()
            make.height.width.equalTo(42)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }

        chartView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(209)
        }

        seperatorView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(chartView.snp.bottom)
            make.height.equalTo(1)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(seperatorView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func setupUI() {
//        if traitCollection.userInterfaceStyle == .light {
//            view.backgroundColor = .white
//            titleLabel.textColor = .black
//            backButton.tintColor = .black
//        } else {
//            view.backgroundColor = .black
//            titleLabel.textColor = .white
//            backButton.tintColor = .white
//        }
//        setupGraph()
//        setupConstraint()
    }

    private func setup(_ dataSet: LineChartDataSet) {
        //if dataSet.isDrawLineWithGradientEnabled {
        dataSet.mode = .cubicBezier
            dataSet.lineDashLengths = nil
            dataSet.highlightLineDashLengths = nil
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
            dataSet.setColors(.black)
            dataSet.setCircleColor(.black)
            //dataSet.gradientPositions = [0, 40, 100]
        dataSet.fillAlpha = 1
        dataSet.fillColor = UIColor.black.withAlphaComponent(0.5)
        dataSet.drawFilledEnabled = true
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
        dataSet.drawValuesEnabled = false
            dataSet.formLineDashLengths = nil
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
//        } else {
//            dataSet.lineDashLengths = [5, 2.5]
//            dataSet.highlightLineDashLengths = [5, 2.5]
//            dataSet.setColor(.black)
//            dataSet.setCircleColor(.black)
//            dataSet.gradientPositions = nil
//            dataSet.lineWidth = 1
//            dataSet.circleRadius = 3
//            dataSet.drawCircleHoleEnabled = false
//            dataSet.valueFont = .systemFont(ofSize: 9)
//            dataSet.formLineDashLengths = [5, 2.5]
//            dataSet.formLineWidth = 1
//            dataSet.formSize = 15
//        }
    }

    private func updateChartData() {
//        if self.shouldHideData {
//            chartView.data = nil
//            return
//        }

        self.setDataCount(Int(70), range: UInt32(100))
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "unselected_home"))
        }

        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        setup(set1)

        let value = ChartDataEntry(x: Double(3), y: 3)
        set1.addEntryOrdered(value)
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

//        set1.fillAlpha = 1
//        set1.fillColor = UIColor.black.withAlphaComponent(0.5)
//        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)

        chartView.data = data
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = false
        chartView.setVisibleXRangeMaximum(8)
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = TitleLabel()
        label.text = viewModel.screenTitleText
        label.textAlignment = .right
        return label
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(ChartTableViewCell.self, forCellReuseIdentifier: "expenseChartCell")
        view.separatorStyle = .none
        //view.allowsSelection = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.delegate = self

        //view.chartDescription.enabled = false
//        view.dragEnabled = true
//        view.setScaleEnabled(true)
//        view.pinchZoomEnabled = true
//
//        // x-axis limit line
//        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
//        llXAxis.lineWidth = 4
//        llXAxis.lineDashLengths = [10, 10, 0]
//        llXAxis.labelPosition = .bottomRight
//        llXAxis.valueFont = .systemFont(ofSize: 10)
//
//        view.xAxis.gridLineDashLengths = [10, 10]
//        view.xAxis.gridLineDashPhase = 0
//
//        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
//        ll1.lineWidth = 4
//        ll1.lineDashLengths = [5, 5]
//        ll1.labelPosition = .topRight
//        ll1.valueFont = .systemFont(ofSize: 10)
//
//        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
//        ll2.lineWidth = 4
//        ll2.lineDashLengths = [5,5]
//        ll2.labelPosition = .bottomRight
//        ll2.valueFont = .systemFont(ofSize: 10)
//
//        let leftAxis = view.leftAxis
//        leftAxis.removeAllLimitLines()
//        leftAxis.addLimitLine(ll1)
//        leftAxis.addLimitLine(ll2)
//        leftAxis.axisMaximum = 200
//        leftAxis.axisMinimum = -50
//        leftAxis.gridLineDashLengths = [5, 5]
//        leftAxis.drawLimitLinesBehindDataEnabled = true

        view.rightAxis.enabled = false
        view.xAxis.enabled = false
        view.leftAxis.enabled = false

        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];

//        let marker = BalloonMarker(color: .white,
//                                   font: .systemFont(ofSize: 12),
//                                   textColor: .black,
//                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        let marker = PillMarker(color: .white, font: .systemFont(ofSize: 12), textColor: .black)
        marker.chartView = view
        //marker.minimumSize = CGSize(width: 80, height: 40)
        //view.drawMarkers = false
        //view.highlightPerTapEnabled = false
        view.marker = marker
        view.legend.form = .none
        //view.drawGridBackgroundEnabled = false
        view.xAxis.drawAxisLineEnabled = false
        view.leftAxis.drawAxisLineEnabled = false
        //sliderX.value = 45
        //sliderY.value = 100
        //slidersValueChanged(nil)

        //view.animate(xAxisDuration: 2.5)
        return view
    }()

//    private lazy var chartView: ScrollableGraphView = {
//        let graphView = ScrollableGraphView(frame: CGRect(x: 10, y: 10, width: 300, height: 500), dataSource: self)
//        //graphView
//        let linePlot = LinePlot(identifier: "Line")
//        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
//        let referenceLines = ReferenceLines()
//        referenceLines.shouldShowReferenceLines = false
//
//        let dotPlot = DotPlot(identifier: "Dot") // Add dots as well.
//        dotPlot.dataPointSize = 5
//        dotPlot.dataPointType = ScrollableGraphViewDataPointType.custom
////        if traitCollection.userInterfaceStyle == .light {
////            dotPlot.dataPointFillColor = UIColor.black
////            linePlot.lineColor = .black
////            referenceLines.dataPointLabelColor = .black
////        } else {
////            dotPlot.dataPointFillColor = UIColor.white
////            linePlot.lineColor = .white
////            referenceLines.dataPointLabelColor = .white
////
////        }
//
//        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
//        linePlot.adaptAnimationType = .elastic
//        graphView.addPlot(plot: linePlot)
//        graphView.addPlot(plot: dotPlot)
//        graphView.addReferenceLines(referenceLines: referenceLines)
//        graphView.shouldAdaptRange = true
//        graphView.shouldRangeAlwaysStartAtZero = true
//        graphView.direction = .rightToLeft
//        graphView.dataPointSpacing = 70
//        graphView.topMargin = 50
//        graphView.bottomMargin = 50
//        graphView.backgroundFillColor = .clear
//
//        graphView.translatesAutoresizingMaskIntoConstraints = false
//
//        return graphView
//    }()

    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.separatorGray.withAlphaComponent(0.3)
        return view
    }()
}

//extension ChartViewController: ScrollableGraphViewDataSource {
//    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
//        // Return the data for each plot.
//        let numberOfMonthPassed = 11 - pointIndex
//        //return viewModel.totalExpense(numberOfMonthPassed: numberOfMonthPassed)
//        return pointIndex % 2 == 0 ? Double(pointIndex + 3) : Double(pointIndex - 3)
//    }
//
//    func label(atIndex pointIndex: Int) -> String {
//        let targetDate = Date().numberOfMonthAgo(numberOfMonth: 11 - pointIndex)
//        print("\(pointIndex), \(targetDate.month)")
//        return "\(targetDate.month)"
//    }
//
//    func numberOfPoints() -> Int {
//        return 12
//    }
//
//}
extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseChartCell", for: indexPath) as? ChartTableViewCell, let cellViewModel = viewModel.viewModelForCell(at: indexPath)  else { return UITableViewCell()}
        cell.setupWith(viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let graphPoint = chartView.getMarkerPosition(highlight: highlight)
        print(graphPoint)
    }
}




open class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()

    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()

    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }

    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }

        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size

        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()

        context.setFillColor(color.cgColor)

        if offset.y > 0
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.fillPath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }

        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom

        UIGraphicsPushContext(context)

        label.draw(in: rect, withAttributes: _drawAttributes)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(String(entry.y))
    }

    @objc open func setLabel(_ newLabel: String)
    {
        label = newLabel

        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor

        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}

class PillMarker: MarkerImage {

    private (set) var color: UIColor
    private (set) var font: UIFont
    private (set) var textColor: UIColor
    private var labelText: String = ""
    private var attrs: [NSAttributedString.Key: AnyObject]!

    static let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.unitsStyle = .short
        return f
    }()

    init(color: UIColor, font: UIFont, textColor: UIColor) {
        self.color = color
        self.font = font
        self.textColor = textColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrs = [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor, .baselineOffset: NSNumber(value: -4)]
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        // custom padding around text
        let labelWidth = labelText.size(withAttributes: attrs).width + 10
        // if you modify labelHeigh you will have to tweak baselineOffset in attrs
        let labelHeight = labelText.size(withAttributes: attrs).height + 4

        // place pill above the marker, centered along x
        var rectangle = CGRect(x: point.x, y: point.y, width: labelWidth, height: labelHeight)
        rectangle.origin.x -= rectangle.width / 2.0
        let spacing: CGFloat = 20
        rectangle.origin.y -= rectangle.height + spacing

        // rounded rect
        let clipPath = UIBezierPath(roundedRect: rectangle, cornerRadius: 6.0).cgPath
        context.addPath(clipPath)
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.closePath()
        context.drawPath(using: .fillStroke)

        // add the text
        labelText.draw(with: rectangle, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        labelText = customString(entry.y)
    }

    private func customString(_ value: Double) -> String {
        let formattedString = PillMarker.formatter.string(from: TimeInterval(value))!
        // using this to convert the left axis values formatting, ie 2 min
        return "\(value)"
    }
}
