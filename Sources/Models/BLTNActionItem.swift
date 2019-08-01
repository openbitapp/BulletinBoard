//
//  BLTNActionItem.swift
//  BLTNBoard
//
//  Created by Roberto Casula on 20/07/2019.
//  Copyright © 2019 Bulletin. All rights reserved.
//

import UIKit

/**
 * A standard bulletin item with that displays a large action button and a smaller button for alternative options.
 *
 * You do not use this class directly:
 *
 * - If your custom item has a title and optional stock elements (description, image), use `BLTNPageItem`
 * which provides these stock elements. You can also override this class to insert custom views between the stock
 * views.
 *
 * - If you need to display custom elements with the standard buttons on a page without a title, subclass `BLTNActionItem`
 * and implement the `makeContentViews` method to return the elements to display above the buttons.
 *
 * Subclasses can override several methods to customize the UI:
 *
 * - In `footerViews`, return the views to display below the buttons.
 * - In `actionButtonTapped(sender:)` and `alternativeButtonTapped(sender:)`, perform custom additional button handling
 * (ex: haptic feedback).
 *
 * Use the `appearance` property to customize the appearance of the buttons. If you want to use a different interface
 * builder type, change the `interfaceBuilderType` property.
 */

open class BLTNActionItem: NSObject, BLTNItem {

    internal var maxWidth: CGFloat = 0
    internal var maxHeight: CGFloat = 0

    // MARK: - Page Contents

    /**
     * The title of the action button. The action button represents the main action for the item.
     *
     * If you set this property to `nil`, no action button will be added (this is the default).
     */

    private var _actionButtonTitle: String?
    public var actionButtonTitle: String? {
        get {
            return _actionButtonTitle
        }
        set {
            _actionButtonTitle = newValue
            actionButton?.setTitle(newValue, for: .normal)
        }
    }

    /**
     * The title of the alternative button. The alternative button represents a second option for
     * the user.
     *
     * If you set this property to `nil`, no alternative button will be added (this is the default).
     */

    private var _alternativeButtonTitle: String?
    public var alternativeButtonTitle: String? {
        get {
            return _alternativeButtonTitle
        }
        set {
            _alternativeButtonTitle = newValue
            alternativeButton?.setTitle(newValue, for: .normal)
        }
    }

    // MARK: - BLTNItem

    /**
     * The object managing the item.
     *
     * This property is set when the item is currently being displayed. It will be set to `nil` when
     * the item is removed from bulletin.
     */

    public weak var manager: BLTNItemManager?

    /**
     * Whether the page can be dismissed.
     *
     * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
     * of the card or by swiping down.
     *
     * You should set it to `true` for the last item you want to display.
     */

    public var isDismissable: Bool

    /**
     * Whether the page can be dismissed with a close button.
     *
     * The default value is `true`. The user will be able to dismiss the bulletin by tapping on a button
     * in the corner of the screen.
     *
     * You should set it to `false` if the interface of the bulletin already has buttons to dismiss the item,
     * such as an action button.
     */

    public var requiresCloseButton: Bool

    /**
     * Whether the page should start with an activity indicator.
     *
     * Set this value to `false` to display the elements right away. If you set it to `true`,
     * you'll need to call `manager?.hideActivityIndicator()` to show the UI.
     *
     * This defaults to `false`.
     */

    public var shouldStartWithActivityIndicator: Bool

    /**
     * Whether the item should move with the keyboard.
     *
     * You must set it to `true` if the item displays a text field. Otherwise, you can set it to `false` if you
     * don't want the bulletin to move when system alerts are displayed.
     *
     * This value defaults to `true`.
     */

    public var shouldRespondToKeyboardChanges: Bool

    /**
     * The item to display after this one.
     *
     * If you set this value, you'll be able to call `displayNextItem()` to push the next item to
     * the stack.
     */

    public var next: BLTNItem?

    /**
     * The block of code to execute when the bulletin item is presented. This is called after the
     * bulletin is moved onto the view.
     *
     * - parameter item: The item that is being presented.
     */

    public var presentationHandler: ((BLTNItem) -> Void)?

    /**
     * The block of code to execute when the bulletin item is dismissed. This is called when the bulletin
     * is moved out of view.
     *
     * You can leave it `nil` if `isDismissable` is set to false.
     */

    public var dismissalHandler: ((BLTNItem) -> Void)?

    // MARK: - Customization

    /**
     * The appearance manager used to generate the interface of the page.
     *
     * Use this property to customize the appearance of the generated elements.
     *
     * Make sure to customize the appearance before presenting the page. Changing the appearance properties
     * after the bulletin page was presented has no effect.
     */

    public var appearance: BLTNItemAppearance

    /**
     * The type of interface builder to use to generate the components.
     *
     * Make sure to customize this property before presenting the page. Changing the interface builder type
     * after the bulletin page was presented has no effect.
     */

    public var interfaceBuilderType: BLTNInterfaceBuilder.Type


    // MARK: - Buttons

    /**
     * The action button managed by the item.
     */

    public var actionButton: UIButton?

    /**
     * The alternative button managed by the item.
     */

    public var alternativeButton: UIButton?

    /**
     * The code to execute when the action button is tapped.
     */

    public var actionHandler: ((BLTNActionItem) -> Void)?

    /**
     * The code to execute when the alternative button is tapped.
     */

    public var alternativeHandler: ((BLTNActionItem) -> Void)?


    // MARK: - Init

    public override init() {
        self.isDismissable = true
        self.requiresCloseButton = true
        self.shouldStartWithActivityIndicator = false
        self.shouldRespondToKeyboardChanges = true
        self.appearance = .init()
        self.interfaceBuilderType = BLTNInterfaceBuilder.self
        super.init()
        self.actionButtonTitle = nil
        self.alternativeButtonTitle = nil
        self.manager = nil
        self.next = nil
        self.presentationHandler = nil
        self.dismissalHandler = nil
        self.actionButton = nil
        self.alternativeButton = nil
        self.actionHandler = nil
        self.alternativeHandler = nil
    }

    // MARK: - Buttons

    /**
     * Handles a tap on the action button.
     *
     * You can override this method to add custom tap handling. You have to call `super.actionButtonTapped(sender:)`
     * in your implementation.
     */

    @objc open func actionButtonTapped(sender: UIButton) {
        actionHandler?(self)
    }

    /**
     * Handles a tap on the alternative button.
     *
     * You can override this method to add custom tap handling. You have to call `super.alternativeButtonTapped(sender:)`
     * in your implementation.
     */

    @objc open func alternativeButtonTapped(sender: UIButton) {
        alternativeHandler?(self)
    }


    // MARK: - View Management

    /**
     * The views to display below the buttons.
     *
     * You can override this method to insert custom views after the buttons. The default implementation returns `nil` and
     * does not append footer elements.
     *
     * This method is called inside `makeArrangedSubviews` after the buttons are created.
     *
     * - parameter interfaceBuilder: The interface builder used to create the buttons.
     * - returns: The footer views for the item, or `nil` if no footer views should be added.
     */

    public func makeFooterViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        return nil
    }

    /**
     * Creates the content views of the page. Content views are displayed above the buttons.
     *
     * You must override this method to return the elements displayed above the buttons. Your implementation
     * must not call `super`.
     *
     * If you do not implement this method, an exception will be raised.
     *
     * - parameter interfaceBuilder: The interface builder used to create the buttons.
     * - returns: The views to display above the buttons.
     */

    open func makeContentViews(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView] {
        return []
    }

    open func makeScrollableViews(with interfaceBuilder: BLTNInterfaceBuilder) -> ScrollableStackView? {
        return nil
    }

    /**
     * Creates the list of views to display on the bulletin.
     *
     * This is an implementation detail of `BLTNItem` and you should not call it directly. Subclasses should not override this method, and should
     * implement `makeContentViews:` instead.
     */

    public func makeArrangedSubviews() -> [UIView] {
        var arrangedSubviews: [UIView] = []
        var contentViewsHeight: CGFloat = 0
        var scrollableHeight: CGFloat = 0
        let maxWidth = self.maxWidth
        let maxHeight = self.maxHeight

        var index: Int?

        let interfaceBuilder = interfaceBuilderType.init(appearance: appearance, item: self)

        let contentViews = makeContentViews(with: interfaceBuilder)
        arrangedSubviews.append(contentsOf: contentViews)

        let scrollableView = makeScrollableViews(with: interfaceBuilder)
        if let scrollable = scrollableView {
            scrollable.stackView.arrangedSubviews.forEach { view in
                scrollableHeight += view.sizeThatFits(.init(width: maxWidth, height: 0)).height
            }

            scrollableHeight += CGFloat(scrollable.stackView.arrangedSubviews.count - 1) * scrollable.stackView.spacing

            index = arrangedSubviews.count
        }

        // Buttons stack

        if actionButtonTitle == nil && alternativeButtonTitle == nil {
            return arrangedSubviews
        }

        let buttonsStack = interfaceBuilder.makeGroupStack(spacing: 10)

        if let actionButtonTitle = actionButtonTitle {
            let buttonWrapper = interfaceBuilder.makeActionButton(title: actionButtonTitle)
            buttonsStack.addArrangedSubview(buttonWrapper)
            self.actionButton = buttonWrapper.button
        }

        if let alternativeButtonTitle = alternativeButtonTitle {
            let alternativeButtonWrapper = interfaceBuilder.makeActionButton(title: alternativeButtonTitle)
            buttonsStack.addArrangedSubview(alternativeButtonWrapper)
            self.alternativeButton = alternativeButtonWrapper.button
        }

        arrangedSubviews.append(buttonsStack)

        // Footer

        if let footerViews = makeFooterViews(with: interfaceBuilder) {
            arrangedSubviews.append(contentsOf: footerViews)
        }

        if let scrollable = scrollableView, let i = index {
            arrangedSubviews.forEach { view in
                contentViewsHeight += view.intrinsicContentSize.height
            }

            contentViewsHeight += CGFloat(arrangedSubviews.count - 1) * scrollable.stackView.spacing

            if scrollableHeight >= maxHeight {
                scrollableHeight = maxHeight - contentViewsHeight - (2 * scrollable.stackView.spacing)
            }

            scrollable.heightAnchor.constraint(equalToConstant: scrollableHeight).isActive = true
            arrangedSubviews.insert(scrollable, at: i)
        }

        return arrangedSubviews

    }


    // MARK: - Events

    /**
     * Called by the manager when the item was added to the bulletin.
     *
     * Override this function to configure your managed views, and allocate any resources required
     * for this item. Make sure to call `super` if you override this method.
     */

    open func setUp() {
        actionButton?.addTarget(self, action: #selector(actionButtonTapped(sender:)),
                                for: .touchUpInside)

        alternativeButton?.addTarget(self, action: #selector(alternativeButtonTapped(sender:)),
                                     for: .touchUpInside)
    }

    /**
     * Called by the manager when the item was removed from the bulletin view.
     *
     * Override this method if elements you returned in `makeContentViews` need cleanup. Make sure
     * to call `super` if you override this method.
     *
     * This is an implementation detail of `BLTNItem` and you should not call it directly.
     */

    open func tearDown() {
        actionButton?.removeTarget(self, action: nil, for: .touchUpInside)
        alternativeButton?.removeTarget(self, action: nil, for: .touchUpInside)
        self.actionButton = nil
        self.alternativeButton = nil
    }

    /**
    * Called by the manager when bulletin item is about to be pushed onto the view.
    */

    open func willDisplay() {}

    /**
     * Called by the manager when bulletin item is pushed onto the view.
     *
     * By default, this method calls trhe `presentationHandler` of the action item. Override this
     * method if you need to perform additional preparation after presentation (although using
     * `setUp` is preferred).
     */

    open func onDisplay() {
        presentationHandler?(self)
    }

    /**
     * Called by the manager when bulletin item is dismissed. This is called after the bulletin
     * is moved out of view.
     *
     * By default, this method calls trhe `dismissalHandler` of the action item. Override this
     * method if you need to perform additional cleanup after dismissal (although using
     * `tearDown` is preferred).
     */

    open func onDismiss() {
        dismissalHandler?(self)
    }

}
