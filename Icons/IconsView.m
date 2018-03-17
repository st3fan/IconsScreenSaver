// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@import ScreenSaver;
@import SpriteKit;

#import "IconsView.h"
#import "IconsScene.h"

@interface MySKView: SKView {
}
@end

@implementation MySKView
-(BOOL)acceptsFirstResponder {
    return NO;
}
@end

@implementation IconsView

//@synthesize sceneView;
//@synthesize scene;

- (instancetype) initWithFrame: (NSRect) frame isPreview: (BOOL) isPreview
{
    if (self = [super initWithFrame:frame isPreview:isPreview]) {
        _sceneView = [[MySKView alloc] initWithFrame: self.frame];
        _sceneView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview: _sceneView];
        _scene = [[IconsScene alloc] initWithSize: self.frame.size isPreview: NO]; // TODO _isPreview?
        [_sceneView presentScene: _scene];
    }
    return self;
}

- (BOOL) hasConfigureSheet
{
    return NO;
}

- (NSWindow*) configureSheet
{
    return nil;
}

@end
