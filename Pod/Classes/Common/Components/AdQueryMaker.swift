//
//  AdQueryMaker.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdQueryMakerType {
    func makeAdQuery(_ request: AdRequest) -> QueryBundle
    func makeImpressionQuery(_ adResponse: AdResponse) -> QueryBundle
    func makeClickQuery(_ adResponse: AdResponse) -> QueryBundle
    func makeEventQuery(_ adResponse: AdResponse, _ eventData: EventData) -> QueryBundle
}

class AdQueryMaker: AdQueryMakerType {
    private let device: DeviceType
    private let sdkInfo: SdkInfoType
    private let connectionProvider: ConnectionProviderType
    private let numberGenerator: NumberGeneratorType
    private let idGenerator: IdGeneratorType
    private let encoder: EncoderType
    private let options: [String: String]?

    init(device: DeviceType,
         sdkInfo: SdkInfoType,
         connectionProvider: ConnectionProviderType,
         numberGenerator: NumberGeneratorType,
         idGenerator: IdGeneratorType,
         encoder: EncoderType,
         options: [String: String]?) {
        self.device = device
        self.sdkInfo = sdkInfo
        self.connectionProvider = connectionProvider
        self.numberGenerator = numberGenerator
        self.idGenerator = idGenerator
        self.encoder = encoder
        self.options = options
    }

    func makeAdQuery(_ request: AdRequest) -> QueryBundle {
        return QueryBundle(parameters: AdQuery(test: request.test,
                                               sdkVersion: sdkInfo.version,
                                               random: numberGenerator.nextIntForCache(),
                                               bundle: sdkInfo.bundle,
                                               name: sdkInfo.name,
                                               dauid: idGenerator.uniqueDauId,
                                               connectionType: connectionProvider.findConnectionType(),
                                               lang: sdkInfo.lang,
                                               device: device.genericType,
                                               position: request.position.rawValue,
                                               skip: request.skip.rawValue,
                                               playbackMethod: request.playbackMethod,
                                               startDelay: request.startDelay.rawValue,
                                               instl: request.instl.rawValue,
                                               width: request.width,
                                               height: request.height),
                           options: buildOptions(request.additionalOptions))
    }

    func makeImpressionQuery(_ adResponse: AdResponse) -> QueryBundle {
        QueryBundle(parameters: EventQuery(placement: adResponse.placementId,
                                           bundle: sdkInfo.bundle,
                                           creative: adResponse.advert.creative.id,
                                           lineItem: adResponse.advert.lineItemId,
                                           connectionType: connectionProvider.findConnectionType(),
                                           sdkVersion: sdkInfo.version,
                                           rnd: numberGenerator.nextIntForCache(),
                                           type: .impressionDownloaded,
                                           noImage: true,
                                           data: nil),
                    options: buildOptions(adResponse.additionalOptions))
    }

    func makeClickQuery(_ adResponse: AdResponse) -> QueryBundle {
        QueryBundle(parameters: EventQuery(placement: adResponse.placementId,
                                           bundle: sdkInfo.bundle,
                                           creative: adResponse.advert.creative.id,
                                           lineItem: adResponse.advert.lineItemId,
                                           connectionType: connectionProvider.findConnectionType(),
                                           sdkVersion: sdkInfo.version,
                                           rnd: numberGenerator.nextIntForCache(),
                                           type: nil,
                                           noImage: nil,
                                           data: nil),
                    options: buildOptions(adResponse.additionalOptions))
    }

    func makeEventQuery(_ adResponse: AdResponse, _ eventData: EventData) -> QueryBundle {
        QueryBundle(parameters: EventQuery(placement: adResponse.placementId,
                                           bundle: sdkInfo.bundle,
                                           creative: adResponse.advert.creative.id,
                                           lineItem: adResponse.advert.lineItemId,
                                           connectionType: connectionProvider.findConnectionType(),
                                           sdkVersion: sdkInfo.version,
                                           rnd: numberGenerator.nextIntForCache(),
                                           type: eventData.type,
                                           noImage: nil,
                                           data: encoder.toJson(eventData)),
                    options: buildOptions(adResponse.additionalOptions))
    }

    private func buildOptions(_ additionalOptions: [String: String]?) -> [String: String]? {
        var optionsDict = [String: String]()

        if let options = options {
            optionsDict = optionsDict.merging(options) { $1 }
        }

        if let additionalOptions = additionalOptions {
            optionsDict = optionsDict.merging(additionalOptions) { $1 }
        }
        return optionsDict
    }
}
