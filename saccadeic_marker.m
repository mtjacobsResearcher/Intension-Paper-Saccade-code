%Author: Matthew Jacobs, 2/15/22
%Given velocity data and thresholds it returns a vector marked with
%saccades (0 = no, 1 = start, 2/3 (sustained saccade))


function saccade_marked = saccadeic_marker(trial_data, Nx,Ny)
    
    saccade_val = 0;
    
    saccade_marked = zeros(length(trial_data),1);
    
    for i = 1:length(trial_data)
        %if absolute velocity is greater than threshold for x or y, then mark saccade
        if abs(trial_data(i,6)) >=Nx || abs(trial_data(i,7)) >=Ny 
            saccade_val = saccade_val +1;
            saccade_marked(i) = saccade_val;
        else
            saccade_val = 0;
        end
        
    end
end