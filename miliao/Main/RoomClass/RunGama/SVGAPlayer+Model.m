#import "SVGAPlayer+Model.h"
#import <objc/runtime.h>
#import "SVGAModel.h"

static const char *kSVGAModelKey = "kSVGAModelKey";

@implementation SVGAPlayer (Model)

- (void)setSvgaModel:(SVGAModel *)svgaModel {
    objc_setAssociatedObject(self, kSVGAModelKey, svgaModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SVGAModel *)svgaModel {
    return objc_getAssociatedObject(self, kSVGAModelKey);
}

@end
