//
//  MapKitViewController.swift
//  BentoMapExample
//
//  Created by Michael Skiba on 7/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import MapKit
import BentoMap

final class MapKitViewController: UIViewController {

    // Used to make sure the map is nicely padded on the edges, and visible annotations
    // aren't hidden under the navigation bar
    static let mapInsets =  UIEdgeInsets(top: 80, left: 20, bottom: 20, right: 20)

    let mapData = QuadTree<Int, MKMapRect, CLLocationCoordinate2D>.sampleData

    override func loadView() {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.setVisibleMapRect(mapData.bentoBox.root,
                                  edgePadding: type(of: self).mapInsets,
                                  animated: false)
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("BentoBox",
                                                 comment: "BentoBox navbar title")
    }

}

extension MapKitViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = mapView.dequeueAnnotationView(forAnnotation: annotation)
            as MKPinAnnotationView
        pin.configureWithAnnotation(annotation)
        return pin
    }

    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        guard let zoomRect = (view.annotation as? BaseAnnotation)?.root else {
            return
        }
        mapView.setVisibleMapRect(zoomRect,
                                  edgePadding: type(of: self).mapInsets,
                                  animated: true)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateAnnotations(inMapView: mapView,
                          forMapRect: mapView.visibleMapRect)
    }

}

private extension MapKitViewController {

    func updateAnnotations(inMapView mapView: MKMapView,
                                     forMapRect root: MKMapRect) {
        guard !mapView.frame.isEmpty && !MKMapRectIsEmpty(root) else {
            mapView.removeAnnotations(mapView.annotations)
            return
        }
        let zoomScale = Double(mapView.frame.width) / root.size.width
        let clusterResults = mapData.clusteredDataWithinMapRect(root,
                                                                zoomScale: zoomScale,
                                                                cellSize: 64)
        let newAnnotations = clusterResults.map(BaseAnnotation.makeAnnotation)

        let oldAnnotations = mapView.annotations.flatMap({ $0 as? BaseAnnotation })

        let toRemove = oldAnnotations.filter { annotation in
            return !newAnnotations.contains { newAnnotation in
                return newAnnotation == annotation
            }
        }

        mapView.removeAnnotations(toRemove)

        let toAdd = newAnnotations.filter { annotation in
            return !oldAnnotations.contains { oldAnnotation in
                return oldAnnotation == annotation
            }
        }

        mapView.addAnnotations(toAdd)
    }

}

private extension MKMapView {

    func dequeueAnnotationView<AnnotationView: MKAnnotationView>
        (forAnnotation annotation: MKAnnotation,
                       identifier: String) -> AnnotationView {
        if let annotation = dequeueReusableAnnotationView(withIdentifier: identifier)
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
    func configureWithAnnotation(_ annotation: MKAnnotation) {
        if annotation.isKind(of: ClusterAnnotation.self) {
            pinTintColor = UIColor.blue
            animatesDrop = false
        }
        else {
            pinTintColor = UIColor.red
            animatesDrop = true
        }
    }
}
