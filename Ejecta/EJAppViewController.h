#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EJAppViewController : UIViewController {
	BOOL landscapeMode;
	NSString *path;
}

- (id)initWithScriptAtPath:(NSString *)pathp;

@end
