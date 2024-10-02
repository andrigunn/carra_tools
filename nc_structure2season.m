function [OS] = nc_structure2season(nc,var)

% nc: a stack of data that needs to have datetime vector as nc.time
% var: the variable to process

%var = 'air_temperature_at_2m_agl'
uqy = unique(nc.Time.Year);
%%
clear OS
% Winter mean ONDJFMA
clc
for i = 1:length(uqy)

    ix = find(...
        (nc.Time >= datetime(uqy(i),10,1)) &...
        (nc.Time <= datetime(uqy(i)+1,04,31)));

    if isempty(ix)
        continue
    else
    end

    OS.mean.ONDJFMA(:,:,i) =...
        mean(nc.(string(var))(:,:,ix),3);

    OS.sum.ONDJFMA(:,:,i) =...
        sum(nc.(string(var))(:,:,ix),3);

    OS.mean.ONDJFMA_times(i,1) = datetime(uqy(i),10,1);
    OS.mean.ONDJFMA_times(i,2) = datetime(uqy(i)+1,04,31);

    OS.sum.ONDJFMA_times(i,1) = datetime(uqy(i),10,1);
    OS.sum.ONDJFMA_times(i,2) = datetime(uqy(i)+1,04,31);


end

% FALL
for i = 1:length(uqy)

    ix = find(...
        (nc.Time >= datetime(uqy(i),9,1)) &...
        (nc.Time <= datetime(uqy(i),11,31)));

    if isempty(ix)
        continue
    else
    end

    OS.mean.SON(:,:,i) =...
        mean(nc.(string(var))(:,:,ix),3);

    OS.sum.SON(:,:,i) =...
        sum(nc.(string(var))(:,:,ix),3);

    OS.mean.SON_times(i,1) = datetime(uqy(i),9,1);
    OS.mean.SON_times(i,2) = datetime(uqy(i),11,31);

    OS.sum.SON_times(i,1) = datetime(uqy(i),9,1);
    OS.sum.SON_times(i,2) = datetime(uqy(i),11,31);


end

% Summer

for i = 1:length(uqy)

    ix = find(...
        (nc.Time >= datetime(uqy(i),5,1)) &...
        (nc.Time <= datetime(uqy(i),08,31)));

    if isempty(ix)
        continue
    else
    end

    OS.mean.MJJA(:,:,i) =...
        mean(nc.(string(var))(:,:,ix),3);

    OS.sum.MJJA(:,:,i) =...
        sum(nc.(string(var))(:,:,ix),3);

    OS.mean.MJJA_times(i,1) = datetime(uqy(i),5,1);
    OS.mean.MJJA_times(i,2) = datetime(uqy(i),08,31);

    OS.sum.MJJA_times(i,1) = datetime(uqy(i),5,1);
    OS.sum.MJJA_times(i,2) = datetime(uqy(i),08,31);


end

% Spring

for i = 1:length(uqy)

    ix = find(...
        (nc.Time >= datetime(uqy(i),4,1)) &...
        (nc.Time <= datetime(uqy(i),5,31)));

    if isempty(ix)
        continue
    else
    end

    OS.mean.AM(:,:,i) =...
        mean(nc.(string(var))(:,:,ix),3);

    OS.sum.AM(:,:,i) =...
        sum(nc.(string(var))(:,:,ix),3);

    OS.mean.AM_times(i,1) = datetime(uqy(i),4,1);
    OS.mean.AM_times(i,2) = datetime(uqy(i),5,31);

    OS.sum.AM_times(i,1) = datetime(uqy(i),4,1);
    OS.sum.AM_times(i,2) = datetime(uqy(i),5,31);


end
% Winter

for i = 1:length(uqy)

    ix = find(...
        (nc.Time >= datetime(uqy(i),12,1)) &...
        (nc.Time <= datetime(uqy(i)+1,03,31)));

    if isempty(ix)
        continue
    else
    end

    OS.mean.DJF(:,:,i) =...
        mean(nc.(string(var))(:,:,ix),3);

    OS.sum.DJF(:,:,i) =...
        sum(nc.(string(var))(:,:,ix),3);

    OS.mean.DJF_times(i,1) = datetime(uqy(i),12,1);
    OS.mean.DJF_times(i,2) = datetime(uqy(i)+1,03,31);

    OS.sum.DJF_times(i,1) = datetime(uqy(i),12,1);
    OS.sum.DJF_times(i,2) = datetime(uqy(i)+1,03,31);


end
% MJ
for i = 1:length(uqy)

    ix = find(...
        (nc.Time >= datetime(uqy(i),05,1)) &...
        (nc.Time <= datetime(uqy(i),06,31)));

    if isempty(ix)
        continue
    else
    end

    OS.mean.MJ(:,:,i) =...
        mean(nc.(string(var))(:,:,ix),3);

    OS.sum.MJ(:,:,i) =...
        sum(nc.(string(var))(:,:,ix),3);

    OS.mean.MJ_times(i,1) = datetime(uqy(i),05,1);
    OS.mean.MJ_times(i,2) = datetime(uqy(i),06,31);

    OS.sum.MJ_times(i,1) = datetime(uqy(i),05,1);
    OS.sum.MJ_times(i,2) = datetime(uqy(i),06,31);


end

