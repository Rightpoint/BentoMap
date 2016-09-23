//
//  CoreGraphicsViewController.swift
// BentoMap
//
//  Created by Matthew Buckley on 9/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BentoMap

class CoreGraphicsViewController: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let gridData = QuadTree<Int, CGRect, CGPoint>.sampleGridData(forContainerRect: view.frame)

        let map: BentoBox<CGRect, CGPoint> = BentoBox(root: view.frame)
        let mapView = UIView(frame: map.root)
        view.addSubview(mapView)
        mapView.backgroundColor = .whiteColor()

        let clusterResults = gridData.clusteredDataWithinMapRect(map.root,
                                                                zoomScale: 1.0,
                                                                cellSize: 64)

        for result in clusterResults {
            switch result {
            case .Single(let node):
                let node = UIView(frame: CGRect(origin: node.originCoordinate, size: CGSize(width: 5.0, height: 5.0)))
                node.backgroundColor = .blueColor()
                node.layer.cornerRadius = 2.5
                view.addSubview(node)
            case .Multiple(let nodes):
                for node in nodes {
                    let node = UIView(frame: CGRect(origin: node.originCoordinate, size: CGSize(width: 5.0, height: 5.0)))
                    node.layer.cornerRadius = 2.5
                    view.addSubview(node)
                    node.backgroundColor = .blueColor()
                }
            }
        }
    }

}
