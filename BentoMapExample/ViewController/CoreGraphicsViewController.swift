//
//  CoreGraphicsViewController.swift
//  BentoMap
//
//  Created by Matthew Buckley on 9/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BentoMap

class CoreGraphicsViewController: UIViewController {

    let colors = [
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.purpleColor(),
        UIColor.blackColor(),
    ]

    override func loadView() {
        super.loadView()

        let gridView = UIView()
        gridView.backgroundColor = .purpleColor()
        view = gridView
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let gridData = QuadTree<Int, CGRect, CGPoint>.sampleGridData(forContainerRect: view.frame)

        let map: BentoMap<CGRect, CGPoint> = BentoMap(rootNode: view.frame)
        let mapView = UIView(frame: map.rootNode)
        view.addSubview(mapView)
        mapView.backgroundColor = .yellowColor()

        let clusterResults = gridData.clusteredDataWithinMapRect(map.rootNode,
                                                                zoomScale: 1.0,
                                                                cellSize: 64)
        var idx = 0
        for result in clusterResults {
            let tileView = UIView(frame: result.contentRect)
            view.addSubview(tileView)
            tileView.backgroundColor = colors[idx % colors.count]
            idx = idx + 1
        }
    }

}
