%Author: Matthew Jacobs, 2/10/22
%Takes filename for gaze data, and extracts relevant gaze data. It scales
%the coordinates to the actual screen size, an checks for off screen
%samples.

%Output:
%Gaze Data = [time (s), x movement, y movement, gazepoint valid, in Bounds valid] 


function gazeData = gazePrep_FINALR(gazeFile)
    

    %Read it in and select collumns necesary 
    gazeData = xlsread(gazeFile,'D:N');
    requiredCols = [1,9,10,11]; 
    gazeData = gazeData(:, requiredCols);
    gazeData(:,5) = ones(length(gazeData),1);
    gazeData(:,2) = gazeData(:,2)*1680;
    gazeData(:,3) = gazeData(:,3)*1050;

    %Scale data
    clear requiredCols
    fprintf("\n GazePrep_FINALR: Read in all_gaze.csv correctly & scaled data\n")
    
    %Removes for out of bounds values (sets as NaN)
    outBounds = find(abs(gazeData(:,2)-840)> 840 | abs(gazeData(:,3)-525)>525);
    gazeData(outBounds, 5) = 0;
    fprintf("\n In Bounds rows deliniated \n")
    
    %overlap of out of bounds & artifacts
    overlap = gazeData(:,4)==gazeData(:,5);
    overlap = sum(overlap)/length(overlap);
    fprintf("Invalid/out of bound overlap: %f\n",overlap)
    
    
end
    
    
    
