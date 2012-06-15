//
//  ViewController.h
//  WebServices
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UISegmentedControl *_getPost;
    IBOutlet UISegmentedControl *_synchAsynch;
    IBOutlet UILabel *_label;  
    
    NSURLConnection *_getConnection;
    NSMutableData *_getData;
    
    NSURLConnection *_postConnection;
    NSMutableData *_postData;    

}
-(IBAction)requestButton;

-(void)updateLabel:(NSData*)data;

-(void)getSynch;
-(void)postSynch;
-(void)getAsynch;
-(void)postAsynch;

@end
