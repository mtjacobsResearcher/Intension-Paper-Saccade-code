%Author: Matthew Jacobs, 10/7/21
%Smoothes data & calculate velocity based on parameters given
%Velocity model based on: Dam & van Ee 2006 model

%gazeData is from gazePrep_FINALR()
%window = number of frames you want in smoothing
%XoutBounds = exclude out of bounds views when True
%Xinvalid = exclude rows gazepoint determined artifacted when True

%output:
% velocityData = [1) time (s), 
                 %2) x movement, 
                 %3) y movement, 
                 %4) gazepoint valid, 
                 %5) in Bounds valid, 
                 %6) x  velocity, 
                 %7) y  velocity, 
                 %8) speed


function velocityData = gaze_velocity_FINALR(gazeData, window, XoutBounds, Xinvalid)
    
   
    %implement exclusions
    if XoutBounds %if we exclude out of bounds
        gazeData(gazeData(:,5)==0,2:3) = nan;  
    end
    if Xinvalid %if we exclude in bounds
        gazeData(gazeData(:,4)==0,2:3) = nan; 
    end
    
%     keyboard
    %Smooth Data
    %Smoothdata(matrix, 1=col 2=rows, 'type of smooth', window size, 'omitnan')
    gazeData(:,2:3) = smoothdata(gazeData(:,2:3),1,'movmedian',window,'omitnan');
   
    %omitnan means that for a row with a nan value surrounded by numbers
    %will be calculated. so need to re-remove those values
    if XoutBounds %if we exclude out of bounds
        gazeData(gazeData(:,5)==0,2:3) = nan;  
    end
    if Xinvalid %if we exclude in bounds
        gazeData(gazeData(:,4)==0,2:3) = nan; 
    end
    
    %Eye tracker is 60Hz so detla t is about 1/60 seconds or .0167
    delta_t = 1/60;
    
    %5 point velocity model 
    %->Vn = velocity vectory at sample n
    %->Xi = sample i
    % ->Vn = (->Xn+2 + ->Xn+1 - ->Xn-1 - ->Xn-2) / 6*(delta t)
    
    %applies to each point. Any overlap with NAN values or ends is ignored
    %start at first value can calculate and end at last value
    gazeData = [gazeData zeros(length(gazeData),1) zeros(length(gazeData),1)];
    
    for i = 3:(length(gazeData)-2)
        
        subset5PositionNext = [gazeData(i+2, 2:3); gazeData(i+1, 2:3)];
        subset5PositionBefore = [gazeData(i-1, 2:3); gazeData(i-2, 2:3)];
        
        %check for nan values
        if sum(isnan(subset5PositionNext),'all')>1 || sum(isnan(subset5PositionBefore),'all')>1
            velocities = [nan nan];
           
        else 
            %Vector addition:
            vector_sum = sum(subset5PositionNext) - sum(subset5PositionBefore);
            %Scale 6 delta t
            velocities = vector_sum./(6);%*delta_t); 
        end
        
        %save velocities to Matrix
        gazeData(i,6:7) = velocities;
        
        %save the speed to Matrix
        gazeData(i,8) = norm(gazeData(i,6:7));
        
    end
    
      %Old way of doing it
%     %calculate velocity (row about - row below = instaneous velocity of x or y)
%     xvel = [nan; gazeData(2:length(gazeData),2) - gazeData(1:(length(gazeData)-1),2)];
%     yvel = [nan; gazeData(2:length(gazeData),3) - gazeData(1:(length(gazeData)-1),3)];
%     %Each row of xvel,yvel is a vector of change which we need to magnitude
%     %of
%     xyvel = zeros(length(xvel),1);
%     for i = 1:length(xyvel)
%         xyvel(i) = norm([xvel(i),yvel(i)]);
%     end
    
   
%     gazeData = [gazeData, xvel, yvel,xyvel];
%     %Velocity caluculation leave zeros, this will readd NaN values to
%     %appropriate rows
%     if XoutBounds %if we exclude out of bounds
%         gazeData(gazeData(:,5)==0,6:8) = nan;  
%     end
%     if Xinvalid %if we exclude in bounds
%         gazeData(gazeData(:,4)==0,6:8) = nan; 
%     end
    
    
    velocityData = gazeData; 

end
    
    
    
