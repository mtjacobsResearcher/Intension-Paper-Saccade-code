%Author: Matthew Jacobs, 2/15/22
%Given velocity data and specifications, animates eye gaze

%trials = which trials do you want to animate
%position = boolean of whether you want eye gaze specificied
%velocity = boolean of whether you want velocity animated


function animateEyeGaze(gazeData, trials, position, velocity)
    
    for trial_num = 1:length(trials)
        pause(1)
        %subset to just the trial at hand
        trial_idx = find(gazeData(:,9)==trials(trial_num));
        animated_trial = gazeData(trial_idx,:);
        
        %add frames to the end in case saccade at the very end
        last_frame = trial_idx(length(trial_idx));
        animated_trial = [animated_trial;gazeData(last_frame+1,:);gazeData(last_frame+1,:)];

        if position
            figure(trial_num+100)
            h = animatedline;
            g = animatedline('Color','r');
            axis([0,1680,0,1050])
            for i = 1:length(animated_trial)
                addpoints(h,animated_trial(i,2),animated_trial(i,3));
                if animated_trial(i,12)>0
                    addpoints(h,animated_trial(i,2),animated_trial(i,3))
                    %5 frames avg
                    addpoints(g,animated_trial(i-2,2),animated_trial(i-2,3))
                    addpoints(g,animated_trial(i-1,2),animated_trial(i-1,3))
                    addpoints(g,animated_trial(i,2),animated_trial(i,3));
                    addpoints(g,animated_trial(i+1,2),animated_trial(i+1,3))
                    addpoints(g,animated_trial(i+2,2),animated_trial(i+2,3))
                    
                else
                    addpoints(h,animated_trial(i,2),animated_trial(i,3));
                end
%                 pause(.01)
                pause(.0167)
                drawnow
            end

        end

        if velocity
            figure(trial_num+1000)
            h = animatedline;
            g = animatedline('Color','r');
            axis([-60,60,-60,60])
            for i = 1:length(animated_trial)
                if animated_trial(i,12)>0
                    addpoints(h,animated_trial(i,6),animated_trial(i,7))
                   
                    addpoints(g,animated_trial(i-2,6),animated_trial(i-2,7))
                    addpoints(g,animated_trial(i-1,6),animated_trial(i-1,7))
                    addpoints(g,animated_trial(i,6),animated_trial(i,7));
                    addpoints(g,animated_trial(i+1,6),animated_trial(i+1,7))
                    addpoints(g,animated_trial(i+2,6),animated_trial(i+2,7))
                else
                    addpoints(h,animated_trial(i,6),animated_trial(i,7));
                end
                pause(.01)
                drawnow
            end

        end



    end

end