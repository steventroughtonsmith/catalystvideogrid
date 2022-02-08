//
//  CGAGridViewController.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//

import UIKit
import Foundation


class CVAGridViewController: UICollectionViewController {
	
	let reuseIdentifier = "Cell"
	let padding = UIFloat(4)
	
	var lastSelectionTimestamp = TimeInterval.zero
	var lastSelectionIndexPath = IndexPath()
	
	enum HIGridSection {
		case main
	}
	
	struct HIGridItem: Hashable {
		var title: String = ""
		var image: String = ""
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(identifier)
		}
		static func == (lhs: HIGridItem, rhs: HIGridItem) -> Bool {
			return lhs.identifier == rhs.identifier
		}
		private let identifier = UUID()
	}
	
	var dataSource: UICollectionViewDiffableDataSource<HIGridSection, HIGridItem>! = nil
	
	init() {
		let layout = UICollectionViewFlowLayout()
		
		super.init(collectionViewLayout: layout)
		
		guard let collectionView = collectionView else { return }
		
		title = "Videos"
		
		collectionView.remembersLastFocusedIndexPath = true
		collectionView.selectionFollowsFocus = true
		
		if #available(iOS 15.0, *) {
			collectionView.allowsFocus = true
		}
		
		collectionView.backgroundColor = .systemBackground
		collectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		collectionView.register(CVAGridViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		configureDataSource()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Data Source -
	
	func configureDataSource() {
		
		dataSource = UICollectionViewDiffableDataSource<HIGridSection, HIGridItem>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, item: HIGridItem) -> UICollectionViewCell? in
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
			
			if let cell = cell as? CVAGridViewCell {
				/*
				 Customize cell here
				 */
				
				cell.titleLabel.text = item.title
				cell.imageView.image = UIImage(named:item.image)
			}
			
			return cell
		}
		
		collectionView.dataSource = dataSource
		
		refresh()
	}
	
	
	func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<HIGridItem> {
		var snapshot = NSDiffableDataSourceSectionSnapshot<HIGridItem>()
		
		var items:[HIGridItem] = []
		
		/* Just some dummy items to populate the grid */
		for _ in 0 ..< 5 {
			
			var item = HIGridItem()
			item.title = "Big Buck Bunny"
			item.image = "Thumbnail"
			items.append(item)
		}
		
		snapshot.append(items)
		
		return snapshot
	}
	
	func refresh() {
		guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<HIGridSection, HIGridItem> else { return }
		
		dataSource.apply(initialSnapshot(), to: .main, animatingDifferences: false)
	}
	
	// - MARK: Manual Layout Sizing (Fast)
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		var columns = 3
		let threshold = UIFloat(400)
		
		guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
		
		while view.bounds.size.width/CGFloat(columns) > threshold
		{
			columns += 1
		}
		
		let frame = view.bounds.inset(by: collectionView.contentInset)
		
		let itemSize = (frame.width - padding*CGFloat(columns-1)) / CGFloat(columns)
		
		layout.itemSize = CGSize(width: itemSize, height: itemSize * 0.8)
		layout.minimumLineSpacing = padding
		layout.minimumInteritemSpacing = 0
	}
	
	// MARK: -
	
	override var canBecomeFirstResponder:Bool {
		return true
	}
	
	// MARK: Selection
	
	override func collectionView(_ collectionView: UICollectionView, selectionFollowsFocusForItemAt indexPath: IndexPath) -> Bool {
		return (UIDevice.current.userInterfaceIdiom == .mac) ? true : false
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		/* Wait for a double-click on macOS */
		if UIDevice.current.userInterfaceIdiom == .mac {
			if Date.timeIntervalSinceReferenceDate - lastSelectionTimestamp < doubleClickInterval && indexPath == lastSelectionIndexPath {
				actuateItem(at: indexPath)
			}
			
			lastSelectionTimestamp = Date.timeIntervalSinceReferenceDate
			lastSelectionIndexPath = indexPath
		}
		else {
			actuateItem(at: indexPath)
		}
	}
	
	func actuateItem(at: IndexPath) {
		/*
		 TODO:
		 Perhaps add some logic here to determine whether the app is running
		 in fullscreen on macOS, and instead of spawning a new window behave
		 like iOS and display it inside the main window.
		 
		 A good way to figure out if you're running in fullscreen is by
		 checking window.safeAreaInsets.top == 0, as fullscreen mode will
		 not generally have a titlebar.
		 */
		
		if UIDevice.current.userInterfaceIdiom == .mac {

			let activity = NSUserActivity(activityType: "com.example.video.scene")
			
			UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
		}
		else {
			let vc = CVAVideoViewController()
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	@objc func actuateCurrentlySelectedItem() {
		actuateItem(at: lastSelectionIndexPath)
	}
	
	// MARK: - Commands
	
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(input: "\r", modifierFlags: [], action: #selector(actuateCurrentlySelectedItem))]
	}
	
	// MARK: - Double Click
	
	@objc var doubleClickInterval:TimeInterval {
		get {
			let staticInterval = 0.5
			
#if targetEnvironment(macCatalyst)
			/*
			 This gets the system double-click interval using AppKit. If it can't,
			 it falls back to 0.5 seconds as above
			 */
			if let NSEvent = NSClassFromString("NSEvent") as? NSObject.Type {
				if let interval = NSEvent.value(forKey: "doubleClickInterval") as? Double {
					return interval
				}
			}
			
#endif
			
			return staticInterval
		}
	}
}
