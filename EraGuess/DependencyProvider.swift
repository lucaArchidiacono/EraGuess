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
import Services
import SoundEffectFeature
import StateFeature
import SubscriptionDomain
import SubscriptionFeature

@MainActor
protocol DependencyProviding {
    // MARK: - Permissions

    var locationPermissionProvider: LocationPermissionProvider { get }
    var notificationPermissionProvider: NotificationPermissionProvider { get }

    // MARK: - Managers

    var hapticFeedbackManager: HapticFeedbackManager { get }
    var soundEffectManager: SoundEffectManager { get }
    var subscriptionManager: SubscriptionManager { get }
    var analyticsManager: AnalyticsManager { get }
    var navigationManager: NavigationManager { get }
    var userPreferenceManager: UserPreferencesManager { get }
    var appStateManager: AppStateManager { get }
}

struct DependencyProvider: DependencyProviding {
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
        let spotifyService = SpotifyService()
        let playerService = PlayerService()

        streamingServiceRepository = StreamingServiceRepository(
            appleMusicService: appleMusicService,
            spotifyService: spotifyService,
            playerService: playerService
        )
    }
}
