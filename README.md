% Output variables including two matrixes
% Variable name         type        description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% data                  double      Year, Month, Day, Latitude, Longitude, Depth/km, Magnitude
% describe              cell        EventID, Author, Catalog, Contributor, ContributorID, MagType, MagAuthor, EventLocationName
%
%===================================================================================================================================================================================================================================
%
% Input arguments
%
% input                 type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% syr                   integer     none        start time of year
% smo                   integer     none        start time of month
% sda                   integer     none        start time of day
% eyr                   integer     none        end time of year
% emo                   integer     none        end time of month
% eda                   integer     none        end time of day
%
%
% Optional Input arguments
% parameter             type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% minlat                float       -90         Southern boundary.
% maxlat                float       90          Northern boundary.
% minlong               float       -180        Western boundary.
% maxlong               float       180         Eastern boundary.
% latitude              float       0.0         Specify the central latitude point.
% longitude             float       0.0         Specify the central longitude point.
% maxrad                float       180         Specify maximum distance from the geographic point defined by latitude and longitude.
% minrad                float       0.0         Specify minimum distance from the geographic point defined by latitude and longitude.
% minmag                float       null        Limit to events with a magnitude larger than or equal to the specified minimum.
% maxmag                float       null        Limit to events with a magnitude smaller than or equal to the specified maximum.
% mindepth              float       null        Limit to events with depths equal to or greater than the specified depth (km)
% maxdepth              float       null        Limit to events with depths less than or equal to the specified depth (km)
%
% Others : NOTE!!! Following argumets please enter with quotes (String)
% parameter             type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% catalog               String      null        Specify the catalog from which origins and magnitudes will be retrieved (http://service.iris.edu/fdsnws/event/1/catalogs)
% contributor           String      null        Limit to events contributed by a specified contributor. (http://service.iris.edu/fdsnws/event/1/contributors)
% limit                 Integer     null        Limit the results to the specified number of events
%                       [1,20000]
% offset                Integer     1           Return results starting at the event count specified.
%                       [1,?]	
% orderby               String      time        Order the results. The allowed values are:
%                                               orderby=time
%                                               order by origin descending time
%                                               orderby=time-asc
%                                               order by origin ascending time
%                                               orderby=magnitude
%                                               order by descending magnitude
%                                               orderby=magnitude-asc
%                                               order by ascending magnitude
% magtype               String      preferred*  Type of Magnitude used to test minimum and maximum limits. Case insensitive. 
%                                               Ml ¡X local (Richter) magnitude
%                                               Ms ¡X surface magnitude
%                                               mb ¡X body wave magnitude
%                                               Mw ¡X moment magnitude
% updatedafter          String      null        Limit to events updated after the specified time (useful for synchronizing events). (yyyy-mm-dd)
% includeallmagnitudes	Boolean     false       Retrieve all magnitudes for the event, or only the primary magnitude.
% eventid               String      null        Retrieve an event based on the unique ID numbers assigned by the IRIS DMC4 
%
%
% **********************************************************************************************************************************************************************************************************************************
% preferred: compare minmag and maxmag to the highest-ranked magnitude for each event in a catalog. (this is the same as not specifying a magtype)
%
%
% Reference:
% IRIS DMC FDSNWS event Web Service Documentation: http://service.iris.edu/fdsnws/event/1/#time
% Incorporated Research Institutions for Seismology Help: event v.1: http://service.iris.edu/fdsnws/event/docs/1/help/#cite