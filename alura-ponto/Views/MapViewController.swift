//
//  MapViewController.swift
//  alura-ponto
//
//  Created by c94289a on 31/03/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private var receipt: Receipt?
    
    class func instantiate(receipt: Receipt) -> MapViewController {
        let controller = MapViewController()
        controller.receipt = receipt
        return controller
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Localização da batida de ponto eletrônico"
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupView() {
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 257),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        ])
        
        self.view.addSubview(map)
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            map.leftAnchor.constraint(equalTo: view.leftAnchor),
            map.rightAnchor.constraint(equalTo: view.rightAnchor),
            map.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
