if 1
    %get the participant, study state information, window size, and
    %exclusions
    fileName = 'Master_Gaze_participants_FINALR.xlsx';
    [nums, text] = xlsread(fileName);
%     participant_matrix = text(1:35,1:2);%:11, 1:2);
    participant_matrix = text(1:36,1:2);
    
    clear fileName nums text
    
    study_states = [110,112,113,210,212,213,310,312,313];
    
    window = 5;
    
    XoutBounds = true;
    Xinvalid = true;
    
    %PrepareGazeVelocities -> takes particpant list, cleans/prepares data to have velocities correctly 
    % velocities based on  Dam & van Ee 2006 model
    [thrown_out_struct, overlap_struct] = prepare_Gaze_Velocities(participant_matrix, study_states,window, XoutBounds, Xinvalid);
    %function order
    %1)gazePrep_FINALR
    %2)gaze_velocity_FINALR
    %3)trim_trial_state_gaze
    
    
    %count_Saccades ->takes list of participants, reads their velocities,
    %and adds counts of saccades & direction of saccade
    gazeData = count_Saccades_FINALR(participant_matrix,4);
    %1) trial analysis (goes through each trial) (saccadic_analysis)
       %1a) set thresthold  (saccadic_threshold)
       %2b) marks saccades (saccadic_marker)
       %3b) counts saccades(sac_counter)
    
    %[state_velocity_struct, thrown_out_struct, overlap_struct] = state_velocity_struct(participant_matrix, study_states,window, XoutBounds, Xinvalid);
    clear XoutBounds Xinvalid window study_states 
    
    
end 