% this script creates a matrix m1 that averages the effects of sensitivity
% parameters on output variables across cities and pricing structures for
% input in to an excel sheet for analysis. 

% Must create MEANS in Plot_SensiRuns_1601.m as an input
clear

load(MEANS.mat)
k = 1; n =0;
    for j = 1:4:40  % printing columns
        for i = 1:3
            m1(i,j:j+3) = mean(MEANS(k:k+2,:),1); % city means
            m1(i+3,j:j+3) = mean( [MEANS(i+n,:) ; MEANS(i+3+n,:) ; MEANS(i+6+n,:)], 1); % business model means
            k = k+3;
        end
        n = n+9; % business model index
    end