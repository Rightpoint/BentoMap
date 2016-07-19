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

final class ViewController: UIViewController {

    // Used to make sure the map is nicely padded on the edges, and visible annotations
    // aren't hidden under the navigation bar
    static let mapInsets =  UIEdgeInsets(top: 80, left: 20, bottom: 20, right: 20)

    let mapData = QuadTree<Int>.sampleData

    override func loadView() {
        super.loadView()
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.setVisibleMapRect(mapData.boundingBox.mapRect,
                                  edgePadding: self.dynamicType.mapInsets,
                                  animated: false)
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("BentoMap",
                                                 comment: "BentoMap navbar title")
    }

}

extension ViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = mapView.dequeueAnnotationView(forAnnotation: annotation)
            as MKPinAnnotationView
        pin.configureWithAnnotation(annotation)
        return pin
    }

    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView) {
        guard let zoomRect = (view.annotation as? MapRectProvider)?.mapRect else {
            return
        }
        mapView.setVisibleMapRect(zoomRect,
                                  edgePadding: self.dynamicType.mapInsets,
                                  animated: true)
    }

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateAnnotations(inMapView: mapView,
                          forMapRect: mapView.visibleMapRect)
    }

}

private extension ViewController {

    func updateAnnotations(inMapView mapView: MKMapView,
                                     forMapRect mapRect: MKMapRect) {
        guard mapView.frame.size.width != 0 && mapRect.size.width != 0 else {
            mapView.removeAnnotations(mapView.annotations)
            return
        }
        let zoomScale = Double(mapView.frame.size.width) / mapRect.size.width
        let clusterResults = mapData.clusteredDataWithinMapRect(mapRect,
                                                                zoomScale: zoomScale,
                                                                cellSize: 64)
        let newAnnotations = clusterResults.map(self.dynamicType.makeAnnotation)

        let oldAnnotations = mapView.annotations

        let annotationFilter = self.dynamicType.annotationFilter

        let toRemove = oldAnnotations.filter(annotationFilter(notContainedIn: newAnnotations))

        mapView.removeAnnotations(toRemove)

        let toAdd = newAnnotations.filter(annotationFilter(notContainedIn: oldAnnotations))

        mapView.addAnnotations(toAdd)
    }

    static func annotationFilter(notContainedIn differenceArray: [MKAnnotation]) ->
        (MKAnnotation -> Bool) {
            return { annotation in
                return !differenceArray.contains(annotationEquals(annotation))
            }
    }

    static func annotationEquals(rhs: MKAnnotation) ->
        (MKAnnotation -> Bool) {
            return { (lhs: MKAnnotation) -> Bool in
                if let lSingle = lhs as? SingleAnnotation,
                    rSingle = rhs as? SingleAnnotation {
                    return lSingle.annotationNumber == rSingle.annotationNumber
                }
                else if let lMulti = lhs as? ClusterAnnotation,
                    rMulti = rhs as? ClusterAnnotation {
                    return lMulti.annotationNumbers == rMulti.annotationNumbers
                }
                return false
            }
    }

    static func makeAnnotation(result: QuadTreeResult<Int>) -> MKAnnotation {
        let annotation: MKAnnotation
        switch result {
        case let .Single(node: node):
            annotation = SingleAnnotation(mapPoint: result.mapPoint,
                                          annotationNumber: node.content,
                                          mapRect: result.contentRect)
        case let .Multiple(nodes: nodes):
            annotation = ClusterAnnotation(mapPoint: result.mapPoint,
                                           annotationNumbers: nodes.map({ $0.content }),
                                           mapRect: result.contentRect)
        }
        return annotation
    }

}

private extension MKMapView {

    func dequeueAnnotationView<AnnotationView: MKAnnotationView>
        (forAnnotation annotation: MKAnnotation,
                       identifier: String) -> AnnotationView {
        if let annotation = dequeueReusableAnnotationViewWithIdentifier(identifier)
            as? AnnotationView {
            return annotation
        }
        return AnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }

    func dequeueAnnotationView<AnnotationView: MKAnnotationView>
        (forAnnotation annotation: MKAnnotation) -> AnnotationView {
        return dequeueAnnotationView(forAnnotation: annotation,
                                     identifier: AnnotationView.reuseIdentifer)
    }
}

private extension MKAnnotationView {

    static var reuseIdentifer: String {
        return NSStringFromClass(self)
    }

}

private extension MKPinAnnotationView {
    func configureWithAnnotation(annotation: MKAnnotation) {
        if annotation.isKindOfClass(ClusterAnnotation.self) {
            pinTintColor = UIColor.blueColor()
            animatesDrop = false
        }
        else {
            pinTintColor = UIColor.redColor()
            animatesDrop = true
        }
    }
}
