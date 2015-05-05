//
//  Debug.h
//
//  Created by jtq6 on 3/21/13.
//  Copyright (c) 2013 CDC Informatics R&D Lab. All rights reserved.
//

#ifndef photon_Debug_h
#define photon_Debug_h

#ifdef DEBUG
#define DebugLog(fmt, ...) NSLog((@"%s[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define LineLog() DebugLog(@"");
#else
#define DebugLog(...)
#define LineLog(...)
#endif

// Info Log always displays output regardless of the DEBUG setting
#define InfoLog(fmt, ...) NSLog((@"%s[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#endif
