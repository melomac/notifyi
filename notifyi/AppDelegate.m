#import "AppDelegate.h"

@implementation AppDelegate

- (void)start
{
	NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
	
	[center addObserver:self selector:@selector(fyi:) name:nil object:nil suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
}

- (void)stop
{
	NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
	
	[center removeObserver:self];
}

- (void)fyi:(NSNotification *)notification
{
	NSLog(@"%@", notification);
}

@end
