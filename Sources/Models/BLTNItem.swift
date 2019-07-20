//
//  BLTNItem.swift
//  BLTNBoard
//
//  Created by Roberto Casula on 20/07/2019.
//  Copyright © 2019 Bulletin. All rights reserved.
//

import UIKit

@objc public protocol BLTNItem: class {

    // MARK: - Configuration

    /**
     * The current object managing the item.
     *
     * This property is set when the item is currently being displayed. It will be set to `nil` when
     * the item is removed from view.
     *
     * When implementing `BLTNItem`, you should mark this property `weak` to avoid retain cycles.
     */

    var manager: BLTNItemManager? { get set }

    /**
     * Whether the page can be dismissed.
     *
     * If you set this value to `true`, the user will be able to dismiss the bulletin by tapping outside
     * of the card or by swiping down.
     *
     * You should set it to `true` for the last item you want to display, or for items that start an optional flow
     * (ex: a purchase).
     */

    var isDismissable: Bool { get set }

    /**
     * Whether the page can be dismissed with a close button.
     *
     * The default value is `true`. The user will be able to dismiss the bulletin by tapping on a button
     * in the corner of the screen.
     *
     * You should set it to `false` if the interface of the bulletin already has buttons to dismiss the item,
     * such as an action button.
     */

    var requiresCloseButton: Bool { get set }

    /**
     * Whether the card should start with an activity indicator.
     *
     * Set this value to `false` to display the elements right away. If you set it to `true`,
     * you'll need to call `manager?.hideActivityIndicator()` to show the UI.
     */

    var shouldStartWithActivityIndicator: Bool { get set }

    /**
     * Whether the item should move with the keyboard.
     *
     * You must set it to `true` if the item displays a text field. You can set it to `false` if you
     * don't want the bulletin to move when system alerts containing a text field (ex: iTunes login)
     * are displayed.
     */

    var shouldRespondToKeyboardChanges: Bool { get set }

    /**
     * The item to display after this one.
     *
     * If you set this value, you'll be able to call `manager?.displayNextItem()` to push the next item to
     * the stack.
     */

    var next: BLTNItem? { get set }


    // MARK: - Interface

    /**
     * Creates the list of views to display inside the bulletin card.
     *
     * The views will be arranged vertically, in the order they are stored in the return array.
     */

    func makeArrangedSubviews() -> [UIView]

    /**
     * Called by the manager when the item was added to the bulletin.
     *
     * Use this function to configure your managed views, and allocate any resources required
     * for this item.
     */

    func setUp()

    /**
     * Called by the manager when the item was removed from the bulletin.
     *
     * Use this function to remove any button target or gesture recognizers from your managed views, and
     * deallocate any resources created for this item that are no longer needed.
     */

    func tearDown()

    /**
    * Called by the manager when bulletin item is about to be pushed onto the view.
    */


    func willDisplay()

    /**
     * Called by the manager when bulletin item is pushed onto the view.
     */

    func onDisplay()

    /**
     * Called by the manager when bulletin item is dismissed. This is called after the bulletin
     * is moved out of view.
     */

    func onDismiss()
}
