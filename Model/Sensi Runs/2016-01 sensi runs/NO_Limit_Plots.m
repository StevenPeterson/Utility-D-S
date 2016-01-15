function NO_Limit_Plots

close all, clear, clc

%-------------------------------------------------------------------

check_DS            = 0;
single_sensi_effect = 0;    % plot percent change in 2050 output parameters due to single sensitivity variable

plot_all         = 0; % 1 == plot the difference of 2050 value minus 2015 value for all 2048  cases for each city and business model
plot_with_limit  = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each CITY with subplots for each
                      %  BUSINESS MODEL
plot_with_limit2 = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each BUSINESS MODEL with subplots for each
                      %  CITY                     
                     
plot_base_case   = 1; % 1 == plot run 1 for 9 models (3 cities X 3 business models)
plot_2050        = 0; % 1 == plot 2050 values
plot_multi_year_bar = 0;

plot_percentage  = 0; % 1 == plot percentage changes in reg cust, PV cust, retail price NOT FINISHED
plot_single      = 0; % 1 == plot indivual case (set below)
save_figures     = 1; % save plots as PDFs



%-------------------------------------------------------------------        

    FontSize_axis  = 22;  
    FontSize_label = 24; 
    FontSize_legend= 22;
    yr = 2015:1:2050; % year vector
    
%% ------------------------------------------------------------- Plot colors
% Distinguisable X11 Colors organized by color:
    Red         = [1.0000         0         0];
    DarkRed     = [0.5430         0         0];
    DeepPink    = [1.0000    0.0781    0.5742];
    DarkOrange  = [1.0000    0.5469         0];
    Gold        = [1.0000    0.8398         0];
    Chocolate   = [0.8203    0.4102    0.1172];
    Green       = [0    0.5000              0];
    DarkGreen   = [0    0.3906              0];
    Olive       = [0.5000    0.5000         0];
    Blue        = [0         0         1.0000];
    DodgerBlue  = [0.1172    0.5625    1.0000];
    RoyalBlue   = [0.2539    0.4102    0.8789];
    BlueViolet  = [0.5391    0.1680    0.8828];
    DarkMagenta = [0.5430         0    0.5430];
    Indigo      = [0.2930         0    0.5078];
    DimGray     = [0.4102    0.4102    0.4102];
    Black       = [0         0         0];
%-------------------------------------------------------------------


%% import data

            addpath ./LA/DemandCharge
            LA_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            LA_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            LA_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            LA_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./LA/DemandCharge  % remove path
            
            addpath ./LA/NetMeter
            LA_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            LA_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            LA_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            LA_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./LA/NetMeter  % remove path
            
            addpath ./LA/WholesaleComp
            LA_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            LA_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            LA_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            LA_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./LA/WholesaleComp  % remove path
            
            addpath ./Boulder/DemandCharge
            BO_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            BO_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            BO_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            BO_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./Boulder/DemandCharge% remove path
            
            addpath ./Boulder/NetMeter
            BO_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            BO_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            BO_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            BO_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./Boulder/NetMeter  % remove path
            
            addpath ./Boulder/WholesaleComp
            BO_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            BO_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            BO_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            BO_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./Boulder/WholesaleComp  % remove path
            
            addpath ./Sydney/DemandCharge
            SY_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            SY_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            SY_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            SY_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./Sydney/DemandCharge% remove path
            
            addpath ./Sydney/NetMeter
            SY_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            SY_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            SY_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            SY_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./Sydney/NetMeter  % remove path
            
            addpath ./Sydney/WholesaleComp
            SY_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            SY_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            SY_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            SY_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
            rmpath ./Sydney/WholesaleComp  % remove path

            x = 1:size(LA_DC_rc,1); % plotting vector


%% Death Spiral cases

if check_DS == 1
    
    %% cases with NO limit on PV households
            [r c] = find(LA_NM_de(1025:2048,:) > (LA_NM_rc(1025:2048,:) + LA_NM_pv(1025:2048,:)));
            length(r); % 130  <-- number of cases
            [r c] = find(LA_DC_de(1025:2048,:) > (LA_DC_rc(1025:2048,:) + LA_DC_pv(1025:2048,:)));
            length(r); % 9785
            [r c] = find(LA_WC_de(1025:2048,:) > (LA_WC_rc(1025:2048,:) + LA_WC_pv(1025:2048,:)));
            length(r); % 5477

            [r c] = find(BO_NM_de(1025:2048,:) > (BO_NM_rc(1025:2048,:) + BO_NM_pv(1025:2048,:)));
            length(r); % 0
            [r c] = find(BO_DC_de(1025:2048,:) > (BO_DC_rc(1025:2048,:) + BO_DC_pv(1025:2048,:)));
            length(r); % 10160
            [r c] = find(BO_WC_de(1025:2048,:) > (BO_WC_rc(1025:2048,:) + BO_WC_pv(1025:2048,:)));
            length(r); % 6217

            [r c] = find(SY_NM_de(1025:2048,:) > (SY_NM_rc(1025:2048,:) + SY_NM_pv(1025:2048,:)));
            length(r); % 0
            [r c] = find(SY_DC_de(1025:2048,:) > (SY_DC_rc(1025:2048,:) + SY_DC_pv(1025:2048,:)));
            length(r); % 6622
            [r c] = find(SY_WC_de(1025:2048,:) > (SY_WC_rc(1025:2048,:) + SY_WC_pv(1025:2048,:)));
            length(r); % 3734
    % order of DS from least likely to most likely: NM, WC, DC; Sy, LA, Bo
    
    % randomly selected case 1135 for comparison in paper
    
        %% check of cases with limit of PV households
            find(LA_NM_de(1:1024,:) > (LA_NM_rc(1:1024,:) + LA_NM_pv(1:1024,:)));
            find(LA_DC_de(1:1024,:) > (LA_DC_rc(1:1024,:) + LA_DC_pv(1:1024,:)));
            find(LA_WC_de(1:1024,:) > (LA_WC_rc(1:1024,:) + LA_WC_pv(1:1024,:)));

            find(BO_NM_de(1:1024,:) > (BO_NM_rc(1:1024,:) + BO_NM_pv(1:1024,:)));
            [r c] = find(BO_DC_de(1:1024,:) > (BO_DC_rc(1:1024,:) + BO_DC_pv(1:1024,:)));
            find(BO_WC_de(1:1024,:) > (BO_WC_rc(1:1024,:) + BO_WC_pv(1:1024,:)));

            find(SY_NM_de(1:1024,:) > (SY_NM_rc(1:1024,:) + SY_NM_pv(1:1024,:)));
            find(SY_DC_de(1:1024,:) > (SY_DC_rc(1:1024,:) + SY_DC_pv(1:1024,:)));
            find(SY_WC_de(1:1024,:) > (SY_WC_rc(1:1024,:) + SY_WC_pv(1:1024,:)));

            % Boulder Demand Charge has 48 DS cases with limit on
        BDC_DS_cases = [
            45
            46
            47
            48
            78
            80
           101
           102
           103
           104
           109
           110
           111
           112
           127
           128
           237
           238
           239
           240
           301
           302
           303
           304
           334
           336
           357
           358
           359
           360
           365
           366
           367
           368
           383
           384
           429
           430
           431
           432
           485
           486
           487
           488
           493
           494
           495
           496
        ];
        junk = find(SY_WC_de(1025:2048,:) > (SY_WC_rc(1025:2048,:) + SY_WC_pv(1025:2048,:)));
        length(junk);

        i = 1;
        for i=1:length(BDC_DS_cases)
            [val(i,:),TXT(i,:),RAW(i,:)]=xlsread('sensi_runs_v2.xlsx', 'DemandCharge', ['A', num2str(BDC_DS_cases(i)+1),':','L',num2str(BDC_DS_cases(i)+1)]);
        end
        find(val(:,1) ~= 5000 & val(:,2) ~= 5000);  % 38/48 have both incentive
        find(val(:,3) ~= 5 & val(:,4) ~= 5);        % All 48 cases have 5x adoption rates (Imitation and Innovation)
        find(val(:,5) ~= .5);                       % 44/48  cases have efficiency improvement = 0.5
        find(val(:,6) ~= .05 & val(:,7) ~= .05);    % 44/48  cases have higher utility costs
        find(val(:,8) ~= 1);                        % 32/48  cases have 1% debt interest rate
        find(val(:,9) ~= .1);                       % equity fraction is split 20/28  0.1/0.8
        find(val(:,10) ~= 1);                       % All 48 cases have RoR = 1%

end % check DS

%% effect of each variable

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: the sensi runs were set up such that the low values of each
% variable are considered the default or 'off' value as defined originally
% in my analyis. Unfortunately, some of the low values are actually the
% sensitivity values and not the base values. Specifically, 
% debt interest rate (10, 1)
% Equity fraction    (0.8, 0.1)
% RoR                (10, 1)
% all have their higher value as the base value. Therefore, I had to switch
% all of the off/on values for these three paramters, etc...
% 
if single_sensi_effect == 1
    I = 1; % for storing means in plotting function below
    
    % PV Incentive
    variable = 'PV Incentive';
    
        on = 1026:2:2048;
        off = 1025:2:2047;
    
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % Battery Incentive
    clear on off 
    variable = 'Battery Incentive';
    
        n=1;
        j = 4;
        for i = 1025:j:2048
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')

    
    % Innovation Scale Factor
    clear on off 
    variable = 'Innovation Scale Factor';

        n=1;
        j = 8;
        for i = 1025:j:2048
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % Imitation Scale Factor
    clear on off
    variable = 'Imitation Scale Factor';
    
        n=1;
        j = 16;
        for i = 1025:j:2048
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % efficiency_improvement_of_reg_customers_as_%_per_year
    clear on off
    variable = 'efficiency improvement';
    
        n=1;
        j = 32;
        for i = 1025:j:2048
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % util_fixed_cost_growth_rate_%_per_year
    clear on off
    variable = 'fixed cost growth rate';
    
        n=1;
        j = 64;
        for i = 1025:j:2048
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % wholesale_price_growth_rate_%_per_year
    clear on off
    variable = 'wholesale price growth rate';
    
        n=1;
        j = 128;
        for i = 1025:j:2048
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % debt_interest_rate_as_%
    clear on off
    variable = 'debt interest rate';
    
        n=1;
        j = 256;
        for i = 1025:j:2048
            on(n:n+(j/2-1)) = i      :i+(j/2-1);  
            off(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % Equity_Fraction
    clear on off
    variable = 'Equity Fraction';
    
        n=1;
        j = 512;
        for i = 1025:j:2048
            on(n:n+(j/2-1)) = i      :i+(j/2-1);  
            off(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')


    % Req'd_Rate_of_Return_as_%
    clear on off
    variable = 'Reqd Rate of Return';
    
        n=1;
        j = 1024;
        for i = 1025:j:2048
            on(n:n+(j/2-1)) = i      :i+(j/2-1);  
            off(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,['NO_Limit_',variable],'pdf')
         
         save('MEANS', 'MEANS')

end % single_sensi_effect

%% Plot individual cases
  if plot_single == 1
      
        model = 'Demand Charge';
%         model = 'Net Meter';
%         model = 'WholesaleComp';


%      city = 'LA';
%         addpath ./LA/WholesaleComp
%         addpath ./LA/NetMeter
%         addpath ./LA/DemandCharge

    city = 'Boulder';
%         addpath ./Boulder/NetMeter
        addpath ./Boulder/DemandCharge
%         addpath ./Boulder/WholesaleComp

%      city = 'Sydney';
%         addpath ./Sydney/DemandCharge
%         addpath ./Sydney/NetMeter
%         addpath ./Sydney/WholesaleComp


        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
        
  
%         for i = 740:(744-740):744
%             close all
            i = 1137
            mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
            n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values
            name = sprintf('%s_%s_case %d', city, model, i);

            nested_plot_base_case
%             pause
%         end
  end

%% sub functions
    function plot_single_effect
        figure, grid on % plot of 2050 values, with and without sensitivity variable changed
        set(gcf,'Position', [-1637 298 1607 920])


        city = 'LA';
        model = 'Net Meter';
            rc = LA_NM_rc; rp = LA_NM_rp; pv = LA_NM_pv; de = LA_NM_de;
            subplot(3,3,1)
            plot_on_off
%             legend([hrc hpv hde hrp],'reg','pv','def','ret price', 'Location','SouthWest')

        model = 'Demand Charge';
            rc = LA_DC_rc; rp = LA_DC_rp; pv = LA_DC_pv; de = LA_DC_de;
            subplot(3,3,2)
            plot_on_off

        model = 'Wholesale Comp';
            rc = LA_WC_rc; rp = LA_WC_rp; pv = LA_WC_pv; de = LA_WC_de;
            subplot(3,3,3)
            plot_on_off


        city = 'Boulder';
        model = 'Net Meter';
            rc = BO_NM_rc; rp = BO_NM_rp; pv = BO_NM_pv; de = BO_NM_de;
            subplot(3,3,4)
            plot_on_off

        model = 'Demand Charge';
            rc = BO_DC_rc; rp = BO_DC_rp; pv = BO_DC_pv; de = BO_DC_de;
            subplot(3,3,5)
            plot_on_off

        model = 'Wholesale Comp';
            rc = BO_WC_rc; rp = BO_WC_rp; pv = BO_WC_pv; de = BO_WC_de;
            subplot(3,3,6)
            plot_on_off
            
            
        city = 'Sydney';
        model = 'Net Meter';
           rc = SY_NM_rc; rp = SY_NM_rp; pv = SY_NM_pv; de = SY_NM_de;
            subplot(3,3,7)
            plot_on_off
        
        model = 'Demand Charge';
           rc = SY_DC_rc; rp = SY_DC_rp; pv = SY_DC_pv; de = SY_DC_de;
            subplot(3,3,8)
            plot_on_off

        model = 'Wholesale Comp';
            rc = SY_WC_rc; rp = SY_WC_rp; pv = SY_WC_pv; de = SY_WC_de;
        
            subplot(3,3,9)
            plot_on_off
        
        function plot_on_off
            clear Y, Y = 100*( rc(on,end) -  rc(off,end)) ./  rc(off,end);
            hrc = plot(Y,'Blue');   MEANS(I,1) = mean(Y);
            hold on
            clear Y, Y = 100*( pv(on,end) -  pv(off,end)) ./  pv(off,end);
            hpv = plot(Y,'Green');  MEANS(I,2) = mean(Y);
            clear Y, Y = 100*( de(on,end) -  de(off,end)) ./  de(off,end);
            hde = plot(Y,'Red');    MEANS(I,3) = mean(Y);
            clear Y, Y = 100*( rp(on,end) -  rp(off,end)) ./  rp(off,end);
            hrp = plot(Y,'Black');  MEANS(I,4) = mean(Y);
            I = I+1;
            
            xlim([0,512])
            name = sprintf('%s %s %s', city, model, variable);
            title(name,'FontName','Times','FontSize',FontSize_label)
            ylabel('% change','FontName','Times','FontSize',FontSize_label)
        end
    end 

    function nested_plot_base_case
        
            % ran Stella with higher threshold for drain slowing function
            % (30,000) to produce smoother curves. Here the Stella output
            % is imported for the paper figure. Need to increase threshold
            % in all Boulder cases a publishing Stella model.
            if strcmp(city,'Boulder') && strcmp(model,'Demand Charge') && i == 1137
                
                rp(i,:) = xlsread('Bo_DC_case1137_output.xlsx', '1','B1:AK1'); % retail price
                rc(i,:) = xlsread('Bo_DC_case1137_output.xlsx', '1','B4:AK4'); % reg. customers
                pv(i,:) = xlsread('Bo_DC_case1137_output.xlsx', '1','B2:AK2'); % pv customers
                de(i,:) = xlsread('Bo_DC_case1137_output.xlsx', '1','B3:AK3'); % defectors
            end


            figure, hold on, box on, grid on
            
            N = rc(i,1) + pv(i,1) + de(i,1); % total households in 2015

            [ax,Hrc,Hrp] = plotyy(yr, rc(i,:)/N, yr, rp(i,:));
            set(Hrc,'Color',Blue,'marker','x','linewidth',2)
            set(Hrp,'Color',DimGray,'linewidth',2)
            Hpv = plot(ax(1), yr, pv(i,:)/N,'g--');
            set(Hpv,'Color',Green,'linewidth',2)
            Hde = plot(ax(1), yr, de(i,:)/N,'m.-');
            set(Hde,'Color',DarkMagenta,'linewidth',2)
            mx = max([ rc(i,:)/N, de(i,:)/N, pv(i,:)/N ]);
            
%             HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','Best');
%             set(HL,'FontSize',16,'FontWeight','bold')
            
            ylabel(ax(1),'Normalized households','FontName','Times','FontSize',FontSize_label) % households vert axis
            ylim(ax(1), [0 1]) % households vert axis
            set(ax(1), 'YTick', [0 .2 .4 .6 .8 1.0 1.2  1.6  2.0], 'YTickLabel', [0 .2 .4 .6 .8 1.0 1.2  1.6  2.0]) % households vert axis
            
            ylim(ax(2), [0 2]) % retail price vert axis
            set(ax(2),'YTick', [0 .4  .8  1.2  1.6  2.0],'YTickLabel', [0 .4  .8  1.2  1.6  2.0]) % retail price vert axis

%             title(name,'FontName','Times','FontSize',FontSize_label)
            xlabel('Year','FontName','Times','FontSize',FontSize_label)
            ylabel(ax(2),'Retail price (2015 nominal $/kWh)' ,'FontName','Times','FontSize',FontSize_label,'Color',DimGray) % retail price vert axis
            set(ax(2),'FontName','Times','FontSize',FontSize_axis,'ycolor',DimGray) % retail price vert axis
            set(ax(1),'FontName','Times','FontSize',FontSize_axis,'ycolor','k') % households vert axis
        
         
        if save_figures == 1
            if i == 641
                saveastight(gcf,['base_case_',city,'_',model,'_Legend_NOtitle'],'pdf')
            elseif i == 1665
                saveastight(gcf,[city,' ',model,' base case NO LIMIT'],'pdf')
            else
                saveastight(gcf,[city,'_',model,'_case_',num2str(i)],'pdf')
            end
        end
        
    end % nested_plot_base_case
end % parent function