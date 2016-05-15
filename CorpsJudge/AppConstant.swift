//
//  AppConstant.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/14/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

class AppConstant {
    let		PF_INSTALLATION_CLASS_NAME			 = "_Installation"		//	Class name
    let		PF_INSTALLATION_OBJECTID			 = "objectId"				//	String
    let		PF_INSTALLATION_USER				 = "user"					//	Pointer to User Class
    
    let		PF_USER_CLASS_NAME					 = "_User"				//	Class name
    let		PF_USER_OBJECTID					 = "objectId"				//	String
    let		PF_USER_USERNAME					 = "username"				//	String
    let		PF_USER_PASSWORD					 = "password"				//	String
    let		PF_USER_EMAIL						 = "email"				//	String
    let		PF_USER_EMAILCOPY					 = "emailCopy"			//	String
    let		PF_USER_FULLNAME					 = "fullname"				//	String
    let		PF_USER_FULLNAME_LOWER				 = "fullname_lower"		//	String
    let		PF_USER_FACEBOOKID					 = "facebookId"			//	String
    let		PF_USER_PICTURE						 = "picture"				//	File
    let		PF_USER_THUMBNAIL					 = "thumbnail"			//	File
    
    let		PF_CHAT_CLASS_NAME					 = "Chat"					//	Class name
    let		PF_CHAT_USER						 = "user"					//	Pointer to User Class
    let		PF_CHAT_ROOMID						 = "roomId"				//	String
    let		PF_CHAT_TEXT						 = "text"					//	String
    let		PF_CHAT_PICTURE						 = "picture"				//	File
    let		PF_CHAT_CREATEDAT					 = "createdAt"			//	Date
    
    let		PF_CHATROOMS_CLASS_NAME				 = "ChatRooms"			//	Class name
    let		PF_CHATROOMS_NAME					 = "name"					//	String
    
    let		PF_MESSAGES_CLASS_NAME				 = "Messages"				//	Class name
    let		PF_MESSAGES_USER					 = "user"					//	Pointer to User Class
    let		PF_MESSAGES_ROOMID					 = "roomId"				//	String
    let		PF_MESSAGES_DESCRIPTION				 = "description"			//	String
    let		PF_MESSAGES_LASTUSER				 = "lastUser"				//	Pointer to User Class
    let		PF_MESSAGES_LASTMESSAGE				 = "lastMessage"			//	String
    let		PF_MESSAGES_COUNTER					 = "counter"				//	Number
    let		PF_MESSAGES_UPDATEDACTION			 = "updatedAction"		//	Date
    
    let		NOTIFICATION_APP_STARTED			 = "NCAppStarted"
    let		NOTIFICATION_USER_LOGGED_IN			 = "NCUserLoggedIn"
    let		NOTIFICATION_USER_LOGGED_OUT		 = "NCUserLoggedOut"
    
    //MARK:-
    //MARK:SINGLETON DECLARATION
    static let sharedInstance = AppConstant()

}

