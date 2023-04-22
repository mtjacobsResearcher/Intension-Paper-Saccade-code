if 1
    fileName = 'Master_Gaze_participants_FINALR.xlsx';
    [nums, text] = xlsread(fileName);
    %     participant_matrix = text(1:35,1:2);%:11, 1:2);
    participant_matrix = text(1:36,1:2);
    
    num_participant = size(participant_matrix,1);
    fprintf("number of particpants: " + num_participant + "\n\n")
    
    total_counts = [110,112,113,210,212,213,310,312,313; zeros(5,9)];
    
    %j = [1:num_participant];
    j = [1:6 8:num_participant];
    %j = [1:36];
    counts_frame = zeros(5,9,length(j));
    [x, y, z] = size(counts_frame);
    
    for i = 1:z
        
        %intials, matlab file loaded in
        intials = participant_matrix(j(i),1);
        fprintf("On particpant: " + intials + "\n")
        fprintf("Number: " + j(i) + "\n")
        
        
        %saccadeCounts
        saccade_file = './saccadeCounts_FINALR/'+string(intials)+'_saccade_counts.mat';
        
        matData = load(saccade_file);
        counts = matData.counts;
       
        
        % One edge case where 36th person only has 29 trials
        %This is new, maybe my old solution is why the graphs are
        %different?
        if j(i) ==36
            counts = [zeros(6,1) counts];
            counts(1,1) = 1;
        end
        counts = counts(2:6,31:39);
        
        %normalize the values & change into saccades per second
        counts(1:2,:) = (counts(1:2,:)./counts(5,:)).*60;
        counts(isnan(counts))=0;
        
        counts_frame(:,:,i) = counts;
        
            
        total_counts(2:6,:) = total_counts(2:6,:)+ counts;
        
        
    end
    
    %fix the avg durations
    total_counts(4:5,:) = total_counts(4:5,:)./z;
    
    %divide by number of participants for average
    total_counts(2:3,:) = total_counts(2:3,:)./z;
    
    %multiply by 60 to change from units of sac/frame to sac/second
    %total_counts(2:3,:) = total_counts(2:3,:).*60;
    
    clear matData intials saccade_file i num_participant fileName nums text participant_matrix counts
end
%change trials
SS_110_h = reshape(counts_frame(1,1,:),[1,z]);
SS_110_v = reshape(counts_frame(2,1,:),[1,z]);
sum_110 = [SS_110_h + SS_110_v];
dif_110 = [SS_110_v - SS_110_h];

SS_112_h = reshape(counts_frame(1,2,:),[1,z]);
SS_112_v = reshape(counts_frame(2,2,:),[1,z]);
sum_112 = [SS_112_h + SS_112_v];
dif_112 = [SS_112_v - SS_112_h];

SS_113_h = reshape(counts_frame(1,3,:),[1,z]);
SS_113_v = reshape(counts_frame(2,3,:),[1,z]);
sum_113 = [SS_113_h + SS_113_v];
dif_113 = [SS_113_v - SS_113_h];

%hold horizontal
SS_210_h = reshape(counts_frame(1,4,:),[1,z]);
SS_210_v = reshape(counts_frame(2,4,:),[1,z]);
sum_210 = [SS_210_h + SS_210_v];
dif_210 = [SS_210_v - SS_210_h];

SS_212_h = reshape(counts_frame(1,5,:),[1,z]);
SS_212_v = reshape(counts_frame(2,5,:),[1,z]);
sum_212 = [SS_212_h + SS_212_v];
dif_212 = [SS_212_v - SS_212_h];

SS_213_h = reshape(counts_frame(1,6,:),[1,z]);
SS_213_v = reshape(counts_frame(2,6,:),[1,z]);
sum_213 = [SS_213_h + SS_213_v];
dif_213 = [SS_213_v - SS_213_h];

%hold vertical
SS_310_h = reshape(counts_frame(1,7,:),[1,z]);
SS_310_v = reshape(counts_frame(2,7,:),[1,z]);
sum_310 = [SS_310_h + SS_310_v];
dif_310 = [SS_310_v - SS_310_h];

SS_312_h = reshape(counts_frame(1,8,:),[1,z]);
SS_312_v = reshape(counts_frame(2,8,:),[1,z]);
sum_312 = [SS_312_h + SS_312_v];
dif_312 = [SS_312_v - SS_312_h];


SS_313_h = reshape(counts_frame(1,9,:),[1,z]);
SS_313_v = reshape(counts_frame(2,9,:),[1,z]);
sum_313 = [SS_313_h + SS_313_v];
dif_313 = [SS_313_v - SS_313_h];

%T-test on just 7 who reported using strategies
i_strat = [8,10,13,18,29,32,35];

hold_7 = (sum_210(i_strat) + sum_212(i_strat) + sum_213(i_strat) + sum_310(i_strat) + sum_312(i_strat) + sum_313(i_strat))./2;
change_7 = sum_110(i_strat) + sum_112(i_strat) + sum_113(i_strat);

hold_rest = (sum_210 + sum_212 + sum_213 + sum_310 + sum_312 + sum_313)./2;
hold_rest(i_strat) = [];
change_rest = sum_110 + sum_112 + sum_113;
change_rest(i_strat) = [];


%[h000,p000,ci,stats] = ttest(hold - change);
 [h001,p001,ci,stats] = ttest2(change_7,change_rest)

% if 0
%     [h1,p1,ci,stats] = ttest(SS_112_h-SS_112_v);
%     [h2,p2,ci,stats] = ttest(SS_113_h-SS_113_v);
%     [h3,p3,ci,stats] = ttest(SS_212_h-SS_212_v);
%     [h4,p4,ci,stats] = ttest(SS_213_h-SS_213_v);
%     [h5,p5,ci,stats] = ttest(SS_312_h-SS_312_v);
%     [h6,p6,ci,stats] = ttest(SS_313_h-SS_313_v);
%     %
%     figure(37);
%     data = [total_counts(2:3,2)'; total_counts(2:3,3)';total_counts(2:3,5)';total_counts(2:3,6)';total_counts(2:3,8)';total_counts(2:3,9)'];
%     b = bar(data, 'grouped');
%     %set(b,'facecolor', [.5 .2 .2, .2 .7 .7])
%     X =zeros(6,2);
%     for i = 1:2
%         points = b(i).XEndPoints;
%         X(1,i) = points(1);
%         X(2,i) = points(2);
%         X(3,i) = points(3);
%         X(4,i) = points(4);
%         X(5,i) = points(5);
%         X(6,i) = points(6);
%     end
%     set(gca, 'xticklabel', {'112','113','212','213','312','313'})
%     legend({'Horizontal Saccade/sec','Vertical Saccade/sec'})
%     SEMs = [nanstd(SS_112_h)/sqrt(z) nanstd(SS_112_v)/sqrt(z);
%         nanstd(SS_113_h)/sqrt(z) nanstd(SS_113_v)/sqrt(z);
%         nanstd(SS_212_h)/sqrt(z) nanstd(SS_212_v)/sqrt(z);
%         nanstd(SS_213_h)/sqrt(z) nanstd(SS_213_v)/sqrt(z);
%         nanstd(SS_312_h)/sqrt(z) nanstd(SS_312_v)/sqrt(z);
%         nanstd(SS_313_h)/sqrt(z) nanstd(SS_313_v)/sqrt(z);];
%     title('Vertical and horizontal average saccade rates in different perceptual states')
%     hold on
%     errorbar(X, data, SEMs,'k','linestyle','none');
%     
%     %by instruction
%     
%     %change instruction"
%     change_h = (SS_110_h + SS_112_h + SS_113_h)./3;
%     change_v = (SS_110_v + SS_112_v + SS_113_v)./3;
%     
%     %hold vert instruction"
%     holdVert_h = (SS_210_h + SS_212_h + SS_213_h)./3;
%     holdVert_v = (SS_210_v + SS_212_v + SS_213_v)./3;
%     
%     %hold horz instruction"
%     holdHorz_h = (SS_310_h + SS_312_h + SS_313_h)./3;
%     holdHorz_v = (SS_310_v + SS_312_v + SS_313_v)./3;
%     
%     [h7,p7,ci,stats] = ttest(change_h-change_v);
%     [h8,p8,ci,stats] = ttest(holdVert_h-holdVert_v);
%     [h9,p9,ci,stats] = ttest(holdHorz_h-holdHorz_v);
%     
%     
%     figure(38);
%     data = [mean(change_h) mean(change_v); mean(holdVert_h) mean(holdVert_v); mean(holdHorz_h) mean(holdHorz_v)];
%     b = bar(data,'grouped');
%     X =zeros(3,2);
%     for i = 1:2
%         points = b(i).XEndPoints;
%         X(1,i) = points(1);
%         X(2,i) = points(2);
%         X(3,i) = points(3);
%     end
%     set(gca, 'xticklabel', {'Change','Hold Vertical','Hold Horizontal'})
%     legend({'Horizontal Saccade/sec','Vertical Saccade/sec'})
%     SEMs = [nanstd(change_h)/sqrt(z) nanstd(change_v)/sqrt(z);
%         nanstd(holdVert_h)/sqrt(z) nanstd(holdVert_v)/sqrt(z);
%         nanstd(holdHorz_h)/sqrt(z) nanstd(holdHorz_v)/sqrt(z); ];
%     title('Vertical and horizontal average saccade rates for different instructions')
%     hold on
%     errorbar(X, data, SEMs,'k','linestyle','none');
%     
%     
%     %by perception
%     %neither
%     perNeither_h = (SS_110_h + SS_210_h + SS_310_h)./3;
%     perNeither_v = (SS_110_v + SS_210_v + SS_310_v)./3;
%     
%     %vertical
%     perVert_h = (SS_112_h + SS_212_h + SS_312_h)./3;
%     perVert_v = (SS_112_v + SS_212_v + SS_312_v)./3;
%     
%     %horizontal
%     perHorz_h = (SS_113_h + SS_213_h + SS_313_h)./3;
%     perHorz_v = (SS_113_v + SS_213_v + SS_313_v)./3;
%     
%     [h10,p10,ci,stats] = ttest(perNeither_h-perNeither_v);
%     [h11,p11,ci,stats] = ttest(perVert_h-perVert_v);
%     [h12,p12,ci,stats] = ttest(perHorz_h-perHorz_v);
%     
%     figure(39);
%     data = [mean(perNeither_h) mean(perNeither_v); mean(perVert_h) mean(perVert_v); mean(perHorz_h) mean(perVert_v)];
%     b = bar(data,'grouped');
%     X =zeros(3,2);
%     for i = 1:2
%         points = b(i).XEndPoints;
%         X(1,i) = points(1);
%         X(2,i) = points(2);
%         X(3,i) = points(3);
%     end
%     set(gca, 'xticklabel', {'Neither','Vertical','Horizontal'})
%     legend({'Horizontal Saccade/sec','Vertical Saccade/sec'})
%     SEMs = [nanstd(perNeither_h)/sqrt(z) nanstd(perNeither_v)/sqrt(z);
%         nanstd(perVert_h)/sqrt(z) nanstd(perVert_v)/sqrt(z);
%         nanstd(perHorz_h)/sqrt(z) nanstd(perHorz_v)/sqrt(z); ];
%     title('Vertical and horizontal average saccade rates for different perceptual states')
%     hold on
%     errorbar(X, data, SEMs,'k','linestyle','none');
%     
%     
%     %by congruence
%     %Hold Vert
%     conVert_h = SS_212_h;
%     conVert_v = SS_212_v;
%     
%     inVert_h =(SS_210_h + SS_213_h)./2;
%     inVert_v =(SS_210_v + SS_213_v)./2;
%     
%     %Hold Horizontal
%     conHorz_h = SS_313_h;
%     conHorz_v = SS_313_v;
%     
%     inHorz_h =(SS_310_h + SS_312_h)./2;
%     inHorz_v =(SS_310_v + SS_312_v)./2;
%     
%     [h13,p13,ci,stats] = ttest(conVert_h-conVert_v);
%     [h14,p14,ci,stats] = ttest(inVert_h-inVert_v);
%     [h15,p15,ci,stats] = ttest(conHorz_h-conHorz_v);
%     [h16,p16,ci,stats] = ttest(inHorz_h-inHorz_v);
%     
%     
%     figure(40);
%     data = [mean(conVert_h) mean(conVert_v); mean(inVert_h) mean(inVert_v); mean(conHorz_h) mean(conHorz_v); mean(inHorz_h) mean(inHorz_v)];
%     b = bar(data,'grouped');
%     X =zeros(4,2);
%     for i = 1:2
%         points = b(i).XEndPoints;
%         X(1,i) = points(1);
%         X(2,i) = points(2);
%         X(3,i) = points(3);
%         X(4,i) = points(4);
%     end
%     set(gca, 'xticklabel', {'Con Vert','Incon Vert','Con Horz','InCon Horz'})
%     legend({'Horizontal Saccade/sec','Vertical Saccade/sec'})
%     SEMs = [nanstd(conVert_h)/sqrt(z) nanstd(conVert_v)/sqrt(z);
%         nanstd(inVert_h)/sqrt(z) nanstd(inVert_v)/sqrt(z);
%         nanstd(conHorz_h)/sqrt(z) nanstd(conHorz_v)/sqrt(z);
%         nanstd(inHorz_h)/sqrt(z) nanstd(inHorz_v)/sqrt(z);
%         ];
%     title('Vertical and horizontal average saccade rates for different congruences')
%     hold on
%     errorbar(X, data, SEMs,'k','linestyle','none');
%     
% end

% Nick Feedback section

% %Graph of differences (includes STD)
color_white = [1,1,1]
figure(41);
data = [mean(dif_112) mean(dif_113); %v-h
    mean(dif_212) mean(dif_213);
    mean(dif_312) mean(dif_313); ];
b = bar(data,'grouped','FaceColor', 'w');
X =zeros(3,2);
for i = 1:2
    points = b(i).XEndPoints;
    X(1,i) = points(1);
    X(2,i) = points(2);
    X(3,i) = points(3);
    
end
set(gca,'fontsize',26); 
set(gca, 'xticklabel', {'Change','Hold Vertical','Hold Horizontal'})
xlabel("Instruction")
ylabel("Vertical saccade bias per second")
[a, b ,c ,d] = legend({%'Other Percep',
    'Vertical Percept','Horizontal Percept'})
axis([0 4 -.8 .8]);
SEMs = [nanstd(dif_112)/sqrt(z) nanstd(dif_113)/sqrt(z);
    nanstd(dif_212)/sqrt(z) nanstd(dif_213)/sqrt(z);
    nanstd(dif_312)/sqrt(z) nanstd(dif_313)/sqrt(z);
    ];
%title('Difference between vertical and horizontal saccade rates')

hold on
errorbar(X, data, SEMs,'k','linestyle','none');
set(gcf,'color',[color_white]); %set fig color to white
set(gca,'color',[color_white]);
% 
% %Graph of Sums
figure(42);
data = [mean(sum_112) mean(sum_113);
    mean(sum_212) mean(sum_213);
    mean(sum_312) mean(sum_313); ];
b = bar(data,'grouped','FaceColor', 'w');
X =zeros(3,2);
for i = 1:2
    points = b(i).XEndPoints;
    X(1,i) = points(1);
    X(2,i) = points(2);
    X(3,i) = points(3);
    
end
axis([0 4 0 1.6]);
set(gca,'fontsize',26); 
set(gca,'xticklabel', {'Change','Hold Vertical','Hold Horizontal'})
xlabel('Instruction')
ylabel('Total saccades per second')
set(gcf,'color',[color_white]); %set fig color to white
set(gca,'color',[color_white]);
[a b c d] = legend({%'Other Percep',
    'Vertical Percept','Horizontal Percept'})
SEMs = [nanstd(sum_112)/sqrt(z) nanstd(sum_113)/sqrt(z);
    nanstd(sum_212)/sqrt(z) nanstd(sum_213)/sqrt(z);
    nanstd(sum_312)/sqrt(z) nanstd(sum_313)/sqrt(z);
    ];
%title('Total Saccade rates (Sacs/sec)')
hold on
errorbar(X, data, SEMs,'k','linestyle','none');



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Figures below with Allie's edits 
% % Note that the above section is temporarily commented just so fewer 
% % graphs pop up
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% color_white = [1,1,1]
% 
% %Graph of Sums
% figure(44);
% subplot(121);
% data = [mean(sum_112) mean(sum_113);
%     mean(sum_212) mean(sum_213);
%     mean(sum_312) mean(sum_313); ];
% b = bar(data,'grouped');%,'FaceColor','w');
% X =zeros(3,2);
% for i = 1:2
%     points = b(i).XEndPoints;
%     X(1,i) = points(1);
%     X(2,i) = points(2);
%     X(3,i) = points(3);
%     
% end
% 
% axis([0 4 0 .6]);
% set(gca,'fontsize',22); 
% set(gca,'xticklabel', {'Change','Hold Vertical','Hold Horizontal'})
% xlabel('Instruction')
% ylabel('Total saccades per second')
% %set(gcf,'color',[color_white]); %set fig color to white
% %set(gca,'color',[color_white]); %set axis color to white
% [a b c d] = legend({%'Other Percep',
%     'Vertical Percept','Horizontal Percept'})
% SEMs = [nanstd(sum_112)/sqrt(z) nanstd(sum_113)/sqrt(z);
%     nanstd(sum_212)/sqrt(z) nanstd(sum_213)/sqrt(z);
%     nanstd(sum_312)/sqrt(z) nanstd(sum_313)/sqrt(z);
%     ];
% title('Total Saccade rates (Sacs/sec)')
% hold on
% errorbar(X, data, SEMs,'k','linestyle','none');
% % 
% % 
% %Graph of differences (includes STD)
% subplot(122);
% data = [mean(dif_112) mean(dif_113); %v-h
%     mean(dif_212) mean(dif_213);
%     mean(dif_312) mean(dif_313); ];
% b = bar(data,'grouped','FaceColor','w');
% X =zeros(3,2);
% for i = 1:2
%     points = b(i).XEndPoints;
%     X(1,i) = points(1);
%     X(2,i) = points(2);
%     X(3,i) = points(3);
%     
% end
% 
% set(gca,'fontsize',22); 
% set(gca,'xticklabel', {'Change','Hold Vertical','Hold Horizontal'})
% xlabel("Instruction")
% ylabel('Vertical saccade bias per second')
% [a b c d] = legend({%'Other Percep',
%     'Vertical Percept','Horizontal Percept'})
% SEMs = [nanstd(dif_112)/sqrt(z) nanstd(dif_113)/sqrt(z);
%     nanstd(dif_212)/sqrt(z) nanstd(dif_213)/sqrt(z);
%     nanstd(dif_312)/sqrt(z) nanstd(dif_313)/sqrt(z);
%     ];
% title('Difference between vertical and horizontal saccade rates')
% %set(gcf,'color',[color_white]); %set fig color to white
% %set(gca,'color',[color_white]); %set axis color to white
% hold on
% errorbar(X, data, SEMs,'k','linestyle','none');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
%ANOVA

%dependent varialbe

%y = sums including neither percept
y = [sum_110'; 
    sum_112'; 
    sum_113';
    sum_210'; 
    sum_212'; 
    sum_213';
    sum_310'; 
    sum_312'; 
    sum_313';];

%y_b = sums exluding neither percept
y_b = [ sum_112'; 
    sum_113'; 
    sum_212'; 
    sum_213'; 
    sum_312'; 
    sum_313';];

%y2 = differences including neither percept
y2 = [dif_110'; 
    dif_112'; 
    dif_113';
    dif_210'; 
    dif_212'; 
    dif_213';
    dif_310'; 
    dif_312'; 
    dif_313';];

%y2_b = differences excluding neither percept
y2_b = [ dif_112'; 
    dif_113'; 
    dif_212'; 
    dif_213'; 
    dif_312'; 
    dif_313';];

%DV, instruction, perception,participant
%just place different y's in :)
X = [y2 repelem([1:3],z*3)' repmat(repelem([1:3],z),1,3)' repmat(1:z,1,9)'];
X_b = [y_b repelem([1:3],z*2)' repmat(repelem([1:2],z),1,3)' repmat(1:z,1,6)'];

%RMAOV2(X);
RMAOV2(X_b)
% 
% 
% %[p,tbl,stats, terms] = anovan(y,X,'model','interaction','varnames',{'participant','instruction','perception'})
% 
% %[p,tbl,stats, terms] = anovan(y2,X,'model','interaction','varnames',{'participant','instruction','perception'})