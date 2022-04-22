//
//  ReceiptViewController.swift
//  alura-ponto
//
//  Created by c94289a on 22/02/22.
//

import UIKit
import CoreData
import LocalAuthentication

class ReceiptViewController: UIViewController {
    
    lazy var photoPickerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = view.layer.frame.height/2
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var selectPhotoButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(selectPhotoButtonClicked), for: .touchUpInside)
        if profileImageView.image != nil {
            button.setImage(UIImage(systemName: ""), for: .normal)
        }
        
        return button
    }()
    
    lazy var receiptTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recibos"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    lazy var receiptTableView: UITableView = {
        let table = UITableView(frame: view.frame, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(ReceiptTableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        table.separatorStyle = .none
        
        return table
    }()
    
    private lazy var camera = Camera()
    private lazy var imagePickerController = UIImagePickerController()
    
    lazy var context: NSManagedObjectContext = {
        let context = DataBaseController.persistentContainer.viewContext
        return context
    }()
    
    lazy var fetch: NSFetchedResultsController<Receipt> = {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetch = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetch.delegate = self
        return fetch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.receiptTableView.reloadData()
        getReceipt()
        getProfileImage()
    }
    
   @objc func selectPhotoButtonClicked() {
       showMenuImageSelectionAlert()
    }
    
    func showMenuImageSelectionAlert() {
        let alert = UIAlertController(title: "Seleção de fotos", message: "Escolha uma foto da galeria", preferredStyle: .actionSheet)
        let goToGalleryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.camera.delegate = self
                self.camera.openPhotoLibrary(controller: self, imagePicker: self.imagePickerController)
            }
        }
        alert.addAction(goToGalleryAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getReceipt() {
        Receipt.load(fetch)
        receiptTableView.reloadData()
    }
    func getProfileImage() {
        let profileImage = Profile().loadImage()
        profileImageView.image = profileImage
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(photoPickerView)
        photoPickerView.addSubview(profileImageView)
        photoPickerView.addSubview(selectPhotoButton)
        self.view.addSubview(receiptTitleLabel)
        self.view.addSubview(receiptTableView)
        
        NSLayoutConstraint.activate([
            photoPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            photoPickerView.heightAnchor.constraint(equalToConstant: 100),
            photoPickerView.widthAnchor.constraint(equalToConstant: 100),
            photoPickerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            
            profileImageView.topAnchor.constraint(equalTo: photoPickerView.topAnchor),
            profileImageView.leftAnchor.constraint(equalTo: photoPickerView.leftAnchor),
            profileImageView.rightAnchor.constraint(equalTo: photoPickerView.rightAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: photoPickerView.bottomAnchor),
            
            selectPhotoButton.topAnchor.constraint(equalTo: photoPickerView.topAnchor),
            selectPhotoButton.leftAnchor.constraint(equalTo: photoPickerView.leftAnchor),
            selectPhotoButton.rightAnchor.constraint(equalTo: photoPickerView.rightAnchor),
            selectPhotoButton.bottomAnchor.constraint(equalTo: photoPickerView.bottomAnchor),
            
            receiptTitleLabel.topAnchor.constraint(equalTo: photoPickerView.bottomAnchor, constant: 10),
            receiptTitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 35),
            receiptTitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35),
            
            receiptTableView.topAnchor.constraint(equalTo: receiptTitleLabel.bottomAnchor, constant: 20),
            receiptTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            receiptTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            receiptTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension ReceiptViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchCount = fetch.fetchedObjects?.count else { return 0 }
        return fetchCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ReceiptTableViewCell else { return UITableViewCell() }
        
        guard let receipt = fetch.fetchedObjects?[indexPath.row] else { return UITableViewCell() }
        cell.configCell(receipt: receipt)
        cell.delegate = self
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
}

extension ReceiptViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let receipt = fetch.fetchedObjects?[indexPath.row] else { return }
        let mapViewController = MapViewController.instantiate(receipt: receipt)
        mapViewController.modalPresentationStyle = .automatic
        present(mapViewController, animated: true, completion: nil)
    }
}

extension ReceiptViewController: ReceiptTableViewCellDelegate {
    func deleteReceipt(index: Int) {
        AuthenticationLocal().authorizeUser { authentication in
            if authentication {
                guard let receipt = self.fetch.fetchedObjects?[index] else { return }
                receipt.delete(self.context)
                DispatchQueue.main.async {
                    self.receiptTableView.reloadData()
                }
            }
        }
    }
}

extension ReceiptViewController: CameraDelegate {
    func didFinishSelectPhoto(image: UIImage) {
        Profile().saveImage(image)
        profileImageView.image = image
    }
}

extension ReceiptViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                receiptTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            receiptTableView.reloadData()
        }
    }
}
