//
//  ChatsViewController.swift
//  Afters
//
//  Created by C332268 on 12/10/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class ChatsViewController: BaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func loginWithUser(){
        
        //        let user = QBUUser.init()
        //
        //        user.login = "suyogkolhe@gmail.com"
        //        user.password = "suyogkolhe@gmail.com43"
        //
        //
        //        QMServicesManager.instance().logIn(with: user) { (isSuccess, errorMessage) in
        //
        //            QBResponse
        //
        //            print(errorMessage)
        //        }
        //
        //
        
        //        QMServicesManager.instance().logIn(with: user, completion: ((Bool, String?) -> Void)?
        //
        //
        //
        //        )
        
        
    }
    
    
//    
//    - (void)logInWithUser:(QBUUser *)user
//    completion:(void (^)(BOOL success, NSString *errorMessage))completion
//    {
//    __weak typeof(self) weakSelf = self;
//    [self.authService logInWithUser:user completion:^(QBResponse *response, QBUUser *userProfile) {
//    if (response.error != nil) {
//    if (completion != nil) {
//    completion(NO, response.error.error.localizedDescription);
//    }
//    return;
//    }
//    
//    [weakSelf.chatService connectWithCompletionBlock:^(NSError * _Nullable error) {
//    //
//    __typeof(self) strongSelf = weakSelf;
//    
//    [strongSelf.chatService loadCachedDialogsWithCompletion:^{
//    NSArray* dialogs = [strongSelf.chatService.dialogsMemoryStorage unsortedDialogs];
//    for (QBChatDialog* dialog in dialogs) {
//    if (dialog.type != QBChatDialogTypePrivate) {
//    [strongSelf.chatService joinToGroupDialog:dialog completion:^(NSError * _Nullable error) {
//    //
//    if (error != nil) {
//    NSLog(@"Join error: %@", error.localizedDescription);
//    }
//    }];
//    }
//    }
//    
//    if (completion != nil) {
//    completion(error == nil, error.localizedDescription);
//    }
//    
//    }];
//    }];
//    }];
//    }
//
//    
}
