//
//  ViewController.swift
//  alura-ponto
//
//  Created by c94289a on 22/02/22.
//

import UIKit
import CoreData
import CoreLocation

class HomeViewController: UIViewController {
    
    lazy var timeView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 220))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.cornerRadius = view.layer.frame.height/2
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 52)
        label.text = "20:12"
        label.textColor = .systemGray
        
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("REGISTRAR PONTO", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(registerButtonTouched), for: .touchUpInside)
        
        return button
    }()
    
    var timer: Timer?
    lazy var camera = Camera()
    lazy var imagePickerController = UIImagePickerController()
    lazy var context: NSManagedObjectContext = {
        let context = DataBaseController.persistentContainer.viewContext
        return context
    }()
    lazy var locationManager = CLLocationManager()
    private lazy var location = Location()
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        requiredUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    @objc func updateTime() {
        let currentTime = DateAndTimeFormatter().getTime(Date())
        timeLabel.text = currentTime
    }
    
    @objc func registerButtonTouched() {
//        tryOpenCamera()
        showAlert()
        
        let receipt = Receipt(status: false, date: Date(), latitude: latitude ?? 0, longitude: longitude ?? 0)
        receipt.save(context)
    }

    func configTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func tryOpenCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            camera.delegate = self
            camera.openCamera(controller: self, imagePicker: imagePickerController)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alura Ponto", message: "Sua marcação de ponto foi registrada com sucesso!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func requiredUserLocation() {
        location.delegate = self
        
        location.permission(locationManager)
    }

    func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(timeView)
        timeView.addSubview(timeLabel)
        self.view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            timeView.heightAnchor.constraint(equalToConstant: 220),
            timeView.widthAnchor.constraint(equalToConstant: 220),
            timeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            timeLabel.centerXAnchor.constraint(equalTo: timeView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeView.centerYAnchor),
            
            registerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            registerButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            registerButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension HomeViewController: CameraDelegate {
    func didFinishSelectPhoto(image: UIImage) {
//        let receipt = Receipt(status: false, date: Date(), photo: image)
//        Session.shared.addReceipt(receipt)
//        receipt.save(context)
    }
}

extension HomeViewController: LocationDelegate {
    func updateUserLocation(latitude: Double?, longitude: Double?) {
        self.latitude = latitude ?? 0.0
        self.longitude = longitude ?? 0.0
    }
}
