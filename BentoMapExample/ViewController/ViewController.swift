//
//  ViewController.swift
//  BentoMapExample
//
//  Created by Michael Skiba on 7/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import MapKit
import BentoMap

class ViewController: UIViewController {

    let mapData = SampleMapData().quadTree

    var mapView: MKMapView! {
        return view as? MKMapView
    }

    override func loadView() {
        navigationItem.title = NSLocalizedString("BentoMap", comment: "BentoMap navbar title")
        view = MKMapView()
        mapView.delegate = self
        mapView.setVisibleMapRect(mapData.boundingBox.mapRect, edgePadding: UIEdgeInsets(top: 80, left: 20, bottom: 20, right: 20), animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        updateAnnotationsForMapRect(mapView.visibleMapRect)
    }

}

extension ViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(MKPinAnnotationView.self) as String)
        if annotation.isKindOfClass(ClusterAnnotation.self) {
            pin.pinTintColor = UIColor.blueColor()
            pin.animatesDrop = false
        }
        else {
            pin.pinTintColor = UIColor.redColor()
            pin.animatesDrop = true
        }
        return pin
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let zoomRect = (view.annotation as? SingleAnnotation)?.mapRect ?? (view.annotation as? ClusterAnnotation)?.mapRect {
            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 80, left: 20, bottom: 20, right: 20), animated: true)
        }
    }

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateAnnotationsForMapRect(mapView.visibleMapRect)
    }
}

private extension ViewController {

    func updateAnnotationsForMapRect(mapRect: MKMapRect) {
        let activeAnnotations: [MKAnnotation]

        if mapView.frame.size.width != 0 && mapRect.size.width != 0 {
            let zoomScale = Double(mapView.frame.size.width) / mapRect.size.width
            activeAnnotations = mapData.clusteredDataWithinMapRect(mapRect, zoomScale: zoomScale, cellSize: 64).map(self.dynamicType.makeAnnotation)
        }
        else {
            activeAnnotations = []
        }

        let newAnnotations = activeAnnotations
        let oldAnnotations = mapView.annotations

        let annotationComparator = { (annotation: MKAnnotation) -> ((comparedTo: MKAnnotation) -> Bool) in
            return { (comparedTo: MKAnnotation) -> Bool in
                return comparedTo == annotation
            }
        }

        let toRemove = oldAnnotations.filter { annotation in
            return !newAnnotations.contains(annotationComparator(annotation))
        }

        mapView.removeAnnotations(toRemove)

        let toAdd = newAnnotations.filter { annotation in
            return !oldAnnotations.contains(annotationComparator(annotation))
        }

        mapView.addAnnotations(toAdd)
    }

    static func makeAnnotation(result: QuadTreeResult<Int>) -> MKAnnotation {
        let annotation: MKAnnotation
        switch result {
        case let .Single(node: node):
            annotation = SingleAnnotation(mapPoint: result.mapPoint, annotationNumber: node.content, mapRect: result.contentRect)
        case let .Multiple(nodes: nodes):
            annotation = ClusterAnnotation(mapPoint: result.mapPoint, annotationNumbers: nodes.map({ $0.content }), mapRect: result.contentRect)
        }
        return annotation
    }
}

private func == (lhs: MKAnnotation, rhs: MKAnnotation) -> Bool {
    if let lSingle = lhs as? SingleAnnotation, rSingle = rhs as? SingleAnnotation {
        return lSingle.annotationNumber == rSingle.annotationNumber
    }
    else if let lMulti = lhs as? ClusterAnnotation, rMulti = rhs as? ClusterAnnotation {
        return lMulti.annotationNumbers == rMulti.annotationNumbers
    }
    return false
}
