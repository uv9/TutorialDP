//
//  HorizontalScroller.swift
//  BlueLibrarySwift
//
//  Created by Udit on 11/09/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import UIKit

@objc protocol HorizontalScrollerDelegate {
    // ask the delegate how many views he wants to present inside the horizontal scroller
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int
    // ask the delegate to return the view that should appear at <index>
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index:Int) -> UIView
    // inform the delegate what the view at <index> has been clicked
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index:Int)
    // ask the delegate for the index of the initial view to display. this method is optional
    // and defaults to 0 if it's not implemented by the delegate
    optional func initialViewIndex(scroller: HorizontalScroller) -> Int
}
class HorizontalScroller: UIView {
    weak var delegate: HorizontalScrollerDelegate?
    
    // 1
    private let VIEW_PADDING = 10
    private let VIEW_DIMENSIONS = 100
    private let VIEWS_OFFSET = 100
    
    // 2
    private var scroller : UIScrollView!
    // 3
    var viewArray = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }
    
    func initializeScrollView() {
        //1
        scroller = UIScrollView()
        scroller.delegate = self
        addSubview(scroller)
        
        //2
        scroller.setTranslatesAutoresizingMaskIntoConstraints(false)
        //3
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        //4
        let tapRecognizer = UITapGestureRecognizer(target: self, action:Selector("scrollerTapped:"))
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    func viewAtIndex(index :Int) -> UIView {
        return viewArray[index]
    }
    
    func scrollerTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(gesture.view)
        if let delegate = delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                let view = scroller.subviews[index] as! UIView
                if CGRectContainsPoint(view.frame, location) {
                    delegate.horizontalScrollerClickedViewAtIndex(self, index: index)
                    scroller.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, y: 0), animated:true)
                    break
                }
            }
        }
    }
    
    override func didMoveToSuperview() {
        reload()
    }
    
    func reload() {
        // 1 - Check if there is a delegate, if not there is nothing to load.
        if let delegate = delegate {
            //2 - Will keep adding new album views on reload, need to reset.
            viewArray = []
            let views: NSArray = scroller.subviews
            
            // 3 - remove all subviews
            for view in views {
                view.removeFromSuperview()
            }
            
            // 4 - xValue is the starting point of the views inside the scroller
            var xValue = VIEWS_OFFSET
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                // 5 - add a view at the right position
                xValue += VIEW_PADDING
                let view = delegate.horizontalScrollerViewAtIndex(self, index: index)
                view.frame = CGRectMake(CGFloat(xValue), CGFloat(VIEW_PADDING), CGFloat(VIEW_DIMENSIONS), CGFloat(VIEW_DIMENSIONS))
                scroller.addSubview(view)
                xValue += VIEW_DIMENSIONS + VIEW_PADDING
                // 6 - Store the view so we can reference it later
                viewArray.append(view)
            }
            // 7
            scroller.contentSize = CGSizeMake(CGFloat(xValue + VIEWS_OFFSET), frame.size.height)
            
            // 8 - If an initial view is defined, center the scroller on it
            if let initialView = delegate.initialViewIndex?(self) {
                scroller.setContentOffset(CGPoint(x: CGFloat(initialView)*CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING))), y: 0), animated: true)
            }
        }
    }
    
    func centerCurrentView() {
        var xFinal = Int(scroller.contentOffset.x) + (VIEWS_OFFSET/2) + VIEW_PADDING
        let viewIndex = xFinal / (VIEW_DIMENSIONS + (2*VIEW_PADDING))
        xFinal = viewIndex * (VIEW_DIMENSIONS + (2*VIEW_PADDING))
        scroller.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        if let delegate = delegate {
            delegate.horizontalScrollerClickedViewAtIndex(self, index: Int(viewIndex))
        }  
    }
}

extension HorizontalScroller: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerCurrentView()
    }
}