#import "EAGLView.h"

@implementation EAGLView

+ (Class)layerClass {
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame contentScale:(float)contentScale retainedBacking:(BOOL)retainedBacking {
	if( self = [super initWithFrame:frame] ) {
		[self setMultipleTouchEnabled:YES];
		
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		self.contentScaleFactor = contentScale;
		eaglLayer.contentsScale = contentScale;

		eaglLayer.opaque = NO;
		
		eaglLayer.drawableProperties = @{
			kEAGLDrawablePropertyRetainedBacking: @(retainedBacking),
			kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
		};
	}
  self.backgroundColor = [UIColor clearColor];
  self.opaque = NO;
	return self;
}

/* Currently taking 50 ms */

- (void) renderInContext: (CGContextRef) context
{
  GLint backingWidth, backingHeight;

  // Bind the color renderbuffer used to render the OpenGL ES view
  // If your application only creates a single color renderbuffer which is already bound at this point,
  // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
  // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
  //  glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);

  // Get the size of the backing CAEAGLLayer
  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
  glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);

  NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
  NSInteger dataLength = width * height * 4;
  GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));

  // Read pixel data from the framebuffer
  //glPixelStorei(GL_PACK_ALIGNMENT, 4);
  glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);

  // Create a CGImage with the pixel data
  // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
  // otherwise, use kCGImageAlphaPremultipliedLast
  CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
  CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
  CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipLast,
                                  ref, NULL, true, kCGRenderingIntentDefault);

  CGFloat scale = self.contentScaleFactor;
  NSInteger widthInPoints, heightInPoints;
  widthInPoints = width / scale;
  heightInPoints = height / scale;

  // UIKit coordinate system is upside down to GL/Quartz coordinate system
  // Flip the CGImage by rendering it to the flipped bitmap context
  // The size of the destination area is measured in POINTS
  CGContextSetBlendMode(context, kCGBlendModeCopy);
  CGContextDrawImage(context, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);

  // Clean up
  free(data);
  CFRelease(ref);
  CFRelease(colorspace);
  CGImageRelease(iref);
}

@end
