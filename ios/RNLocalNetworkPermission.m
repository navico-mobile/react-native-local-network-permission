#import "RNLocalNetworkPermission.h"
#include <dns_sd.h>

@implementation RNLocalNetworkPermission{
    BOOL isBlocked;
    RCTPromiseResolveBlock resolve;
    NSTimer* timer;
    DNSServiceRef browseRef;
}
RCT_EXPORT_MODULE();
+ (BOOL)requiresMainQueueSetup
{
  return YES;  // only do this if your module initialization relies on calling UIKit!
}

RCT_EXPORT_METHOD(check:(double) timeOut
                  withResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 14, *)){
        NSLog(@"check local network permission with timeout %f", timeOut);
        if(self->timer!=nil){
            [self->timer invalidate];
            self->timer = nil;
            reject(@"EDUP",@"please wait the check promise resolve",nil);
            return;
        }
        if(self->browseRef!=nil){
            DNSServiceRefDeallocate(self->browseRef);
            self->browseRef = nil;
        }
        self->resolve = resolve;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->timer = [NSTimer scheduledTimerWithTimeInterval: timeOut
                                                           target: self
                                                         selector:@selector(onTimeOut:)
                                                         userInfo: nil
                                                          repeats:NO];
            DNSServiceErrorType error = kDNSServiceErr_NoError;
            error = DNSServiceBrowse(&(self->browseRef), 0, 0, @"_navicosettingsrestapi._tcp".UTF8String, NULL, browseCallback, (__bridge void *)(self));
            if (error != kDNSServiceErr_NoError)
            {
                reject(@"EUNKOWN",@"can not start DNSServiceSetDispatchQueue",nil);
                return;
            }
            error = DNSServiceSetDispatchQueue(self->browseRef, dispatch_get_main_queue());
            if (error != kDNSServiceErr_NoError)
            {
                reject(@"EUNKOWN",@"can not start DNSServiceSetDispatchQueue",nil);
                return;
            }
        });
    }else{
        resolve([NSNumber numberWithBool:TRUE]);
        return;
    }
}

#pragma MARK - check
-(void)resolvePromise:(BOOL) result {
    if(self->resolve!=nil){
        self->resolve([NSNumber numberWithBool:result]);
        self->resolve = nil;
    }
}
-(void)onTimeOut:(NSTimer *)timer {
    DNSServiceRefDeallocate(self->browseRef);
    self->browseRef = nil;
    self->timer = nil;
    [self resolvePromise:YES];
}
-(void)onResult {
    if(self->timer){
        [self->timer invalidate];
        self->timer = nil;
        DNSServiceRefDeallocate(self->browseRef);
        self->browseRef = nil;
        [self resolvePromise:NO];
    }
}

static void browseCallback(DNSServiceRef sdRef, DNSServiceFlags flags, uint32_t interfaceIndex,
                           DNSServiceErrorType errorCode, const char *serviceName,
                           const char *regtype, const char *replyDomain, void *context) {
    if (errorCode == kDNSServiceErr_PolicyDenied) {
        NSLog(@"local network ungranted");
        if(context!=nil){
            RNLocalNetworkPermission* this = (__bridge RNLocalNetworkPermission *)(context);
            [this onResult];
        }
    }
}
@end
