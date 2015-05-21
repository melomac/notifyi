#import <Foundation/Foundation.h>

#import "AppDelegate.h"

int main(int argc, const char *argv[])
{
	@autoreleasepool
	{
		AppDelegate *app = [[AppDelegate alloc] init];
		
		signal(SIGINT, SIG_IGN);
		signal(SIGTERM, SIG_IGN);
		
		dispatch_source_t _intSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGINT, 0, dispatch_get_main_queue());
		dispatch_source_t _termSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGTERM, 0, dispatch_get_main_queue());
		
		dispatch_block_t handler = ^{
			
			fprintf(stderr, "Stopping...\n");
			
			[app stop];
			
			exit(EXIT_SUCCESS);
		};
		
		dispatch_source_set_event_handler(_intSource, handler);
		dispatch_source_set_event_handler(_termSource, handler);
		
		dispatch_resume(_intSource);
		dispatch_resume(_termSource);
		
		[app start];
		
		[[NSRunLoop mainRunLoop] run];
	}
	
	return EXIT_SUCCESS;
}
