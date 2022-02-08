//
//  CGAGridViewCell.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//

import UIKit
import CoreGraphics

/*
	See layoutSubviews() below
 */
extension CGRect {
	@inlinable func rounded() -> CGRect {
		return CGRect(x: round(origin.x), y: round(origin.y), width: round(size.width), height: round(size.height))
	}
}

class CVAGridViewCell: UICollectionViewCell {
	
	/*
		Keyboard focus & cell selection are two different things, so conceptually it is
		important to remember that they may not necessarily be linked. In this example,
		we're using two different 'selection' styles to underscore that.
	 
		As of macOS 12.1, multi-select (drag-select) handles focus state incorrectly,
		so as soon as that behavior is improved this distinction may not be necessary.
	 */
	
	let selectionRingView = UIView()

	let imageContainerView = UIView()
	let imageView = UIImageView()
	
	let titleContainerView = UIView()
	let titleLabel = UILabel()
	
	@objc var showFocusRing:Bool = false {
		didSet {
			if showFocusRing {
				titleContainerView.backgroundColor = .systemBlue
				titleLabel.textColor = .white
			}
			else {
				titleContainerView.backgroundColor = .clear
				titleLabel.textColor = .label
			}
		}
	}
	
	@objc var showSelectionRing:Bool = false {
		didSet {
			if showSelectionRing {
				selectionRingView.alpha = 1
			}
			else {
				selectionRingView.alpha = 0
			}
		}
	}
	
	override var isSelected: Bool {
		didSet {
			showSelectionRing = isSelected
		}
	}

	// MARK: -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		imageView.layer.cornerCurve = .continuous
		imageView.layer.cornerRadius = UIFloat(8)
		imageView.layer.masksToBounds = true
		
		imageContainerView.layer.borderWidth = UIFloat(1.0)
		imageContainerView.layer.borderColor = UIColor.separator.cgColor
		
		imageContainerView.layer.cornerCurve = .continuous
		imageContainerView.layer.cornerRadius = UIFloat(8)

		imageContainerView.layer.shadowColor = UIColor.black.cgColor
		imageContainerView.layer.shadowRadius = UIFloat(8)
		imageContainerView.layer.shadowOpacity = 0.2
		imageContainerView.layer.shadowOffset = CGSize(width: 0, height: UIFloat(2))
			
		/* Selection Highlight */
		
		selectionRingView.alpha = 0
		
		selectionRingView.layer.cornerRadius = UIFloat(8)
		
		contentView.addSubview(selectionRingView)

		/* Title & Selection Area  */

		titleLabel.textAlignment = .center
		
		titleContainerView.addSubview(titleLabel)
		
		titleContainerView.layer.cornerRadius = UIFloat(8)
		titleContainerView.backgroundColor = .clear
		
		contentView.addSubview(titleContainerView)
		
		/* Image View */
		
		imageView.contentMode = .scaleAspectFill
		
		imageContainerView.addSubview(imageView)
		contentView.addSubview(imageContainerView)

	
		if #available(macCatalyst 15.0, iOS 15.0, *) {
			focusEffect = nil
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Layout -
	
	override func layoutSubviews() {
		super.layoutSubviews() // Always call super
		
		let contentBounds = contentView.bounds
		
		imageView.layer.cornerRadius = UIFloat(8)
		titleContainerView.layer.cornerRadius = UIFloat(8)
		selectionRingView.layer.cornerRadius = UIFloat(8)

		/*
		 Here, the aspect ratio is hard-coded for this demo. But in a real app dealing with
		 photos you might have this ratio stored or calculated in your data model
		 */
		let insetBounds = contentBounds.insetBy(dx:UIFloat(12), dy:UIFloat(12))
		let aspectRatio = 9.0 / 16.0
		
		let desiredWidth = insetBounds.width
		let desiredHeight = insetBounds.width * aspectRatio
		
		imageContainerView.frame = CGRect(x: insetBounds.origin.x + (insetBounds.width-desiredWidth)/2, y: insetBounds.origin.y + (insetBounds.height-desiredHeight)/2, width: desiredWidth, height: desiredHeight)
		imageView.frame = imageContainerView.bounds

		selectionRingView.frame = contentBounds
		
		let titleDivision = contentBounds.divided(atDistance: imageContainerView.frame.origin.y + imageContainerView.frame.size.height, from: .minYEdge)
		let titleAreaFrame = titleDivision.remainder
		
		titleLabel.sizeToFit()
		titleLabel.frame = CGRect(x: UIFloat(6), y: UIFloat(2), width: titleLabel.frame.width, height: titleLabel.frame.height)
		
		let titleContainerBounds = titleLabel.frame.insetBy(dx: -UIFloat(6), dy: -UIFloat(2))
		
		/*
			If you don't round your text layout properly, you'll end up drawing on a half-pixel
			and getting blurry text. Blurry text is something users will notice immediately.
		 
			Here I'm rounding using a trivial extension on CGRect (as above)
		 */
		titleContainerView.frame = CGRect(x: titleAreaFrame.origin.x + (titleAreaFrame.width-titleContainerBounds.width)/2, y: titleAreaFrame.origin.y + (titleAreaFrame.height-titleContainerBounds.height)/2, width: titleContainerBounds.width, height: titleContainerBounds.height).rounded()
	}
	
	// MARK: Trait Changes -
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		/* CALayer color properties don't automatically update when Light/Dark mode changes */
		imageContainerView.layer.borderColor = UIColor.separator.cgColor
		selectionRingView.layer.backgroundColor = UIColor.systemFill.cgColor
	}
	
	// MARK: - Focus Support
	
	override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		
		super.didUpdateFocus(in: context, with: coordinator)
		
		// customize the border of the cell instead of putting a focus ring on top of it.
		if context.nextFocusedItem === self {
			showFocusRing = true
		}
		else if context.previouslyFocusedItem === self {
			showFocusRing = false
		}
	}
}
