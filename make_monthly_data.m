% Make moonthly mean data from carra

if ismac
    folder = '/Volumes/data/carra'
    addpath /Users/andrigun/Dropbox/04-Repos/cdt/

elseif isunix
    folder = '/data/carra'
    addpath '/data/git/cdt'
end
% Find daily Carra files 
d = dir([folder,'/*carra-sfc-wod.nc'])
%%
for k = 1:length(d)
    file = [d(k).folder,filesep,d(k).name];
    nc = ncstruct(file);
    disp(file)
    %% Make usable time
    nc.Time = datetime(nc.Times','Format','yyyy-MM-dd_HH:mm:SS');
    %%
    vars = fieldnames(nc);

for i = 1:length(vars)
        var = string(vars(i));
    switch var
        case [{'Time'},{'XLAT'},{'XLONG'}]
        
            mc.(string(var)) = nc.(string(var));
        
        case [...
                {'wind_from_direction_at_10m_agl'                    },
                {'wind_speed_at_10m_agl'                             },
                {'relative_humidity_at_2m_agl'                       },
                {'specific_humidity_at_2m_agl'                       },
                {'air_temperature_at_2m_agl'                         },
                {'cloud_base_height'                                 },
                {'air_pressure_at_sea_level'                         },
                {'surface_temperature'                               },
                {'surface_snow_density'                              },
                {'lwe_snow_depth'                                    },
                {'surface_downward_latent_heat_flux'                 },
                {'net_downward_shortwave_flux'                       },
                {'surface_net_thermal_radiation'                     },
                {'air_pressure_at_surface'                           },
                {'surface_downward_sensible_heat_flux'               },
                {'downward_shortwave_flux'                           },
                {'downward_longwave_flux'                            },
                {'cloud_area_fraction'                               },
                {'surface_upward_latent_heat_flux_due_to_sublimation'},
                {'visibility_in_air'                                 }]

                mc.(string(var)) = mean(nc.(string(var)),3,'omitmissing');

        case [...
                {'water_evaporation_amount'                          },
                {'lwe_percolation_rate'                              },
                {'lwe_runoff_surface_rate'                           },
                {'lwe_liquid_precipitation_rate'                     },
                {'lwe_solid_precipitation_rate'                      },
                {'lwe_precipitation_rate'                            }]
                mc.(string(var)) = sum(nc.(string(var)),3,'omitmissing');

    end
end

filename = strrep(file, '-carra-sfc_wod.nc', '-carra-month-sfc_wod.nc')

 if exist(filename, 'file')==2;
        delete(filename);
    else
 end

        disp(['##  Writing output data to ',filename]);
        fields = fieldnames(mc);

        for k = 1:length(fields) % All fields in dm structure are written to nc
            x = size(mc.(string(fields(k))));
            
            if x(1)== 301 % For spatial variables
                nccreate(filename,string(fields(k)),'Dimensions', {'x',301,'y',221},'Datatype','double');
                ncwrite(filename,string(fields(k)),double(mc.(fields{k})));
            elseif x(2) == 1 % For time vector
                referenceDate = datetime(1900,1,1); % Common reference date for NetCDF files
                timeInDays = days(mc.Time - referenceDate); % Convert to days since the reference date
                
                nccreate(filename, 'time', 'Dimensions', {'time', length(timeInDays)})
                
                ncwriteatt(filename, 'time', 'units', 'days since 1900-01-01 00:00:00');
                ncwriteatt(filename, 'time', 'calendar', 'gregorian');
                
                ncwrite(filename, 'time', timeInDays);

            end
        end
        
        ncwriteatt(filename,'/','Creation_date:',datestr(now));
        ncwriteatt(filename,'/','Project:','Carra - month ');
        ncwriteatt(filename,'/','Author:','andrigun');

end    
%% Convert datetime to "days since reference date"
        
   
    
                








