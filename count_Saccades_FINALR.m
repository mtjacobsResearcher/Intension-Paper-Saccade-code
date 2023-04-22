%Author: Matthew Jacobs, 2/14/22
%Givena list of participants, will pull up their velocity records per trial
%(prepare_Gaze_Velocities), and count their saccades. Function will append
%saccade counts to gaze_velocity files for each participant

%input: 
%1) Particpant matrix has list of participants
%2)llamda sets the threshold for saccade counting (6 is suggested by
%papers, but in case we want to play with it)


%Saccadic model based on: Dam & van Ee 2006 model

function gazeData = count_Saccades_FINALR(participant_matrix, llamda)

    fprintf("\nCounting Saccades now in count_Saccades\n")
    
    %number of participants (each row is a particpant)
    num_participant = size(participant_matrix,1);
    fprintf("number of particpants: " + num_participant + "\n\n")
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
        
        % gazeData = [1) time (s), 
                 %2) x movement, 
                 %3) y movement, 
                 %4) gazepoint valid, 
                 %5) in Bounds valid, 
                 %6) x instaneous velocity, 
                 %7) y instaneous velocity, 
                 %8) Speed
                 %9) trial number,
                 %10) study state] 
                 
        gazeData = gazeData(:,1:10); %if reunning code, get rid of previous run
        gazeData = saccadic_analysis(gazeData, llamda);
         
        
        save('./gazeVelocities_FINALR/'+string(intials) +'_gaze_velocities.mat','gazeData')
        
        sac_counter(gazeData, string(intials));
        
    end


end
