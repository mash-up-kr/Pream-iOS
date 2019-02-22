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
        let dummy5 = FilterModel()

        let filter1 = GroupFilter()
        filter1.setFilterValues(exposure: 0.3, contrast: 0.2, sharpness: 0.2, saturation: 0.2, highlights: 0.2, shadows: 0.2, temperature: 5000, tint: 0, vignetteEnd: 0.2, brightness: 0.2)
        let filter2 = GroupFilter()
        filter2.setFilterValues(exposure: 0.1, contrast: 0.4, sharpness: 0.3, saturation: 0.1, highlights: 0.5, shadows: 0.5, temperature: 6000, tint: 0, vignetteEnd: 0.1, brightness: 0.3)
        let filter3 = GroupFilter()
        filter3.setFilterValues(exposure: 0.5, contrast: 0.2, sharpness: 0.3, saturation: 0.1, highlights: 0.1, shadows: 0.2, temperature: 4000, tint: 0, vignetteEnd: 0.1, brightness: 0.1)
        let filter4 = GroupFilter()
        filter4.setFilterValues(exposure: 0.1, contrast: 0.1, sharpness: 0.1, saturation: 0.1, highlights: 0.11, shadows: 0.2, temperature: 5000, tint: 0, vignetteEnd: 0.1, brightness: 0.1)
        let filter5 = GroupFilter()
        filter5.setFilterValues(exposure: 0.3, contrast: 0.3, sharpness: 0.3, saturation: 0.3, highlights: 0.3, shadows: 0.3, temperature: 6000, tint: 0, vignetteEnd: 0.3, brightness: 0.3)

        dummy1.makeModel(localId: 1, groupName: "이름", groupImage: nil, groupFilter: filter1)
        dummy2.makeModel(localId: 2, groupName: "피카", groupImage: nil, groupFilter: filter2)
        dummy3.makeModel(localId: 3, groupName: "duddj", groupImage: nil, groupFilter: filter3)
        dummy4.makeModel(localId: 4, groupName: "하하하하하", groupImage: nil, groupFilter: filter4)
        dummy5.makeModel(localId: 5, groupName: "필터닷", groupImage: nil, groupFilter: filter5)

        dummyFilters.append(dummy1)
        dummyFilters.append(dummy2)
        dummyFilters.append(dummy3)
        dummyFilters.append(dummy4)
        dummyFilters.append(dummy5)
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

    func setFilterValues(exposure: CGFloat, contrast: CGFloat, sharpness: CGFloat, saturation: CGFloat, highlights: CGFloat, shadows: CGFloat, temperature: CGFloat, tint: CGFloat, vignetteEnd: CGFloat, brightness: CGFloat) {
        gpuExposureFilter.exposure = exposure
        gpuContrastFilter.contrast = contrast
        gpuSharpenFilter.sharpness = sharpness
        gpuSaturationFilter.saturation = saturation
        gpuHighlightFilter.highlights = highlights
        gpuHighlightFilter.shadows = shadows
        gpuWhiteBalanceFilter.temperature = temperature
        gpuWhiteBalanceFilter.tint = tint
        gpuVignetteFilter.vignetteEnd = vignetteEnd
        gpuBrightnessFilter.brightness = brightness
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
