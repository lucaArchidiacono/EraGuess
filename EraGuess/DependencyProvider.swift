//
//  DependencyProvider.swift
//  EraGuess
//
//  Created by Luca Archidiacono on 28.12.2024.
//

import AnalyticsDomain
import AnalyticsFeature
import EraGuessShared
import HapticFeedbackFeature
import Permission
import REST
import Services
import SoundEffectFeature
import SpotifyAPI
import StateFeature
import SubscriptionDomain
import SubscriptionFeature

@MainActor
struct DependencyProvider {
    // MARK: - Permissions

    let locationPermissionProvider: LocationPermissionProvider
    let notificationPermissionProvider: NotificationPermissionProvider
    let musicKitPermissionProvider: MusicKitPermissionProvider

    // MARK: - Managers

    let hapticFeedbackManager: HapticFeedbackManager
    let soundEffectManager: SoundEffectManager
    let subscriptionManager: SubscriptionManager
    let analyticsManager: AnalyticsManager
    let navigationManager: NavigationManager
    let userPreferenceManager: UserPreferencesManager
    let appStateManager: AppStateManager

    // MARK: - Services

    let catalogSongService: CatalogSongService
    let streamingServiceRepository: StreamingServiceRepository

    init() {
        let rest = RESTService()
        locationPermissionProvider = LocationPermissionProvider()
        notificationPermissionProvider = NotificationPermissionProvider()
        musicKitPermissionProvider = MusicKitPermissionProvider()

        hapticFeedbackManager = HapticFeedbackManager()
        soundEffectManager = SoundEffectManager()

        let subscriptionConfiguraiton = SubscriptionConfiguration(
            revenueCatAPIKey: EraGuessShared.revenueCatAPIKey,
            securityGroupIdentifier: EraGuessShared.Configuration.securityGroupIdentifier
        )
        subscriptionManager = SubscriptionManagerImpl(configuration: subscriptionConfiguraiton)

        let analyticsConfiguration = TelemetryDeckConfiguration(
            appName: EraGuessShared.Configuration.appName,
            apiKey: EraGuessShared.telemetryAPIKey,
            securityGroupIdentifier: EraGuessShared.Configuration.securityGroupIdentifier
        )
        analyticsManager = TelemetryDeckManager(
            configuration: analyticsConfiguration,
            locationPermissionProvider: locationPermissionProvider,
            notificationPermissionProvider: notificationPermissionProvider
        )

        navigationManager = NavigationManager()

        userPreferenceManager = UserPreferencesManager()
        appStateManager = AppStateManager()

        catalogSongService = CatalogSongServiceImpl()

        let appleMusicService = AppleMusicService()

        let spotifyAPI = SpotifyAPIImpl(network: rest)
        let spotifyService = SpotifyService(
            clientId: EraGuessShared.spotifyAPIId,
            clientSecret: EraGuessShared.spotifyAPIKey,
            api: spotifyAPI
        )
        
        let playerService = PlayerService()

        streamingServiceRepository = StreamingServiceRepository(
            appleMusicService: appleMusicService,
            spotifyService: spotifyService,
            playerService: playerService
        )
    }
}
