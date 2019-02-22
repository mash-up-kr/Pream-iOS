//
//  PRGroupFilter.swift
//  pream
//
//  Created by JERCY on 22/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

class FilterModel {
    var groupName: String?
    var groupImage: UIImage?
    var groupFilter: GroupFilter = GroupFilter()
}

class GroupFilter {
    var gpuExposureFilter: GPUImageExposureFilter = GPUImageExposureFilter()
    var gpuContrastFilter: GPUImageContrastFilter = GPUImageContrastFilter()
    var gpuSharpenFilter: GPUImageSharpenFilter = GPUImageSharpenFilter()
    var gpuSaturationFilter: GPUImageSaturationFilter = GPUImageSaturationFilter()
    var gpuHighlightFilter: GPUImageHighlightShadowFilter = GPUImageHighlightShadowFilter()
    var gpuWhiteBalanceFilter: GPUImageWhiteBalanceFilter = GPUImageWhiteBalanceFilter()
    var gpuBrightnessFilter: GPUImageBrightnessFilter = GPUImageBrightnessFilter()
    var gpuVignetteFilter: GPUImageVignetteFilter = {
        let filter = GPUImageVignetteFilter()
        filter.vignetteStart = 0
        filter.vignetteEnd = 5
        return filter
    }()
//    var gpuGrainFilter: GPUImageExposureFilter = GPUImageExposureFilter()
//    var gpuFadeFilter: GPUImageExposureFilter = GPUImageExposureFilter()
    var gpuSplitToneFilter: GPUImageExposureFilter = GPUImageExposureFilter()
    lazy var gpuGroupFilter: GPUImageFilterGroup = {
        let groupFilter = GPUImageFilterGroup()
        groupFilter.addFilter(gpuExposureFilter)
        groupFilter.addFilter(gpuContrastFilter)
        groupFilter.addFilter(gpuSharpenFilter)
        groupFilter.addFilter(gpuSaturationFilter)
        groupFilter.addFilter(gpuHighlightFilter)
        groupFilter.addFilter(gpuWhiteBalanceFilter)
        groupFilter.addFilter(gpuVignetteFilter)
        groupFilter.addFilter(gpuBrightnessFilter)
//        groupFilter.addFilter(gpuGrainFilter)
//        groupFilter.addFilter(gpuFadeFilter)
        groupFilter.addFilter(gpuSplitToneFilter)

        gpuExposureFilter.addTarget(gpuContrastFilter)
        gpuContrastFilter.addTarget(gpuSharpenFilter)
        gpuSharpenFilter.addTarget(gpuSaturationFilter)
        gpuSaturationFilter.addTarget(gpuHighlightFilter)
        gpuHighlightFilter.addTarget(gpuWhiteBalanceFilter)
        gpuWhiteBalanceFilter.addTarget(gpuVignetteFilter)
        gpuVignetteFilter.addTarget(gpuBrightnessFilter)
        gpuBrightnessFilter.addTarget(gpuSplitToneFilter)
//        gpuGrainFilter.addTarget(gpuFadeFilter)
//        gpuFadeFilter.addTarget(gpuSplitToneFilter)

        groupFilter.initialFilters = [gpuExposureFilter]
        groupFilter.terminalFilter = gpuSplitToneFilter

        return groupFilter
    }()

    func getMinMaxValue(filter: Effects, customField: String? = nil) -> (min: Float, max: Float) {
        switch filter {
        case .exposure:
            return (-10, 10)
        case .brightness:
            return (-1, 1)
        case .contrast:
            return (0, 4)
        case .sharpen:
            return (-4, 4)
        case .saturation:
            return (0, 2)
        case .highlight:
            return (0, 1)
        case .shadow:
            return (0, 1)
        case .whiteBalance:
            if customField == "temperature" {
                return (0, 10000)
            } else {
                return (0, 100)
            }
        case .vignette:
            return (0, 5)
//        case .grain:
//            return (0, 0)
//        case .fade:
//            return (0, 0)
        case .splitTone:
            return (0, 0)
        }
    }

    func setFilter(currentFilter: Effects, customField: String? = nil, value: CGFloat) {
        switch currentFilter {
        case .exposure:
            gpuExposureFilter.exposure = value
        case .brightness:
            gpuBrightnessFilter.brightness = value
        case .contrast:
            gpuContrastFilter.contrast = value
        case .sharpen:
            gpuSharpenFilter.sharpness = value
        case .saturation:
            gpuSaturationFilter.saturation = value
        case .highlight:
            gpuHighlightFilter.highlights = value
        case .shadow:
            gpuHighlightFilter.shadows = value
        case .whiteBalance:
            if customField == "temperature" {
                gpuWhiteBalanceFilter.temperature = value
            } else {
                gpuWhiteBalanceFilter.tint = value
            }
        case .vignette:
            gpuVignetteFilter.vignetteStart = 0
            gpuVignetteFilter.vignetteEnd = value
//        case .grain:
//            Log.msg("grain")
//        case .fade:
//            Log.msg("grain")
        case .splitTone:
            Log.msg("grain")
        }
    }

    func getValue(effect: Effects, customField: String? = nil) -> CGFloat {
        switch effect {
        case .exposure:
            return gpuExposureFilter.exposure
        case .brightness:
            return gpuBrightnessFilter.brightness
        case .contrast:
            return gpuContrastFilter.contrast
        case .sharpen:
            return gpuSharpenFilter.sharpness
        case .saturation:
            return gpuSaturationFilter.saturation
        case .highlight:
            return gpuHighlightFilter.highlights
        case .shadow:
            return gpuHighlightFilter.shadows
        case .whiteBalance:
            if customField == "temperature" {
                return gpuWhiteBalanceFilter.temperature
            } else {
                return gpuWhiteBalanceFilter.tint
            }
        case .vignette:
            return gpuVignetteFilter.vignetteEnd
//        case .grain:
//            return 0
//        case .fade:
//            return 0
        case .splitTone:
            return 0
        }
    }
}
