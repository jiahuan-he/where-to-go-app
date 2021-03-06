//
//  GroupedStackedBarVC.swift
//  where-to-go
//
//  Created by LMAO on 26/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import SwiftCharts
import Alamofire
import SwiftyJSON
import GooglePlaces

func screenHeight() -> CGFloat{
    let screenSize = UIScreen.main.bounds
    let screenHeight = screenSize.height
    return screenHeight

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

struct ChartDefaults {
    static var chartSettings: ChartSettings {
//        if Env.iPad {
//            return iPadChartSettings
//        } else {
            return iPhoneChartSettings
//        }
    }
    
    static var chartSettingsWithPanZoom: ChartSettings {
//        if Env.iPad {
//            return iPadChartSettingsWithPanZoom
//        } else {
            return iPhoneChartSettingsWithPanZoom
//        }
    }
    
    fileprivate static var iPadChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 20
        chartSettings.top = 20
        chartSettings.trailing = 20
        chartSettings.bottom = 20
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 5
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 15
        chartSettings.spacingBetweenAxesY = 15
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPadChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPadChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPhoneChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 70, width: containerBounds.size.width, height: containerBounds.size.height - 70)
    }
    
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: ChartDefaults.labelFont)
    }
    
    static var labelFont: UIFont {
//        return ExamplesDefaults.fontWithSize(Env.iPad ? 14 : 11)
        return ChartDefaults.fontWithSize(11)
    }
    
    static var labelFontSmall: UIFont {
//        return ExamplesDefaults.fontWithSize(Env.iPad ? 12 : 10)
        return ChartDefaults.fontWithSize(10)
    }
    
    static func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var guidelinesWidth: CGFloat {
//        return Env.iPad ? 0.5 : 0.1
        return 0.1
    }
    
    static var minBarSpacing: CGFloat {
//        return Env.iPad ? 10 : 5
        return 5
    }
}
var groupsData = [(title: String, bars: [(start: Double, quantities: [Double])])]()

class GroupedStackedBarVC: UIViewController {

    func segueToMain() {
        performSegue(withIdentifier: "mainVC", sender: self)
    }
    fileprivate var chart: Chart?
    
    fileprivate let dirSelectorHeight: CGFloat = 50
    
    fileprivate func barsChart(horizontal: Bool) -> Chart {

        let labelSettings = ChartLabelSettings(font: ChartDefaults.labelFont)
        let colorN4 = UIColor(red: 255, green: 0, blue: 0)
        let colorN3 = UIColor(red: 255, green: 100, blue: 0)
        let colorN2 = UIColor(red: 255, green: 180, blue: 0)
        let colorN1 = UIColor(red: 255, green: 220, blue: 0)
        let colorP1 = UIColor(red: 230, green: 255, blue: 0)
        let colorP2 = UIColor(red: 200, green: 255, blue: 0)
        let colorP3 = UIColor(red: 140, green: 255, blue: 0)
        let colorP4 = UIColor(red: 100, green: 255, blue: 0)
        
        let frameColors = [colorN4, colorN3, colorN2, colorN1, colorP1, colorP2, colorP3,colorP4]
        
        let groups: [ChartPointsBarGroup<ChartStackedBarModel>] = groupsData.enumerated().map {index, entry in
            let constant = ChartAxisValueDouble(Double(index))
            let bars: [ChartStackedBarModel] = entry.bars.enumerated().map {index, bars in
                let items = bars.quantities.enumerated().map {index, quantity in
                    ChartStackedBarItemModel(quantity, frameColors[index])
                }
                return ChartStackedBarModel(constant: constant, start: ChartAxisValueDouble(bars.start), items: items)
            }
            return ChartPointsBarGroup(constant: constant, bars: bars)
        }
        
        let letterAxisValues = [ChartAxisValueString(order: -1)] +
            groupsData.enumerated().map {index, tuple in
                var title = tuple.title
                if title.count > 12{
                    title = String(title.prefix(12))
                }
                return ChartAxisValueString(title, order: index, labelSettings: labelSettings)
            } +
            [ChartAxisValueString(order: groupsData.count)]
        
        
        let numberAxisValuesGenerator = ChartAxisGeneratorMultiplier(5)
        let numberAxisLabelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
            return ChartAxisLabel(text: "\(scalar)", settings: labelSettings)
        }
        
        let m1 = ChartAxisModel(firstModelValue: -20, lastModelValue: 20, axisTitleLabels: [ChartAxisLabel(text: "MAGNITUDE", settings: horizontal ? labelSettings : labelSettings.defaultVertical())], axisValuesGenerator: numberAxisValuesGenerator, labelsGenerator: numberAxisLabelsGenerator)
        
        let m2 = ChartAxisModel(axisValues: letterAxisValues, axisTitleLabel: ChartAxisLabel(text: "", settings: horizontal ? labelSettings.defaultVertical() : labelSettings))
        
        let (xModel, yModel) = horizontal ? (m1, m2) : (m2, m1)
        
        
        let frame = ChartDefaults.chartFrame(view.bounds)
        let chartFrame = chart?.frame ?? CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - dirSelectorHeight)
        
        let chartSettings = ChartDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let groupsLayer = ChartGroupedStackedBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, groups: groups, horizontal: horizontal, barSpacing: 2, groupSpacing: 30, settings: ChartBarViewSettings(animDuration: 0.5))
        
        let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: ChartDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, axis: horizontal ? .x : .y, settings: settings)
        
        let dummyZeroChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let zeroGuidelineLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: [dummyZeroChartPoint], viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let width: CGFloat = 2
            
            let viewFrame: CGRect = {
                if horizontal {
                    return CGRect(x: chartPointModel.screenLoc.x - width / 2, y: 0, width: width, height: layer.modelLocToScreenLoc(y: -1))
                } else {
                    return CGRect(x: 0, y: chartPointModel.screenLoc.y - width / 2, width: layer.modelLocToScreenLoc(x: Double(groups.count)), height: width)
                }
            }()
            
            let v = UIView(frame: viewFrame)
            v.backgroundColor = UIColor.black
            return v
        })
        
        return Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                groupsLayer,
                zeroGuidelineLayer
            ]
        )
    }
    
    
    fileprivate func showChart(horizontal: Bool) {
        self.chart?.clearView()
//        let chart = barsChart(horizontal: horizontal)
        let chart = barsChart(horizontal: true)
        view.addSubview(chart.view)
        self.chart = chart
    }
    
    override func viewDidLoad() {
        let getSentimentURL: String = "\(myURL)/analysis/sentiment"
        groupsData.removeAll()
        let parameter = ["pids": places.map({
            (place: GMSPlace) -> String in
            return place.placeID
        })]
        
        Alamofire.request(getSentimentURL, method: .post, parameters: parameter).responseJSON(completionHandler: {
            response in
            if let result = response.result.value {
                let sentimentData = JSON(result).dictionaryValue
                print(sentimentData)
                for place in places{
                    let pid = place.placeID
                    let title = place.name
                    let score = sentimentData[pid]?.dictionaryValue["score"]!.doubleValue.rounded(toPlaces: 4)
                    var magnitude = sentimentData[pid]?.dictionaryValue["magnitude"]!.doubleValue.rounded(toPlaces: 4)
                    var quantity: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
                    var index = 0
                    if score! < -0.75 {
                        magnitude = -magnitude!
                        index = 0
                    } else if score! < -0.50 {
                        magnitude = -magnitude!
                        index = 1
                    } else if score! < -0.25 {
                        magnitude = -magnitude!
                        index = 2
                    }else if score! < 0 {
                        magnitude = -magnitude!
                        index = 3
                    } else if score! < 0.25 {
                        index = 4
                    } else if score! < 0.50 {
                        index = 5
                    } else if score! < 0.70 {
                        index = 6
                    } else {
                        index = 7
                    }
                    quantity[index] = magnitude!
                    groupsData.append((title, [(0, quantity)]))
                }
                self.showChart(horizontal: false)
                if let chart = self.chart {
                    let dirSelector = DirSelector(frame: CGRect(x: 0, y: chart.frame.origin.y + chart.frame.size.height, width: self.view.frame.size.width, height: self.dirSelectorHeight), controller: self)
                    self.view.addSubview(dirSelector)
                }
            }
        }
        )
    }
    
    class DirSelector: UIView {
        
        let horizontalButton: UIButton
        let verticalButton: UIButton
        weak var controller: GroupedStackedBarVC?
        
        fileprivate let buttonDirs: [UIButton : Bool]
        
        init(frame: CGRect, controller: GroupedStackedBarVC) {
            self.controller = controller
            horizontalButton = UIButton()
            horizontalButton.setTitle("          ", for: UIControlState())
            verticalButton = UIButton()
            verticalButton.setTitle("        ", for: UIControlState())
            
            buttonDirs = [horizontalButton: true, verticalButton: false]
            
            super.init(frame: frame)
            
            let backButton = UIButton()
            backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
            backButton.setTitle("BACK", for: .normal)
            backButton.frame = CGRect(x: 0, y: 10, width: screenWidth(), height: 40)
            backButton.backgroundColor = Colors.backButtons
            backButton.titleLabel?.font = Fonts.backButtons
            addSubview(horizontalButton)
            addSubview(verticalButton)
            addSubview(backButton)
            for button in [horizontalButton, verticalButton] {
                button.titleLabel?.font = ChartDefaults.fontWithSize(14)
                button.setTitleColor(UIColor.blue, for: UIControlState())
                button.addTarget(self, action: #selector(DirSelector.buttonTapped(_:)), for: .touchUpInside)
            }
        }
        
        @objc func back(){
            self.controller?.segueToMain()
        }
        
        @objc func buttonTapped(_ sender: UIButton) {
//            let horizontal = sender == self.horizontalButton ? true : false
//            controller?.showChart(horizontal: horizontal)
//            performSegue(withIdentifier: "mainVC", sender: self)
        }
        
        override func didMoveToSuperview() {
            let views = [horizontalButton, verticalButton]
            for v in views {
                v.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let namedViews = views.enumerated().map{index, view in
                ("v\(index)", view)
            }
            
            var viewsDict = Dictionary<String, UIView>()
            for namedView in namedViews {
                viewsDict[namedView.0] = namedView.1
            }
            
//            let buttonsSpace: CGFloat = Env.iPad ? 20 : 10
            let buttonsSpace: CGFloat = 10
            
            let hConstraintStr = namedViews.reduce("H:|") {str, tuple in
                "\(str)-(\(buttonsSpace))-[\(tuple.0)]"
            }
            
            let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|[\($0.0)]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)}
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)
                + vConstraits)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
