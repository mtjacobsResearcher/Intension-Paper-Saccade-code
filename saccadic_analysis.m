%Author: Matthew Jacobs, 2/14/22
%Given gazeData for one participant and a saccadic velocity threshold, function will append
%saccade counts to gaze_velocity files. This is done per trial with
%saccadic model from Dam & van Ee 2006 model
%after analysis, it trims the first ten and last ten frames of trials for
%cleaner data (eg fewer cut off saccades )

%input:
%A) gazeData = [1) time (s),
    %2) x movement,
    %3) y movement,
    %4) gazepoint valid,
    %5) in Bounds valid,
    %6) x instaneous velocity,
    %7) y instaneous velocity,
    %8) Speed
    %9) trial number,
    %10) study state]

%B) llamda: Threshold for saccades

%Output: counts of saccades
        %updated gazeData
        %11) angle of movement
        %12) saccade marker
        %13) duration of saccade

function gazeData_trim = saccadic_analysis(gazeData, llamda)
    %add columns to gazeData if needed
    if size(gazeData,2) == 10
    
        columns = zeros(length(gazeData),3);
        gazeData = [gazeData, columns];
        
    end
    
    
    %add angles of movement (Old version, it will be replaced down below
%     angles = atan(gazeData(:,7)./gazeData(:,6)).*(180/pi);
%     gazeData(:,11) = angles;
    
    %atan(trial(:,2)./trial(:,1)).*(180/pi)
    
    %trial numbers (in case one or more are dropped)
    trials = unique(gazeData(:,9));
    
    for i = 1:length(trials)
       %isolate trial
       trial_num = trials(i);
       trial_idx = find(gazeData(:,9)==trial_num);
       
       trial_data = gazeData(trial_idx,:);
       
       %get a x and y velocity threshold
       [Nx Ny] = saccadic_threshold(trial_data, llamda);
       
       %mark the saccades
       saccade_marked = saccadeic_marker(trial_data, Nx,Ny);
       gazeData(trial_idx, 12) = saccade_marked;
       
        
    end
    
    %count gaze durations
    max_gaze_duration = max(gazeData(:,12));
%     
    while not(max_gaze_duration ==0)
        %find all of the durations that include this value, and don't
        %have a value above them
        duration_idx = find(gazeData(:,12)==max_gaze_duration)-(max_gaze_duration-1); %find where saccade is marked at that duration (so the 1 where it starts)
        subset_idx = find(gazeData(duration_idx,13)==0); %look back at start of saccade, and make sure there isn't a duraction recorded already    
        gazeData(duration_idx(subset_idx),13) = max_gaze_duration;
        max_gaze_duration = max_gaze_duration -1;
    end
    %Once you have durations, you know how many far frames ahead to check
    %for the end of the saccade. 
    %This information will help develop angle of motion: Absolute change in
    %position 
    
    %find saccades
    saccade_idx = find(gazeData(:,12)==1);
    
    %find two frames earlier for start of movement
    sac_start = saccade_idx-2;
    %make sure it doesn't go before start of frame 
    sac_start(sac_start<1) = 1; %set to first frame 
    
    %check that there are no nan values, if so move up one. Then do the
    %processes again
    sac_start(isnan(gazeData(sac_start,2))) = sac_start(isnan(gazeData(sac_start,2))) +1;
    sac_start(isnan(gazeData(sac_start,2))) = sac_start(isnan(gazeData(sac_start,2))) +1;
    
    %find end of saccades (since velocity is an average of 5 frames, I go
    %two frames ahead and behind end of saccadde
    sac_ends = saccade_idx + (gazeData(saccade_idx,13)+1); %Duration is one more than end, so plus 1 = 2 frames after saccade "end"
    %make sure it doesn't go off end (may screw up because overlap end of
    %trials)
    sac_ends(sac_ends>length(gazeData))=length(gazeData);
    
     %check that there are no nan values, if so move back one. Then do the
    %processes again
    sac_ends(isnan(gazeData(sac_ends,2))) = sac_ends(isnan(gazeData(sac_ends,2))) -1;
    sac_ends(isnan(gazeData(sac_ends,2))) = sac_ends(isnan(gazeData(sac_ends,2))) -1;
    
    x_values = gazeData(sac_ends,2) - gazeData(sac_start,2);
    y_values = gazeData(sac_ends,3) - gazeData(sac_start,3);
    
    
    angles = (atan(y_values./x_values).*(180/pi)) ;
    k1 = find(angles<0 & x_values < 0);
    
    
    k2 = find(angles>0 & x_values<0);
    
    
    k3 = find(angles<0 & x_values>0);
    angles(k1) = angles(k1)+180;
    angles(k2) = angles(k2) +180;
    angles(k3) = angles(k3)+360;
        
    gazeData(saccade_idx, 11) = angles; 
    
    
%     compare to avg
%     for i = 1:length(saccade_idx)
%         sac_start = saccade_idx;
%         sac_end = saccade_idx + (gazeData(saccade_idx,13)-1);
%         gazeData(saccade_idx(i), 14) = mean(abs(gazeData(sac_start(i):sac_end(i),11)));
%     end

    %     Trim 10 frames on begining and end of each trial
    gazeData_trim = [];
    for j = 1:length(trials)
        %isolate trial
        trial_num = trials(j);
        trial_idx = find(gazeData(:,9)==trial_num);

        trial_data = gazeData(trial_idx,:);
        
        gazeData_trim = [gazeData_trim; trial_data(11:(end-10),:)];


    end
    
    
end