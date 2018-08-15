//
//  DSSAppDetailController.swift
//  DSSAppStore
//
//  Created by David on 04/08/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit
import CoreText

class DSSAppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let headerCellId = "headerCellId"
    private let screenshotCellId = "screenshotCellId"
    private let detailCellId = "detailCellId"
    private let informationCellId = "informationCellId"
    
    var app: DSSApp? {
        didSet {
            if app?.Screenshots != nil {
                return
            }
            
            if let id = app?.Id {
                let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
                fetchAppDetail(urlString)
            }
        }
    }
    
    private func fetchAppDetail(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to get app details from server: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }

            do {
                let app = try JSONDecoder().decode(DSSApp.self, from: data)
                self.app = app
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } catch {
                print("Failed to decode received data from server: ", error.localizedDescription)
            }
            
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(DSSAppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellId)
        collectionView?.register(DSSScreenshotCell.self, forCellWithReuseIdentifier: screenshotCellId)
        collectionView?.register(DSSAppDetailDescriptionCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView?.register(DSSAppInformationCell.self, forCellWithReuseIdentifier: informationCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! DSSAppDetailDescriptionCell
            cell.descriptionTextView.attributedText = descriptionAttributedText()
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: informationCellId, for: indexPath) as! DSSAppInformationCell
            let information = setInformation()
            cell.nameTextView.text = information[0]
            cell.valueTextView.text = information[1]
            let nameText = setInformation()[0]
            let height = nameText.heightWithConstrainedWidth(width: collectionView.frame.width, font: UIFont.systemFont(ofSize: 11))
            
            let nameTextViewWidth = information[0].widthWithConstrainedWidth(height: height, font: UIFont.systemFont(ofSize: 11))
            cell.nameTextViewWidthAnchor?.constant = nameTextViewWidth + 12
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenshotCellId, for: indexPath) as! DSSScreenshotCell
        cell.app = app
        
        return cell
    }
    
    private func setInformation() -> [String] {
        var nameFields = ""
        var valueFields = ""
        app?.appInformation?.forEach({ (appInformation) in
            if let name = appInformation.Name, let value = appInformation.Value {
                nameFields += name + "\n"
                valueFields += value + "\n"
            }
        })
        return [nameFields, valueFields]
    }
    
    private func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString()
        let style = NSMutableParagraphStyle()
        attributedText.append(NSAttributedString(string: "Description\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        style.lineSpacing = 10
        let range = NSMakeRange(0, attributedText.string.count)
        attributedText.addAttributes([NSAttributedStringKey.paragraphStyle: style], range: range)
        if let description = app?.description {
            attributedText.append(NSAttributedString(string: description,
                                                     attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11), NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
        }
        return attributedText
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 1 {
            let size = CGSize(width: view.frame.width, height: CGFloat.infinity)
            let attributedString = descriptionAttributedText()
            let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
            let newSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, attributedString.length), nil, size, nil)
            
            return CGSize(width: view.frame.width, height: newSize.height + 32)
        } else if indexPath.row == 2 {
            let nameText = setInformation()[0]
            let height = nameText.heightWithConstrainedWidth(width: collectionView.frame.width, font: UIFont.systemFont(ofSize: 11))
            
            return CGSize(width: view.frame.width - 8 - 8, height: height + 44)
        }
        
        return CGSize(width: view.frame.width - 8 - 8, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! DSSAppDetailHeader
        header.app = app
        
        return header
    }
}

class DSSAppDetailDescriptionCell: DSSBaseCell {
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(descriptionTextView)
        addSubview(dividerLineView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: descriptionTextView)
        addConstraintsWithFormat("H:|-14-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:|-4-[v0]-4-[v1(1)]|", views: descriptionTextView, dividerLineView)
    }
}

class DSSAppInformationCell: DSSBaseCell {
    let informationTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Information"
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 11)
        textView.isScrollEnabled = false
        textView.textAlignment = .right
        textView.textColor = .darkGray
        textView.backgroundColor = .white
        return textView
    }()
    
    var nameTextViewWidthAnchor: NSLayoutConstraint?
    
    let valueTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 11)
        textView.backgroundColor = .white
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(informationTextView)
        addConstraintsWithFormat("H:|[v0]|", views: informationTextView)
        addConstraintsWithFormat("V:|-4-[v0(28)]", views: informationTextView)
        
        addSubview(nameTextView)
        addSubview(valueTextView)
        
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        valueTextView.translatesAutoresizingMaskIntoConstraints = false
        nameTextViewWidthAnchor = nameTextView.widthAnchor.constraint(equalToConstant: 150)
        [
            nameTextView.topAnchor.constraint(equalTo: informationTextView.bottomAnchor, constant: 4),
            nameTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            nameTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextViewWidthAnchor
        ].forEach {
            if let constraint = $0 {
                constraint.isActive = true
            }
        }
        [
            valueTextView.topAnchor.constraint(equalTo: informationTextView.bottomAnchor, constant: 4),
            valueTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            valueTextView.leadingAnchor.constraint(equalTo: nameTextView.trailingAnchor, constant: 8),
            valueTextView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ].forEach { $0.isActive = true }
    }
}

class DSSAppDetailHeader: DSSBaseCell {
    
    var app: DSSApp? {
        didSet {
            if let imageName = app?.ImageName {
                imageView.image = UIImage(named: imageName)
            }
            
            nameLabel.text = app?.Name
            
            if let price = app?.Price {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = .gray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        addSubview(imageView)
        addSubview(nameLabel)
        addConstraintsWithFormat("H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat("V:|-14-[v0(100)]", views: imageView)
        addConstraintsWithFormat("V:|-14-[v0(20)]", views: nameLabel)
        
        addSubview(segmentedControl)
        addSubview(buyButton)
        addSubview(dividerLineView)
        addConstraintsWithFormat("H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat("V:[v0(32)]-12-[v1(34)]-8-[v2(0.5)]|", views: buyButton, segmentedControl, dividerLineView)
        addConstraintsWithFormat("H:[v0(60)]-14-|", views: buyButton)
        addConstraintsWithFormat("H:|[v0]|", views: dividerLineView)
    }
}

extension UIView {
    func addConstraintsWithFormat(_ formatString: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        views.enumerated().forEach {
            let key = "v\($0.offset)"
            viewsDictionary[key] = $0.element
            $0.element.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

class DSSBaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    
    func widthWithConstrainedWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.width
    }
}
