load('/Volumes/data/projects/carra/NC.mat')
%%
load('/Users/andrigun/Desktop/NC.mat')
%%
% Make anomaly plots for CARRA
% Variable to use
load('/Users/andrigun/Dropbox/04-Repos/carra_tools/geo_carra.mat')
%%
var = 'air_temperature_at_2m_agl'
%var = 'lwe_precipitation_rate'
%Baseline time period to use for anomalies
baseline_period = [datetime(1990,09,30),datetime(2020,10,01)];

nc.(string(var)) = NC.(string(var));
nc.Time = NC.Time;
sz = size(nc.(string(var)))
%%
% Create an empty array of the same size
data_ano = nan(sz);

for i = 1:12
    %Filter years to use
    ix = find(...
        (nc.Time.Year>=baseline_period.Year(1))&...
        (nc.Time.Year<=baseline_period.Year(2))&...
        (nc.Time.Month==i));

    mmean = mean(nc.(string(var))(:,:,ix),3,'omitmissing'); % mean for the period, month

    jx = find(...
        (nc.Time.Month==i));

    nc.Time(jx);
    nc.Time(ix)

    data_ano(:,:,jx) = nc.(string(var))(:,:,jx)-mmean;

end

nc.([char(string(var)),'_anomalies']) = data_ano;

nc.basePeriod = baseline_period;
%%
addpath /Users/andrigun/Dropbox/04-Repos/cdt/
addpath /Users/andrigun/Dropbox/04-Repos/cdt/cdt_data/
x = 36/2;
y = 52/2;

set(0,'defaultfigurepaperunits','centimeters');
set(0,'DefaultAxesFontSize',15)
set(0,'defaultfigurecolor','w');
set(0,'defaultfigureinverthardcopy','off');
set(0,'defaultfigurepaperorientation','landscape');
set(0,'defaultfigurepapersize',[y x]);
set(0,'defaultfigurepaperposition',[.25 .25 [y x]-0.5]);
set(0,'DefaultTextInterpreter','none');
set(0, 'DefaultFigureUnits', 'centimeters');
set(0, 'DefaultFigurePosition', [.25 .25 [y x]-0.5]);
%
startDate = datetime(2020,9,1); % Year, Month, Day format
numMonths = 46;

reference_period = startDate + calmonths(0:numMonths-1)
%%
% reference_period = [datetime(2023,09,01),...
%     datetime(2023,10,01),...
%     datetime(2023,11,01),...
%     datetime(2023,12,01)]
close all
fig = figure(Position=[3.2808    3.9158   54.5747   28.9631]), hold on
tiledlayout(7,7,'TileSpacing','none')
for i =1:numMonths

    nexttile, hold on
    set(fig, 'Color', 'k');
    ax = gca;
    set(ax, 'Color', 'k');
    set(ax, 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k');
    set(ax, 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k');
    ax.XLabel.Color = 'k';
    ax.YLabel.Color = 'k';
    ax.ZLabel.Color = 'k';
    ax.Title.Color = 'k';

    ix = find(nc.Time==reference_period(i))

    pcolor(double(NC.XLONG),double(NC.XLAT),...
        nc.([char(string(var)),'_anomalies'])(:,:,ix).*geo.ins.island_utlina)
    shading interp % eliminates black lines between grid cells
    hold on
    
    ylim([63.2,66.8])
    xlim([-25 -13.5])

    if i == numMonths
        cb1 = colorbar('southoutside');
        %xlabel(cb1,'Frávik úrkomu mm')
        xlabel(cb1,'Frávik lofthita °C')
        set(cb1, 'Color', 'w');
        cb1.Label.Color = 'w';
        set(cb1,'Position',[0.2 0.05 0.6 0.02])
        cb1.FontSize = 14;
             text(2.9,-0.3,['Viðmiðunartímabil: ',...
         datestr(baseline_period(1),'yyyy'),...
         ' - ',datestr(baseline_period(2),'yyyy')],...
         'Units','normalized','HorizontalAlignment','right',...
         'Color','w',...
         'VerticalAlignment','bottom','FontSize',14,'FontWeight','bold',...
         'Interpreter','none');
    else
    end

    switch var
        case 'air_temperature_at_2m_agl'
            clim([-5,5])
            cmocean('balance','pivot',0)
            %xlabel(cb1,'Frávik lofthita °C')

        case 'lwe_precipitation_rate'
            clim([-50,50])
            %cmocean('tarn','pivot',0)
            cmocean('balance','pivot',0)
            %xlabel(cb1,'Frávik úrkomu mm')
    end

    borders('iceland','k')

    t = title(datestr(reference_period(i),'mmm-yyyy'),...
        'Color','w','FontSize',10)
    set(t,'position',[-19 66.2 0])
 
end
%%
set(fig, 'Color', 'k');
set(gca,'color',[0 0 0]);
set(fig,'InvertHardcopy','off');

exportgraphics(gcf,['lwe_precipitation_rate.png']);%%



