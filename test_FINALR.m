fileName = 'Master_Gaze_participants_FINALR.xlsx';
[nums, text] = xlsread(fileName);
%     participant_matrix = text(1:35,1:2);%:11, 1:2);
participant_matrix = text(10:35,1:2);

num_participant = size(participant_matrix,1);
fprintf("number of particpants: " + num_participant + "\n\n")

max_durs = [];
avg_dif_btwn_mean_and_positionChange = [];
max_dif_btwn_mean_and_positionChange = [];
for i = 1:num_participant
    
    %intials, matlab file loaded in
    intials = participant_matrix(i,1);
    fprintf("On particpant: " + intials + "\n")
    fprintf("Number: " + i + "\n")
    
    %gazeData file name
    velocity_file = './gazeVelocities_FINALR/' + string(intials) + '_gaze_velocities.mat';
    
    %load gazeData
    matData = load(velocity_file);
    gazeData = matData.gazeData;
    
    %check the max duration of saccades
    max_durs(i) = max(gazeData(:,13));
    
    %check what the avg difference & max difference is between two styles
    %of angle
%     sac_idx = gazeData(:,14)~=0;
%     differences = abs(abs(gazeData(sac_idx,14))-abs(gazeData(sac_idx,15)));
%     
%     avg_dif_btwn_mean_and_positionChange(i) = nanmean(differences);
%     max_dif_btwn_mean_and_positionChange(1,i) = max(differences);
%     where_max = find(max(differences)== abs(abs(gazeData(:,14))-abs(gazeData(:,15))));
%     max_dif_btwn_mean_and_positionChange(2,i) = gazeData(where_max,13);
    
    
    sum(isnan(gazeData(:,11)));
    animateEyeGaze(gazeData, [1],1,0)
    fprintf("\n close it nowwww");
    pause(5);
    
end