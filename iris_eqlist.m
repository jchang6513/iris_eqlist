function [data,describe] = iris_eqlist(syr,smo,sda,eyr,emo,eda,varargin)

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

% check if input arguments enough, at lest 6, including start year, start
% month, start day, end year, end month and end day
minArgs = 6;
maxArgs = 100;
narginchk(minArgs,maxArgs)

sstr = datestr(datenum(syr,smo,sda),'yyyy-mm-dd');
estr = datestr(datenum(eyr,emo,eda),'yyyy-mm-dd');

surl = ['http://service.iris.edu/fdsnws/event/1/query?nodata=404&format=text&starttime=',sstr,'&endtime=',estr];

nopt = nargin-6; % number of optional arguments

i = 1;
while i <= nopt    
    if strcmp(varargin{i},'-getrect')
        f = figure;
        load coast
        plot(long,lat,'b')
        hold on
        plot(long+360,lat,'k')
        plot(long-360,lat,'k')
        xlabel('Longitude','FontSize',15)
        ylabel('Latitude','FontSize',15)
        axis image
        axis([-270 270 -90 90])
        grid on
        set(gca,'YTick',-90:30:90,'XTick',-270:60:270)
        drawnow
        rect = getrect;
        close(f)
        surl = [surl,'&minlatitude=',num2str(rect(2))];
        surl = [surl,'&maxlatitude=',num2str(rect(2)+rect(4))];
        surl = [surl,'&minlongitude=',num2str(rect(1))];
        surl = [surl,'&maxlongitude=',num2str(rect(1)+rect(3))];
        
        i = i+1;
    else
        if (nopt<i+1)
            error(['Error in ',varargin{i+1-1},' argument'])
        end
        
        switch varargin{i}
            case 'maxlat'
                surl = [surl,'&maxlatitude=',num2str(varargin{i+1})];
            case 'minlat'
                surl = [surl,'&minlatitude=',num2str(varargin{i+1})];
            case 'maxlong'
                surl = [surl,'&maxlongitude=',num2str(varargin{i+1})];
            case 'minlong'
                surl = [surl,'&minlongitude=',num2str(varargin{i+1})];
            case 'latitude'
                surl = [surl,'&latitude=',num2str(varargin{i+1})];
            case 'longitude'
                surl = [surl,'&longitude=',num2str(varargin{i+1})];
            case 'maxrad'
                surl = [surl,'&maxradius=',num2str(varargin{i+1})];
            case 'minrad'
                surl = [surl,'&minradius=',num2str(varargin{i+1})];
            case 'minmag'
                surl = [surl,'&minmagnitude=',num2str(varargin{i+1})];
            case 'maxmag'
                surl = [surl,'&maxmagnitude=',num2str(varargin{i+1})];
            case 'mindepth'
                surl = [surl,'&mindepth=',num2str(varargin{i+1})];
            case 'maxdepth'
                surl = [surl,'&maxdepth=',num2str(varargin{i+1})];
            otherwise
                surl = [surl,'&',varargin{i},'=',varargin{i+1}];
        end
        i = i+2;
    end
end

if (strfind(surl,'minmag'))
else
    surl = [surl,'&minmag=2.5'];
end

fname = ['iris_eqlist_',datestr(now,'yyyy.mm.dd.HH.MM.SS'),'.txt'];
try
%    delete 'iris_eqlist_temporary.txt';
    urlwrite(surl,fname);
    source_data=importdata(fname);
catch
    error('Error in argument or downloading URL.')
end

for i = 2:length(source_data)
    temp = strsplit(source_data{i},'|','CollapseDelimiters',0);
    
    data(i-1,1:6) = datevec(temp{2},'yyyy-mm-ddTHH:MM:SS');
    
    k = 6;
    for j = [3,4,5,11]
        k = k+1;
        if (strcmp(temp{j},''))
            data(i-1,k) = -999;
        else
            data(i-1,k) = str2num(temp{j});
        end
    end
    
    k = 0;
    for j = [1,6,7,8,9,10,12,13]
        k = k+1;
        describe{i-1,k} = temp{j};
    end
end
end




