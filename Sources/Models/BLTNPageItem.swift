//
//  BLTNPageItem.swift
//  BLTNBoard
//
//  Created by Roberto Casula on 20/07/2019.
//  Copyright © 2019 Bulletin. All rights reserved.
//

import UIKit

/**
 * A standard bulletin item with a title and optional additional informations. It can display a large
 * action button and a smaller button for alternative options.
 *
 * - If you need to display custom elements with the standard buttons, subclass `BLTNPageItem` and
 * implement the `makeArrangedSubviews` method to return the elements to display above the buttons.
 *
 * You can also override this class to customize button tap handling. Override the `actionButtonTapped(sender:)`
 * and `alternativeButtonTapped(sender:)` methods to handle tap events. Make sure to call `super` in your
 * implementations if you do.
 *
 * Use the `appearance` property to customize the appearance of the page. If you want to use a different interface
 * builder type, change the `interfaceBuilderType` property.
 */

open class BLTNPageItem: BLTNActionItem {

    // MARK: - Page Contents

    /// The title of the page.
    public let title: String

    /**
     * An image to display below the title.
     *
     * If you set this property to `nil`, no image will be displayed (this is the default).
     *
     * The image should have a size of 128x128 pixels (@1x).
     */

    public var image: UIImage?

    /// An accessibility label which gets announced to VoiceOver users if the image gets focused.
    public var imageAccessibilityLabel: String?

    /**
     * An description text to display below the image.
     *
     * If you set this property to `nil`, no label will be displayed (this is the default).
     */

    public var descriptionText: String?

    /**
     * An attributed description text to display below the image.
     *
     * If you set this property to `nil`, no label will be displayed (this is the default). The attributed
     * text takes priority over the regular description label. If you set both values, only the
     * `attributedDescriptionText` will be used.
     */

    public var attributedDescriptionText: NSAttributedString?


    // MARK: - View Management

    open var titleLabel: BLTNTitleLabelContainer?
    open var descriptionLabel: UILabel?
    open var imageView: UIImageView?


    // MARK: - Init

    /**
     * Creates a bulletin page with the specified title.
     * - parameter title: The title of the page.
     */

    public init(title: String) {
        self.title = title
        self.image = nil
        self.imageAccessibilityLabel = nil
        self.descriptionText = nil
        self.titleLabel = nil
        self.descriptionLabel = nil
        self.imageView = nil
        super.init()
    }


    // MARK: - View Management

    open override func makeContentViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView] {
        var contentViews: [UIView] = []

        if let headerViews = makeHeaderViews(with: interfaceBuilder) {
            contentViews.append(contentsOf: headerViews)
        }

        // Title label

        self.titleLabel = interfaceBuilder.makeTitleLabel()
        self.titleLabel?.label.text = title
        if let titleLabel = self.titleLabel {
            contentViews.append(titleLabel)
            if let viewsUnderTitle = makeViewsUnderTitle(with: interfaceBuilder) {
                contentViews.append(contentsOf: viewsUnderTitle)
            }
        }

        let stackView = interfaceBuilder.makeScrollableStack()
        var stackSubviews: [UIView] = []
        var contentHeight: CGFloat = 0

        // Image View
        if let image = self.image {
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = appearance.imageViewTintColor
            if let accessibilityLabel = imageAccessibilityLabel {
                imageView.isAccessibilityElement = true
                imageView.accessibilityLabel = accessibilityLabel
            }
            self.imageView = imageView
//            contentViews.append(imageView)
            stackSubviews.append(imageView)
            if let viewsUnderImage = makeViewsUnderImage(with: interfaceBuilder) {
//                contentViews.append(contentsOf: viewsUnderImage)
                stackSubviews.append(contentsOf: viewsUnderImage)
            }
        }

        // Description Label

        if let attributedDescription = attributedDescriptionText {
            self.descriptionLabel = interfaceBuilder.makeDescriptionLabel()
            self.descriptionLabel?.attributedText = attributedDescription
        } else if let description = descriptionText {
            self.descriptionLabel = interfaceBuilder.makeDescriptionLabel()
            self.descriptionLabel?.text = description
        }

        if let descriptionLabel = descriptionLabel {
//            contentViews.append(descriptionLabel)
            stackSubviews.append(descriptionLabel)
            if let viewsUnderDescription = makeViewsUnderDescription(with: interfaceBuilder) {
//                contentViews.append(contentsOf: viewsUnderDescription)
                stackSubviews.append(contentsOf: viewsUnderDescription)
            }
        }

        let maxWidth = self.maxWidth
        stackSubviews.forEach { view in
//            contentHeight += view.intrinsicContentSize.height
            contentHeight += view.sizeThatFits(.init(width: maxWidth, height: 0)).height
            stackView.stackView.addArrangedSubview(view)
        }

        contentHeight += CGFloat(stackSubviews.count) * stackView.spacing

        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentHeight).isActive = true
        contentViews.append(stackView)

        return contentViews
    }


    // MARK: - Customization

    /**
     * The views to display above the title.
     *
     * You can override this method to insert custom views before the title. The default implementation returns `nil` and
     * does not append header elements.
     *
     * This method is called inside `makeArrangedSubviews` before the title is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the title.
     * - returns: The header views for the item, or `nil` if no header views should be added.
     */

    open func makeHeaderViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        return nil
    }

    /**
     * The views to display below the title.
     *
     * You can override this method to insert custom views after the title. The default implementation returns `nil` and
     * does not append elements after the title.
     *
     * This method is called inside `makeArrangedSubviews` after the title is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the title.
     * - returns: The views to display after the title, or `nil` if no views should be added.
     */

    open func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        return nil
    }

    /**
     * The views to display below the image.
     *
     * You can override this method to insert custom views after the image. The default implementation returns `nil` and
     * does not append elements after the image.
     *
     * This method is called inside `makeArrangedSubviews` after the image is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the image.
     * - returns: The views to display after the image, or `nil` if no views should be added.
     */

    open func makeViewsUnderImage(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        return nil
    }

    /**
     * The views to display below the description.
     *
     * You can override this method to insert custom views after the description. The default implementation
     * returns `nil` and does not append elements after the description.
     *
     * This method is called inside `makeArrangedSubviews` after the description is created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the description.
     * - returns: The views to display after the description, or `nil` if no views should be added.
     */

    open func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        return nil
    }
}


//extension UIScreen {
//
//    public var safeAreaInsets: UIEdgeInsets? {
//        guard let rootView = UIApplication.shared.keyWindow else { return .zero }
//        if let mainController = rootView.rootViewController as? MainController,
//            let selectedController = mainController.selectedViewController as? UINavigationController,
//            let topController = selectedController.topViewController {
//            return topController.view?.safeAreaInsets ?? selectedController.view?.safeAreaInsets ?? rootView.safeAreaInsets
//        }
//        return rootView.safeAreaInsets
////        guard let rootController = rootView.rootViewController else { return rootView.safeAreaInsets }
////        return rootController.view.safeAreaInsets
//    }
//}
