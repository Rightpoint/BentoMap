//
//  AnnotationView.swift
//  BentoMap
//
//  Created by Michael Skiba on 1/10/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit
import MapKit

private extension CGSize {
    static let minSize: CGSize = CGSize(width: 32, height: 32)
}

extension MKAnnotationView {

    static var classReuseIdentifier: String {
        return String(describing: self)
    }

}

extension MKMapView {

    func dequeueAnnotationView<AnnotationView: MKAnnotationView>(for annotation: AnnotationView.AnnotationType,
                               withIdentifier: String = AnnotationView.classReuseIdentifier) -> AnnotationView where AnnotationView: TypedAnnotationView {
        let view: AnnotationView
        if let annotationView = dequeueReusableAnnotationView(withIdentifier: AnnotationView.classReuseIdentifier) as? AnnotationView {
            annotationView.annotation = annotation
            view = annotationView
        }
        else {
            view = AnnotationView.init(annotation: annotation, reuseIdentifier: AnnotationView.classReuseIdentifier)
        }
        return view
    }

}

protocol TypedAnnotationView {

    associatedtype AnnotationType: MKAnnotation

    var annotation: MKAnnotation? { get set }

    func updateAnnotation()
}

extension TypedAnnotationView {

    var typedAnnotation: AnnotationType? {
        get {
            return annotation as? AnnotationType
        }
        set {
            annotation = newValue
            updateAnnotation()
        }
    }

}

class AnimatedAnnotationView: MKAnnotationView {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        layer.opacity = 0
        let animation = {
            self.transform = .identity
            self.layer.opacity = 1
        }
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut],
                       animations: animation,
                       completion: nil)
    }

}

class SingleAnnotationView: AnimatedAnnotationView, TypedAnnotationView {

    typealias AnnotationType = SingleAnnotation

    override var annotation: MKAnnotation? {
        didSet {
            updateAnnotation()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = #imageLiteral(resourceName: "redHexagon")
        canShowCallout = true
        updateAnnotation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAnnotation() {
    }

}

class ClusterAnnotationView: AnimatedAnnotationView, TypedAnnotationView {

    typealias AnnotationType = ClusterAnnotation
    let label: UILabel

    override var annotation: MKAnnotation? {
        didSet {
            updateAnnotation()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        label.layer.masksToBounds = true
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 0.5
        label.layer.shadowOpacity = 1

        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        image = #imageLiteral(resourceName: "blueStretch")

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            ])

        updateAnnotation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAnnotation() {
        label.text = typedAnnotation.map { "\($0.annotationNumbers.count)" }

        var size = label.systemLayoutSizeFitting(.minSize,
                                                 withHorizontalFittingPriority: UILayoutPriorityFittingSizeLevel,
                                                 verticalFittingPriority: UILayoutPriorityFittingSizeLevel)

        size.width += 8
        size.height += 8

        if size.width < CGSize.minSize.width {
            size.width = CGSize.minSize.width
        }
        if size.height < CGSize.minSize.height {
            size.height = CGSize.minSize.height
        }

        frame = CGRect(origin: CGPoint(), size: size)
    }

}
