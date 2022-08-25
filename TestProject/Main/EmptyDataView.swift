//
//  EmptyDataView.swift
//  TestProject
//
//  Created by Bas on 25/8/2565 BE.
//

import UIKit

@IBDesignable
@objc class EmptyDataView: UIView {
    
    var view = UIView()
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        view.superview?.backgroundColor = .clear
       
        addSubview(view)
        view.backgroundColor = .clear
        
        titleLabel.text = title
        imageView.image = image
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EmptyDataView", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        }
        return UIView()
    }
    
    @objc func setup(image: UIImage?, title: String, subTitle: String? = nil) {
        imageView.image = image
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        if subTitle == nil {
            subTitleLabel.isHidden = true
        }
    }
    
    @IBInspectable @objc var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    @IBInspectable @objc var titleTextColor: UIColor? = #colorLiteral(red: 0.3019607843, green: 0.3137254902, blue: 0.4705882353, alpha: 1) {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    
    @IBInspectable @objc var subTitle: String? {
        set {
            subTitleLabel.text = newValue
        }
        get {
            return subTitleLabel.text
        }
    }
    
    @IBInspectable @objc var subTitleTextColor: UIColor? = #colorLiteral(red: 0.3019607843, green: 0.3137254902, blue: 0.4705882353, alpha: 1) {
        didSet {
            subTitleLabel.textColor = subTitleTextColor
        }
    }
    
    @IBInspectable var image: UIImage? = UIImage(named: "logo")
}
