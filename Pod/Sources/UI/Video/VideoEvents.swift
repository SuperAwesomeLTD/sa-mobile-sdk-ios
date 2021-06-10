//
//  SAVideoEvents.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 18/01/2019.
//

import Foundation

@objc (SAVideoEventsDelegate) public protocol VideoEventsDelegate: AnyObject {
    func hasBeenVisible()
}

class VideoEvents: Injectable {

    private var vastRepository: VastEventRepositoryType?
    private var moatRepository: MoatRepositoryType?
    private var viewableDetector: ViewableDetectorType?
    private var eventRepository: EventRepositoryType?
    private let adResponse: AdResponse

    private var isStartHandled: Bool = false
    private var isViewDetectorStarted: Bool = false
    private var isFirstQuartileHandled: Bool = false
    private var isMidpointHandled: Bool = false
    private var isThirdQuartileHandled: Bool = false

    public weak var delegate: VideoEventsDelegate?

    init(_ adResponse: AdResponse) {
        self.adResponse = adResponse
        vastRepository = dependencies.resolve(param: adResponse) as VastEventRepositoryType
        moatRepository = dependencies.resolve(param: adResponse, false) as MoatRepositoryType
        eventRepository = dependencies.resolve() as EventRepositoryType
    }

    // MARK: - public class interface

    public func prepare(player: VideoPlayer, time: Int, duration: Int) {
        if let videoPlayer = player as? UIView,
           let avPlayer = player.getAVPlayer(),
           let avLayer = player.getAVPlayerLayer() {
            _ = moatRepository?.startMoatTracking(forVideoPlayer: avPlayer,
                                                  with: avLayer,
                                                  andView: videoPlayer)
        }
    }

    public func complete(player: VideoPlayer, time: Int, duration: Int) {
        _ = moatRepository?.stopMoatTrackingForVideoPlayer()
        guard time >= duration else { return }
        vastRepository?.complete()
    }

    public func error(player: VideoPlayer, time: Int, duration: Int) {
        _ = moatRepository?.stopMoatTrackingForVideoPlayer()
        vastRepository?.error()
    }

    public func time(player: VideoPlayer, time: Int, duration: Int) {
        if let videoPlayer = player as? UIView, !isViewDetectorStarted {
            isViewDetectorStarted = true
            viewableDetector = dependencies.resolve() as ViewableDetectorType
            viewableDetector?.whenVisible = { [weak self] in
                guard let self = self else {
                    return
                }
                self.eventRepository?.dwellTime(self.adResponse, completion: nil)
            }
            viewableDetector?.start(for: videoPlayer, forTickCount: 2, hasBeenVisible: { [weak self] in
                self?.vastRepository?.impression()
                self?.delegate?.hasBeenVisible()
            })
        }

        if time >= 1 && !isStartHandled {
            isStartHandled = true
            vastRepository?.impression()
            vastRepository?.creativeView()
            vastRepository?.start()
        }

        if time >= duration / 4 && !isFirstQuartileHandled {
            isFirstQuartileHandled = true
            vastRepository?.firstQuartile()
        }
        if time >= duration / 2 && !isMidpointHandled {
            isMidpointHandled = true
            vastRepository?.midPoint()
        }
        if time >= (3 * duration) / 4 && !isThirdQuartileHandled {
            isThirdQuartileHandled = true
            vastRepository?.thirdQuartile()
        }
    }

    deinit {
        viewableDetector = nil
    }
}