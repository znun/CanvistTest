//
//  ScaleViewController.swift
//  CanvistTest
//
//  Created by Mahmudul Hasan on 8/12/23.
//

import UIKit

class ScaleViewController: UIViewController {

    let shapeLayer = CAShapeLayer()
    let marksLayer = CAShapeLayer()
    let slider = UISlider()
    let progressLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let sliderYPosition: CGFloat = 550
        slider.frame = CGRect(x: 50, y: sliderYPosition, width: 300, height: 30)
        slider.minimumValue = -100
        slider.maximumValue = 100
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        view.addSubview(slider)

        createMarks()
        view.layer.addSublayer(marksLayer)

        createCircularProgressBar()
        view.layer.addSublayer(shapeLayer)

        progressLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        progressLabel.center = view.center
        progressLabel.textAlignment = .center
        progressLabel.textColor = .black
        updateProgressLabel()
        view.addSubview(progressLabel)
    }

    func createMarks() {
        let totalMarks = 40
        let sliderWidth = slider.bounds.width
        let markSpacing = sliderWidth / CGFloat(totalMarks - 1)

        let marksPath = UIBezierPath()
        for i in 0..<totalMarks {
            let x = slider.frame.origin.x + CGFloat(i) * markSpacing
            let y = slider.center.y
            marksPath.move(to: CGPoint(x: x, y: y - 5))
            marksPath.addLine(to: CGPoint(x: x, y: y + 5))
        }

        marksLayer.path = marksPath.cgPath
        marksLayer.strokeColor = UIColor.black.cgColor
        marksLayer.lineWidth = 2
    }

    func createCircularProgressBar() {
        let smallerRadius: CGFloat = 50
        let circularPath = UIBezierPath(
            arcCenter: view.center,
            radius: smallerRadius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )

        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
    }

    @objc func sliderValueChanged() {
        let sliderValue = slider.value
        let normalizedValue = (sliderValue + 100) / 200 
        shapeLayer.strokeEnd = CGFloat(normalizedValue)
        updateProgressLabel()
    }

    func updateProgressLabel() {
        let sliderValue = slider.value
        progressLabel.text = "\(Int(sliderValue))"
    }
}

