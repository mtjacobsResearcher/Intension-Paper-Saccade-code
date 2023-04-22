%Author: Matthew Jacobs, 2/10/22
%for final revision
%takes participant_matrix, study_states, window of smoothing (by median), and exlusion
%critera, and saves each participant's velocities matrix (with trials and
%study states labeled)

%Velocity model based on Dam & van Ee 2006 model

%output:
% file saved with Participant data, thrown_out_struct, overlap_struct

function [thrown_out_struct, overlap_struct] = prepare_Gaze_Velocities(participant_matrix,study_states,window, XoutBounds, Xinvalid)

fprintf("\n Calculating all velocities in prepare_Gaze_Velocities\n")

%this is where a function would start
%number of participants (each row is a particpant)
num_participant = size(participant_matrix,1);
fprintf("number of particpants: " + num_participant + "\n\n")
%make empty structures
thrown_out_struct = zeros(num_participant, 30);
overlap_struct = zeros(num_participant, 30);



%loop through each participant
for i = 1:num_participant
    
    
    
    %intials, matlab file loaded in
    intials = participant_matrix(i,1);
    fileNameMat = participant_matrix(i,2);
    fileNameMat = './all_subj_matlabfiles/'+string(fileNameMat)+'.mat';
    fprintf("On particpant: " + intials + "\n")
    fprintf("Number: " + i + "\n")
    
    %start times
    fprintf("Loading in start times now\n")
    %         start_file = '.\all_start_Times\'+string(intials) +' start times.xlsx';
    start_file = './all_start_Times/'+string(intials) +' start times.xlsx';
    
    startTimes = xlsread(start_file);
    
    %gazeData file name
    gaze_file = './all_gaze_csvfiles/' + string(intials) + '_all_gaze.xlsx';
    
    fprintf("\nRunning 'gazePrep->gaze_velocity->trim_trial_state_gaze->state_velocity' now\n")
    gazeData = gazePrep_FINALR(gaze_file);
    gazeData = gaze_velocity_FINALR(gazeData, window, XoutBounds, Xinvalid);
    %         keyboard
    [gazeData, thrown_out, overlap]= trim_trial_state_gaze_FINALR(gazeData, startTimes, fileNameMat);
    
    %         state_velocity_struct(:,:,i);
    thrown_out_struct(i,:) = thrown_out;
    overlap_struct(i,:) = overlap;
    
    %Save the gazeData frame
    %         save('.\gazeVelocities\'+string(intials) +'_gaze_velocities.mat','gazeData')
    save('./gazeVelocities_FINALR/'+string(intials) +'_gaze_velocities.mat','gazeData')
    %try to save memory by not holding previous data
    clear gazeData thrown_out overlap
end

end
