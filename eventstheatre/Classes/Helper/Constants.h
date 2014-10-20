/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#ifndef EVT_CONSTANTS_H
#define EVT_CONSTANTS_H

/**
 * Unique AdMob identifier.
 * DO NOT CHANGE!
 */
#define ADMOB_AD_UNIT_ID @"a14e8e179c9f676"

/** 
 * String identifier that will be sent to server 
 *
 * Format: xxx_N_N_N_CC where:
 * - xxx is a very generic string identifier of the platform: "IOS", "AND", etc.
 * - N_N_N is the application numeric version 1_0_0, 1_1_0, 1_12_0, etc.
 * - CC is the ISO country code (two digit version) mainly for usage statistics.
 *
 * CHANGE ON EACH UPDATE/DEPLOYMENT!
 */
#define EVT_APPVERSION @"IOS_1.2.0_RO"

/** 
 * Two letter country code that should be modified for each deployment.
 * CHANGE ONLY IF NEW DEPLOYMENT!
 */
#define EVT_COUNTRYCODE @"RO"

/** 
 * Name of the headers that are sent to the server on every request.
 * DO NOT CHANGE!
 * X-OVI-APPVERSION IS MANDATORY IN APACHE SERVER CONFIG!
 */
#define EVT_HEADER_APPVERSION   @"X-OVI-APPVERSION"
#define EVT_HEADER_MODEL        @"X-OVI-DEVICENAME"
#define EVT_HEADER_UID          @"X-OVI-DEVICEUID"

/**
 * Number of days a Three20 url cache response file is allowed
 * to reside on filesystem before being deleted by purge task.
 */
#define EVT_MAX_THREE20_URL_CACHE_DURATION 7 // NOT IN USE

/**
 * If we are using prod gateway settings.
 * DO NOT DELIVER APP WITH THIS SET TO NO!
 */
#define EVT_NOTIFICATIONS_GATEWAY_PROD      @"NO"
     
#define EVT_NOTIFICATIONS_DEV_APP_KEY       @"P33uz1guTbi4QDFKhy-SRw"
#define EVT_NOTIFICATIONS_DEV_APP_SECRET    @"AanCdoZ3Scmtm90f1S02rw"
#define EVT_NOTIFICATIONS_PROD_APP_KEY      @"QdFMWjP7QEqZmGw7NvXVhg"
#define EVT_NOTIFICATIONS_PROD_APP_SECRET   @"JBxd7OpvQ2GsyEdnvwqwpg"

/**
 * Facebook app constants.
 */
#define FB_APP_ID                           @"320340397993653"

/**
 * URL Cache durations (in seconds).
 * Changing any value has possible impact on QoS.
 */
#define TT_CACHE_DURATION_CITY_BY_COUNTRY  TT_DAY  * 1
#define TT_CACHE_DURATION_EVENT_BY_CITY    TT_HOUR * 6
#define TT_CACHE_DURATION_EVENT_BY_VENUE   TT_HOUR * 6
#define TT_CACHE_DURATION_VENUE_BY_CITY    TT_HOUR * 12
#define TT_CACHE_DURATION_VENUE_BY_COUNTRY TT_HOUR * 12

/**
 * String keys to save the cache to disk under.
 * Extremely important because if we let Three20 handle it
 * we will have more files than we really need in the cache with
 * nobody around to delete them..
 *
 * The keys may be suffixed by _x where x is ID of venue, city, etc.
 */
#define TT_CACHE_KEY_CITY_BY_COUNTRY  @"evt-cache-citycountry"
#define TT_CACHE_KEY_EVENT_BY_CITY    @"evt-cache-eventcity"
#define TT_CACHE_KEY_EVENT_BY_VENUE   @"evt-cache-eventvenue"
#define TT_CACHE_KEY_VENUE_BY_CITY    @"evt-cache-venuecity"
#define TT_CACHE_KEY_VENUE_BY_COUNTRY @"evt-cache-venuecountry"

/**
 * Server URI endpoints. 
 *
 * These define the comunication with the REST webservice
 * currently deployed. The strings between ":" characters are to be replaced
 * BEFORE making the request, or it will fail. 
 *
 * DO NOT CHANGE!
 */

typedef enum EVTWebserviceType {
    kEVTURICheckModuleUpdate,
    kEVTURICity,
    kEVTURICityByCountry,
    kEVTURIEvent,
    kEVTURIEventByCity,
    kEVTURIEventById,
    kEVTURIEventByVenue,
    kEVTURIUtilsTime,
    kEVTURIVenue,
    kEVTURIVenueByCity,
    kEVTURIVenueByCountry,
    kEVTURIVenueById
} EVTWebserviceType;

#define URI_WEBSERVICE                @"http://amz01.oviprojects.info/events"
#define URI_CHECK_MODULE_UPDATE       @"/checkupdate/moduleupdate?module=:module:&controller=:controller:"
#define URI_CITY                      @"/theatre/city"
#define URI_CITY_BY_COUNTRY           @"/theatre/city?countryCode=:countryCode:"
#define URI_CITY_BY_ID                @"/theatre/city/:city_id:"
#define URI_EVENT                     @"/theatre/event"
#define URI_EVENT_BY_CITY             @"/theatre/event?city_id=:city_id:&timestamp_start=:timestamp_start:"
#define URI_EVENT_BY_ID               @"/theatre/event/:event_id:"
#define URI_EVENT_BY_VENUE            @"/theatre/event?venue_id=:venue_id:&timestamp_start=:timestamp_start:"
#define URI_UTILS_TIME                @"/utils/time"
#define URI_VENUE                     @"/theatre/venue"
#define URI_VENUE_BY_CITY             @"/theatre/venue?city_id=:city_id:"
#define URI_VENUE_BY_COUNTRY          @"/theatre/venue?countryCode=:countryCode:"
#define URI_VENUE_BY_ID               @"/theatre/venue/:venue_id:"

/**
 * Keys used to save in NSUserDefaults.
 * CAUTION IN CHANGING!
 */
#define USER_DEFAULTS_CITY_ID                @"defaultCityId"
#define USER_DEFAULTS_CITY_NAME              @"defaultCityName"
#define USER_DEFAULTS_CITY_LAT               @"defaultCityLat"
#define USER_DEFAULTS_CITY_LNG               @"defaultCityLng"
#define USER_DEFAULTS_DASHBOARD_PAGES        @"dashboardPages"
#define USER_DEFAULTS_EVENTS_LAST_UPDATE     @"eventsLastUpdateTimestamp"
#define USER_DEFAULTS_TIME_DELTA             @"timeDeltaInSeconds"
#define USER_DEFAULTS_PURGE_LAST_DATE        @"lastPurgeDate"               // NOT IN USE
#define USER_DEFAULTS_USED_STATIC_CITY_LIST  @"usedStaticCityList"

#endif