//
//  ModalInstructionsViewController.h
//  Memory Training
//
//  Created by Thomas Deegan on 8/11/13.
//
//

#import <UIKit/UIKit.h>

@protocol ModalInstructionControlGroup <NSObject>

-(void)doneWithInstructions:(id)controller;

@end

@interface ModalInstructionsViewController : UIViewController {
    id <ModalInstructionControlGroup> _delegate;
    UITextView* _instructions;
}
@property (nonatomic, retain) id <ModalInstructionControlGroup> delegate;
-(void)setText:(NSString*)instructons;
@end
