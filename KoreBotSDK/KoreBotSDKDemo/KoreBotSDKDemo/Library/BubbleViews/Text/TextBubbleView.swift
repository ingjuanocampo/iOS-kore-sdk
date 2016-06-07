//
//  TextBubbleView.swift
//  KoreBotSDKDemo
//
//  Created by Srinivas Vasadi on 09/05/16.
//  Copyright © 2016 Kore. All rights reserved.
//

import UIKit
import ActiveLabel

class TextBubbleView : BubbleView {

    func kTextColor() -> UIColor {
        return (self.tailPosition == BubbleMaskTailPosition.Left ? Common.UIColorRGB(0x484848) : Common.UIColorRGB(0xFFFFFF))
    }
    func kLeftMargin() -> CGFloat {
        return (self.tailPosition == BubbleMaskTailPosition.Left ? 20.0 : 13.0)
    }
    func kRightMargin() -> CGFloat {
        return (self.tailPosition == BubbleMaskTailPosition.Left ? 10.0 : 17.0)
    }
    let kVerticalMargin: CGFloat = 10.0
    let kMaxTextWidth: CGFloat = (BubbleViewMaxWidth)
    
    var textLabel: ActiveLabel!
    var text: String! {
        didSet {
            self.textLabel.text = text
            self.invalidateIntrinsicContentSize()
        }
    }
    override var components: NSArray! {
        didSet {
            if (components.count > 0) {
                let component: TextComponent = components[0] as! TextComponent
                
                if (!component.isKindOfClass(TextComponent)) {
                    return;
                }
                
                self.text = component.text! as String
            }
        }
    }
    
    override var tailPosition: BubbleMaskTailPosition! {
        didSet {
            self.setNeedsLayout()
            self.textLabel.textColor = self.kTextColor()
        }
    }
    
    override init() {
        super.init()
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        super.initialize()
        
        self.textLabel = ActiveLabel()
        self.textLabel.font = UIFont(name:"HelveticaNeue", size:16.0)
        self.textLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.textLabel.numberOfLines = 0;
        self.textLabel.text = ""
        
//        self.bubbleTrailingConstraint = NSLayoutConstraint(item:self.contentView, attribute:.Trailing, relatedBy:.Equal, toItem:self.bubbleContainerView, attribute:.Trailing, multiplier:1.0, constant:16.0)

        self.addSubview(self.textLabel);
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let textSize: CGSize = self.textSizeThatFits()
        self.textLabel.frame = CGRectMake(self.kLeftMargin(), self.kVerticalMargin, textSize.width, textSize.height + self.kVerticalMargin)
        self.addConstraint(NSLayoutConstraint(
            item:self, attribute:NSLayoutAttribute.Top,
            relatedBy:NSLayoutRelation.Equal,
            toItem:self.textLabel, attribute:.Top,
            multiplier:1.0, constant:5))
        self.addConstraint(NSLayoutConstraint(
            item:self, attribute:.Bottom,
            relatedBy:NSLayoutRelation.Equal,
            toItem:self.textLabel, attribute:NSLayoutAttribute.Bottom,
            multiplier:1.0, constant:5))

    }

    override func intrinsicContentSize() -> CGSize {
        var textSize: CGSize  = self.textSizeThatFits()
        let minimumWidth: CGFloat = 15
        if textSize.width < minimumWidth {
            textSize.width = minimumWidth
        }
        
        return CGSizeMake(textSize.width + 32, textSize.height + kVerticalMargin * 2.0);
    }

    func textSizeThatFits() -> CGSize {
        let limitingSize: CGSize  = CGSizeMake(kMaxTextWidth , CGFloat.max)
        let rect: CGRect = self.textLabel.text!.boundingRectWithSize(limitingSize,
                                                                    options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                    attributes: [NSFontAttributeName: self.textLabel.font],
                                                                    context: nil)
        return rect.size;
    }
}