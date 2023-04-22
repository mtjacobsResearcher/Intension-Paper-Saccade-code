%Author: Matthew Jacobs, 2/14/22
%Given velocity data and llamda scalar it returns velocity threshold for
%saccades

function [Nx Ny] = saccadic_threshold(trialData, llamda)
    

    %xy thresholds
    % x vel in column 6 and y is in column 7
    x_vel = trialData(:,6);
    x_vel_squared = x_vel.^2;
    
    y_vel = trialData(:,7);
    y_vel_squared = y_vel.^2;
    
    sigma_x = sqrt(mad((x_vel-mad(x_vel,1)).^2,1));    %mad(x_vel);%1.4826*mad(x_vel);%mad(x_vel_squared,1)-mad(x_vel)^2;
    sigma_y = sqrt(mad((y_vel-mad(y_vel,1)).^2,1));%mad(y_vel);%1.4826*mad(y_vel);%mad(y_vel_squared,1)-mad(y_vel)^2;
    
    %sigma_sqrd = median(x_vel_squared,'omitnan') - median(trialData(:,8),'omitnan')^2;
    %sigma_sqrd = geometric_median(x_vel_squared) - geometric_median(trialData(:,8))^2

    Nx = llamda*abs(sigma_x);%20;
    Ny = llamda*abs(sigma_y);%20;
    
    
    %fprintf("yes\n")
    %M = median(A,'omitnan') ignores all NaN values in A.
    % bootstat = median(bootstrp(100,@mean, trial))*6
    %median(bootstrp(100,@mean, trial(:,2).^2))-median(bootstrp(100,@mean, trial(:,2)))^2
end

