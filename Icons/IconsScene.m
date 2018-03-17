// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "Icons.h"
#import "IconsScene.h"

#define PIXEL_SIZE (6)
#define PIXEL_PADDING (1.125)
#define SCREEN_MARGIN (20)
#define APPEAR_DURATION (2.5)
#define PADDING (20.0)

CGFloat Random(CGFloat n) {
    return random() % (int) n;
}

@implementation IconsScene

- (id) initWithSize:(CGSize)size isPreview: (BOOL) isPreview {
    if (self = [super initWithSize: size]) {
        _isPreview = isPreview;
    }
    return self;
}

//NSTimer *timer; // TODO Remove - for debugging

- (void)sceneDidLoad {
    self.backgroundColor = [NSColor blackColor];

//    timer = [NSTimer scheduledTimerWithTimeInterval: 120 repeats: NO block:^(NSTimer * _Nonnull timer) {
//        exit(1);
//    }];
}

- (CGPoint) positionForPixelAt: (CGPoint) point {
    return CGPointMake(
        point.x * (PIXEL_SIZE + PIXEL_PADDING) - (32 * (PIXEL_SIZE + PIXEL_PADDING)) / 2.0,
        point.y * (PIXEL_SIZE * PIXEL_PADDING) - (32 * (PIXEL_SIZE + PIXEL_PADDING)) / 2.0
    );
}

- (SKNode*) createIconNode {
    CGPoint points[32 * 32];

    for (int y = 0; y < 32; y++) {
        for (int x = 0; x < 32; x++) {
            points[y*32+x] = CGPointMake(x, y);
        }
    }

    for (int i = 0; i < 32*32; i++) {
        int r = random() % (32*32);
        CGPoint t = points[r];
        points[r] = points[i];
        points[i] = t;
    }

    // Create a container node in which we will place all our pixels

    SKShapeNode *container = [SKShapeNode shapeNodeWithRectOfSize: CGSizeMake(32 * (PIXEL_SIZE + PIXEL_PADDING), 32 * (PIXEL_SIZE + PIXEL_PADDING))];
    container.lineWidth = 0;

    uint32_t *icon = &Icons[(random() % 42) * (32)];

    int n = 0;
    for (int y = 0; y < 32; y++) {
        for (int x = 0; x < 32; x++) {
            CGPoint p = points[y*32+x];
            if ((icon[32 - (int) p.y - 1] & (0b10000000000000000000000000000000 >> (int) p.x)) != 0) {
                SKShapeNode *pixelNode = [SKShapeNode shapeNodeWithRectOfSize: CGSizeMake(PIXEL_SIZE, PIXEL_SIZE)];
                pixelNode.name = [[NSNumber numberWithInt: n++] stringValue];
                pixelNode.lineWidth = 0;
                pixelNode.fillColor = NSColor.whiteColor;
                pixelNode.alpha = 0;
                pixelNode.position = [self positionForPixelAt: p];
                [container addChild: pixelNode];
            }
        }
    }

    return container;
}

- (SKAction*) createActionForIcon: (SKNode*) node {
    double pixelFadeInDuration = APPEAR_DURATION / (double) node.children.count;
    NSMutableArray *actions = [NSMutableArray array];
    for (SKNode *pixelNode in node.children) {
        [actions addObject: [SKAction runAction: [SKAction fadeAlphaTo: 1.0 duration: 0] onChildWithName: pixelNode.name]];
        [actions addObject: [SKAction waitForDuration: pixelFadeInDuration]];
    }
    [actions addObject: [SKAction waitForDuration: 2.5]];
    [actions addObject: [SKAction fadeOutWithDuration: 1.0]];
    [actions addObject: [SKAction removeFromParent]];
    return [SKAction sequence: actions];
}

- (CGPoint) randomIconPosition {
    CGFloat mid = 32 * (PIXEL_SIZE + PIXEL_PADDING) / 2.0;
    CGFloat x1 = PADDING + mid;
    CGFloat x2 = self.size.width - (PADDING + mid);
    CGFloat y1 = PADDING + mid;
    CGFloat y2 = self.size.height - (PADDING + mid);
    return CGPointMake(x1 + Random(x2 - x1), y1 + Random(y2 - y1));
}

- (void) didMoveToView:(SKView *)view {
    SKAction *addIconAction = [SKAction runBlock:^{
        SKNode *iconNode = [self createIconNode];
        iconNode.position = [self randomIconPosition];
        [self addChild: iconNode];
        [iconNode runAction: [self createActionForIcon: iconNode]];
    }];
    [self runAction: [SKAction repeatActionForever: [SKAction sequence: @[addIconAction, [SKAction waitForDuration: 5]]]]];
}

@end
