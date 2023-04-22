%Author: Matthew Jacobs, 10/8/21
%Takes velocity data from gaze_velocity(), start times of trials, and
%matlab behavioral data. 

%Trims out non trial data, and labels every row with trial number and study
%state 

%output:
% velocityData = [1) time (s), 
                 %2) x movement, 
                 %3) y movement, 
                 %4) gazepoint valid, 
                 %5) in Bounds valid, 
                 %6) x instaneous velocity, 
                 %7) y instaneous velocity, 
                 %8) Speed
                 %9) trial number,
                 %10) study state] 
function [trial_labled, thrown_out, overlap] = trim_trial_state_gaze_FINALR(gazeData, startTimes, matlab_filename)
    
    %Load in matlab data
    matlabData = load(matlab_filename);
    behaviorData= matlabData.trial_matrix;

    %add columns for trial number and matlab data
    column = zeros(length(gazeData),1);
    gazeData = [gazeData column column];
    clear column matlabData
    
    %First step, loop through each trial
    numTrials = size(startTimes); %number of trials recorded
    trialLength = 10; %hard coded from knowledge of experiment
    
    %loops through for each trial
    for i = 1:30
        start = startTimes(i);
        finish = startTimes(i) + trialLength;
        
        %find all the rows between start and end of the trial, and then
        %label them 
        trialIndices = find(gazeData(:,1) >= start & gazeData(:,1) <= finish);
        gazeData(trialIndices, 9) = i;
        
        %Time to add matlab data
        %Find indices of actions taken during this trial 
        actionIndices = find(behaviorData(:,2)==i);
        behaviorData(actionIndices, 6) = behaviorData(actionIndices, 6) + startTimes(i); %change time to gaze time
        stateIndices = [trialIndices(1)]; %start with start of trial which is first state
        %Find closest row for each behavior
        for j = 1:length(actionIndices)
            [minValue,closestIndex] = min(abs(gazeData(:,1)-behaviorData(actionIndices(j), 6)));
            stateIndices = [stateIndices closestIndex];
            if minValue >.016
                fprintf("Matlab allignement above sample rate: %f",minValue)
            end
        end
        stateIndices = [stateIndices trialIndices(length(trialIndices))]; %add last row of trial so know when to stop 
        
        %add state labels
        state = behaviorData(actionIndices(1),3)*100 + behaviorData(actionIndices(1),4)*10; 
        addition = 0;
        for y = 1:(length(stateIndices)-1) %loop through every state, but last one is just to indicate when to stop
            if y == 1
                gazeData(stateIndices(y):stateIndices(y+1),10) = state;
            else
                %establish what number to add, and add it
                
                if behaviorData(actionIndices(y-1),5) == 0 % no button press
                    addition = 0;
                elseif behaviorData(actionIndices(y-1),5) == 68 % D: vert
                    addition =  2;
                elseif behaviorData(actionIndices(y-1),5) == 74 % J: hor
                    addition = 3;
                elseif behaviorData(actionIndices(y-1),5) == -10 % D&J: both
                    addition = 5;
                else
                    fprintf("\nkey not found\n")
                    fprintf("\nkey:\n")
                    fprintf("\n%f",behaviorData(actionIndices(y-1),5))
                    fprintf("\nmat row:\n")
                    fprintf("%f",actionIndices(y-1))
                end
                gazeData(stateIndices(y):stateIndices(y+1),10) = state + addition;
            end
        end
        
    end
    
    %remove unneccessary data:
    
    %find indices of rows with no trial label
    deleteIndices = find(gazeData(:,9)==0);
    gazeData(deleteIndices, :) = [];
    
    trial_labled = gazeData;
    
    %find % of data thrown out per trial and how much exclusion criterion
    %overlap 
    thrown_out = zeros(1,30);
    overlap = zeros(1,30);
    
    for j = 1:30
        %trial info
        idx_in = find( gazeData(:,9)==j);
        
        %finding percentage per trial of thrown out lines of gaze data
        idx_out = find(isnan(gazeData(idx_in,2)));
        thrown_out(j) = length(idx_out)/length(idx_in);
        
        %finding percentage that out of bounds is same as Gazepoint
        %distinguished artifact
        idx_exclusion = find(gazeData(idx_in,5) == 0 | gazeData(idx_in,4)==0);
        idx_both_exclusion = find(gazeData(idx_in,5) == 0 & gazeData(idx_in,4)==0);
        
        if isempty(idx_exclusion) | isempty(idx_both_exclusion)
            overlap(j) = 0;
        else
            overlap(j) = length(idx_exclusion)/length(idx_both_exclusion);
        end
        
    end
    
    
       
end