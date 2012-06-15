//
//  ViewController.m
//  WebServices
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ViewController.h"
#import "CiPuP.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // [CiPuP displayAlertWithMessage:@"Ma super méthode"];
    
//    if(![CiPuP isNetworkAvailable])
//    {
//        [CiPuP displayAlertWithMessage:@"pas de réseau disponible"];
//    }
//    else 
//    {
//        //utilisation du webservice
//    }
    
}

-(IBAction)requestButton 
{
    //Cas 1 : Segment 1 sur GET et Segment 2 sur Synchrone 
    if(_getPost.selectedSegmentIndex == 0 && _synchAsynch.selectedSegmentIndex == 0)
    {
        [self getSynch];
    }
    //Cas 2 : Segment 1 sur POST et Segment 2 sur Synchrone 
    else if(_getPost.selectedSegmentIndex == 1 && _synchAsynch.selectedSegmentIndex == 0)
    {
        [self postSynch];
    }
    //Cas 3 : Segment 1 sur GET et Segment 2 sur Asynchrone 
    else if(_getPost.selectedSegmentIndex == 0 && _synchAsynch.selectedSegmentIndex == 1)
    {
        [self getAsynch];
    }
    //Cas 4 : Segment 1 sur POST et Segment 2 sur Asynchrone 
    else 
    {
        [self postAsynch];
    }
}

//méthode pour afficher une NSData dans notre label
-(void)updateLabel:(NSData*)data{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _label.text = message;
}

-(void)getSynch 
{
    //Vérification de la disponibilité du réseau
    if(![CiPuP isNetworkAvailable])
    {
        [CiPuP displayAlertWithMessage:@"pas de réseau disponible"];
    }
    else 
    {
        //On passe le paramètre dans l'url => méthode GET
        NSURL *url = [[NSURL alloc] initWithString:@"http://www.ipup.fr/livre/getPost?parametre=get_synch"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLResponse *reponse = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
        //l'application va bloquer ici le temps de faire la requéte.
        [self updateLabel:data];
        if(error)
        {
            //On affiche la description de l'erreur
            [CiPuP displayAlertWithMessage:[error localizedDescription]];    
        }
    }
}

-(void)postSynch 
{
    //Vérification de la disponibilité du réseau
    if(![CiPuP isNetworkAvailable])
    {
        [CiPuP displayAlertWithMessage:@"pas de réseau disponible"];
    }
    else 
    {
        NSURL *url = [NSURL URLWithString:@"http://www.ipup.fr/livre/getPost"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //On passe le paramètre dans le corps de la requête => méthode POST
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[@"parametre=post_synch" dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLResponse *reponse = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
        //l'application va bloquer ici le temps de faire la requéte.
        [self updateLabel:data];
        if(error)
        {
            //On affiche la description de l'erreur
            [CiPuP displayAlertWithMessage:[error localizedDescription]];    
        }
    }
}

-(void)getAsynch
{
    //On passe le paramètre dans l'url => méthode GET
    NSURL *url = [NSURL URLWithString:@"http://www.ipup.fr/livre/getPost?parametre=get_a_synch"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    _getConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _getData = [NSMutableData data];
}

-(void)postAsynch
{    
    NSURL *url = [NSURL URLWithString:@"http://www.ipup.fr/livre/getPost"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //On passe le paramètre dans le corps de la requête => méthode POST
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[@"parametre=post_a_synch" dataUsingEncoding:NSUTF8StringEncoding]];
    _postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _postData = [NSMutableData data];
}
#pragma mark - NSURLConnection delegate

//méthode appelée de manière asynchrone lorsque la connexion reçoit des données.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    if(connection == _getConnection)
    {
        [_getData appendData:data];
    }
    else if(connection == _postConnection)
    {
        [_postData appendData:data];
    }
}

//Méthode appelée en cas d'erreur
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(connection == _getConnection)
    {
        _getData = nil;
    }
    else if(connection == _postConnection)
    {
        _postData = nil;
    }
    //On affiche la description de l'erreur
    [CiPuP displayAlertWithMessage:[error localizedDescription]];
}

//méthode appelée lorsque le téléchargement est terminé
- (void) connectionDidFinishLoading:(NSURLConnection*)connection 
{
    if(connection == _getConnection)
    {
        [self updateLabel:_getData];
        _getData = nil;
    }
    else if(connection == _postConnection)
    {
        [self updateLabel:_postData];
        _postData = nil;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
