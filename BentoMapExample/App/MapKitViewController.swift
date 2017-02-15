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

    static let cellSize: CGFloat = 64
    // Used to make sure the map is nicely padded on the edges, and visible annotations
    // aren't hidden under the navigation bar
    static let mapInsets =  UIEdgeInsets(top: cellSize, left: (cellSize / 2), bottom: (cellSize / 2), right: (cellSize / 2))

    let mapData = QuadTree<Int, MKMapRect, CLLocationCoordinate2D>.sampleData
    var mapView: MKMapView! {
        return view as? MKMapView
    }

    override func loadView() {
        let mapView = MKMapView()
        mapView.delegate = self
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("BentoBox",
                                                 comment: "BentoBox navbar title")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let zoomRect = mapView.mapRectThatFits(mapData.bentoBox.root, edgePadding: type(of: self).mapInsets)
        mapView.setVisibleMapRect(zoomRect,
                                  edgePadding: type(of: self).mapInsets,
                                  animated: false)
    }

}

extension MapKitViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKAnnotationView
        if let single = annotation as? SingleAnnotation {
            annotationView = mapView.dequeueAnnotationView(for: single) as SingleAnnotationView
        }
        else if let cluster = annotation as? ClusterAnnotation {
            annotationView = mapView.dequeueAnnotationView(for: cluster) as ClusterAnnotationView
        }
        else {
            fatalError("Unexpected annotation type found")
        }
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cluster = view as? ClusterAnnotationView, let zoomRect = cluster.typedAnnotation?.root {
            let adjustedZoom = mapView.mapRectThatFits(zoomRect, edgePadding: type(of: self).mapInsets)
            mapView.setVisibleMapRect(adjustedZoom,
                                      edgePadding: type(of: self).mapInsets,
                                      animated: true)
        }
        else {
            view.setSelected(true, animated: true)
        }
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
                                                                cellSize: Double(MapKitViewController.cellSize))
        let newAnnotations = clusterResults.map(BaseAnnotation.makeAnnotation)

        let oldAnnotations = mapView.annotations.flatMap({ $0 as? BaseAnnotation })

        let toRemove = oldAnnotations.filter { annotation in
            return !newAnnotations.contains { newAnnotation in
                return newAnnotation == annotation
            }
        }

        let snapshots: [UIView] = toRemove.flatMap { annotation in
            guard let annotationView = mapView.view(for: annotation),
                let snapshot = annotationView.snapshotView(afterScreenUpdates: false),
                mapView.frame.intersects(annotationView.frame) == true else {
                return nil
            }
            snapshot.frame = annotationView.frame
            mapView.insertSubview(snapshot, aboveSubview: annotationView)
            return snapshot
        }

        UIView.animate(withDuration: 0.2, animations: {
            for snapshot in snapshots {
                snapshot.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                snapshot.layer.opacity = 0
            }
        },
                       completion: { _ in
                        for snapshot in snapshots {
                            snapshot.removeFromSuperview()
                        }
        })

        mapView.removeAnnotations(toRemove)

        let toAdd = newAnnotations.filter { annotation in
            return !oldAnnotations.contains { oldAnnotation in
                return oldAnnotation == annotation
            }
        }

        mapView.addAnnotations(toAdd)
    }

}
