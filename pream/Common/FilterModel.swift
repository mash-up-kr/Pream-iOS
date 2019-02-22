//
//  PRGroupFilter.swift
//  pream
//
//  Created by JERCY on 22/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

class FilterModelDummy {
    var dummyFilters: [FilterModel] = []

    func makeDummy() {
        let dummy1 = FilterModel()
        let dummy2 = FilterModel()
        let dummy3 = FilterModel()
        let dummy4 = FilterModel()

        let filter1 = GroupFilter()
        filter1.setFilterValues(exposure: 0.09, contrast: 1.05, sharpness: nil, saturation: 1.18, highlights: nil, shadows: 0.2, temperature: nil, tint: nil, vignetteEnd: nil, brightness: 0.1)
        let filter2 = GroupFilter()
        filter2.setFilterValues(exposure: nil, contrast: 1.42, sharpness: nil, saturation: 0.8, highlights: nil, shadows: nil, temperature: nil, tint: nil, vignetteEnd: nil, brightness: 0.08)
        let filter3 = GroupFilter()
        filter3.setFilterValues(exposure: 0.08, contrast: 1.10, sharpness: nil, saturation: 1.5, highlights: nil, shadows: nil, temperature: nil, tint: nil, vignetteEnd: nil, brightness: 0.08)
        let filter4 = GroupFilter()
        filter4.setFilterValues(exposure: 0.2, contrast: 1.35, sharpness: nil, saturation: 1.15, highlights: nil, shadows: nil, temperature: nil, tint: nil, vignetteEnd: nil, brightness: nil)

        dummy1.makeModel(localId: 1, groupName: "화사한", groupImage: #imageLiteral(resourceName: "object.jpeg"), groupFilter: filter1)
        dummy2.makeModel(localId: 2, groupName: "채도 낮은 차분", groupImage: #imageLiteral(resourceName: "food"), groupFilter: filter2)
        dummy3.makeModel(localId: 3, groupName: "비비드", groupImage: #imageLiteral(resourceName: "portrait"), groupFilter: filter3)
        dummy4.makeModel(localId: 4, groupName: "강렬한", groupImage: #imageLiteral(resourceName: "scenery"), groupFilter: filter4)

        dummyFilters.append(dummy1)
        dummyFilters.append(dummy2)
        dummyFilters.append(dummy3)
        dummyFilters.append(dummy4)
    }
}

class FilterModel {
    var localId: Int?
    var serverId: Int?
    var groupName: String?
    var groupImage: UIImage?
    var groupFilter: GroupFilter = GroupFilter()

    func makeModel(localId: Int, groupName: String, groupImage: UIImage?, groupFilter: GroupFilter) {
        self.localId = localId
        self.groupName = groupName
        self.groupImage = groupImage
        self.groupFilter = groupFilter
    }
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

    func setFilterValues(exposure: CGFloat?, contrast: CGFloat?, sharpness: CGFloat?, saturation: CGFloat?, highlights: CGFloat?, shadows: CGFloat?, temperature: CGFloat?, tint: CGFloat?, vignetteEnd: CGFloat?, brightness: CGFloat?) {
        if let exposure = exposure {
            gpuExposureFilter.exposure = exposure
        }
        if let contrast = contrast {
            gpuContrastFilter.contrast = contrast
        }
        if let sharpness = sharpness {
            gpuSharpenFilter.sharpness = sharpness
        }
        if let saturation = saturation {
            gpuSaturationFilter.saturation = saturation
        }
        if let highlights = highlights {
            gpuHighlightFilter.highlights = highlights
        }
        if let shadows = shadows {
            gpuHighlightFilter.shadows = shadows
        }
        if let temperature = temperature {
            gpuWhiteBalanceFilter.temperature = temperature
        }
        if let tint = tint {
            gpuWhiteBalanceFilter.tint = tint
        }
        if let vignetteEnd = vignetteEnd {
            gpuVignetteFilter.vignetteEnd = vignetteEnd
        }
        if let brightness = brightness {
            gpuBrightnessFilter.brightness = brightness
        }
        //        gpuGrainFilter
        //        gpuFadeFilter
        //        gpuSplitToneFilter
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
