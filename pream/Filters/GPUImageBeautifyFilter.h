//
//  GPUImageBeautifyFilter.h
//  pream
//
//  Created by 이재성 on 04/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@class GPUImageCombinationFilter;

@interface GPUImageBeautifyFilter : GPUImageFilterGroup {
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}
    
@end
