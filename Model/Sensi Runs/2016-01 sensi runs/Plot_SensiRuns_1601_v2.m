% Script to import Death Spiral sensitivity analysis results and plot
% modified original with appended name "_1601" for 2016 January

% Switches are contained in 'RunCombos.xlsx' with column containing 'Run#'
%     where # is the run number. Each following column contains:
% 
%    Use limit on ratio of PV to total households: 1, 0
%    wholesale price growth rate % per year:       0.01, 0.05
%    InnovationScaleFactor:                        1, 5
%    Req'd Rate of Return as %:                    1, 10
%    ImitationScaleFactor:                         1, 5
%    debt_interest_rate_as_%:                      5, 1
%    Battery_incentive:                            0, 5000
%    util_fixed_cost_growth_rate_%_per_year        0.01, 0.05
%    PV_incentive:                                 0, 5000



% Results are in CSV files, 4 each for 9 cases (3 cities with 3 different
% business models). The 4 results file are named:
%         1_RetailPrice.csv
%         2_RegularCust.csv
%         3_Cust_With_PV.csv
%         4_Defector.csv
%   with rows for each of the 512 cases, columns for each year from 2015 to
%   2050.
%-------------------------------------------------------------------
function Plot_SensiRuns_1601

close all, clear, clc

% [val,TXT,RAW]=xlsread('sensi_runs_v2.xlsx');  % val = sensitivity variable values
% var = TXT(1,2:10);                        % var = sensitivity variable names

%-------------------------------------------------------------------

curvature_check     = 0;    % check for negative curvature of total grid customers vs time
single_sensi_effect = 0;    % plot percent change in 2050 output parameters due to single sensitivity variable

plot_all         = 0; % 1 == plot the difference of 2050 value minus 2015 value for all 2048  cases for each city and business model
plot_with_limit  = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each CITY with subplots for each
                      %  BUSINESS MODEL
plot_with_limit2 = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each BUSINESS MODEL with subplots for each
                      %  CITY                     
                     
plot_base_case   = 0; % 1 == plot run 1 for 9 models (3 cities X 3 business models)
    plot_base_bar = 1;

plot_2050        = 0; % 1 == plot 2050 values
plot_multi_year_bar = 0;

plot_percentage  = 0; % 1 == plot percentage changes in reg cust, PV cust, retail price NOT FINISHED

plot_single      = 1; % 1 == plot indivual case (set below)
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
            
            
            
%% Death Spiral criterion
if curvature_check == 1
% check for negative curvature (2nd derivative) of the total grid
% customers, which is the sum of regular customers and PV customers

% results show that even with a relatively small increase in defectors
% there is a negative curvature in the grid customers so the criterion is
% unsuccessful in the sense that it provides too many cases to analyze
% individually

        LA_DC = LA_DC_rc + LA_DC_pv;
        LA_NM = LA_NM_rc + LA_NM_pv;
        LA_WC = LA_WC_rc + LA_WC_pv;

        BO_DC = BO_DC_rc + BO_DC_pv;
        BO_NM = BO_NM_rc + BO_NM_pv;
        BO_WC = BO_WC_rc + BO_WC_pv;

        SY_DC = SY_DC_rc + SY_DC_pv;
        SY_NM = SY_NM_rc + SY_NM_pv;
        SY_WC = SY_WC_rc + SY_WC_pv;
        

        LA_DC_2nd = zeros(length(LA_DC),length(yr) - 3);
        LA_NM_2nd = zeros(length(LA_DC),length(yr) - 3);
        LA_WC_2nd = zeros(length(LA_DC),length(yr) - 3);

        BO_DC_2nd = zeros(length(LA_DC),length(yr) - 3);
        BO_NM_2nd = zeros(length(LA_DC),length(yr) - 3);
        BO_WC_2nd = zeros(length(LA_DC),length(yr) - 3);

        SY_DC_2nd = zeros(length(LA_DC),length(yr) - 3);
        SY_NM_2nd = zeros(length(LA_DC),length(yr) - 3);
        SY_WC_2nd = zeros(length(LA_DC),length(yr) - 3);
        
        n = 1;
        for i = 1:(length(yr) - 3)
            LA_DC_2nd(:,n) = ( LA_DC(:,i+2) - 2*LA_DC(:,i+1) + LA_DC(:,i) );
            LA_NM_2nd(:,n) = ( LA_NM(:,i+2) - 2*LA_NM(:,i+1) + LA_NM(:,i) );
            LA_WC_2nd(:,n) = ( LA_WC(:,i+2) - 2*LA_WC(:,i+1) + LA_WC(:,i) );
            
            BO_DC_2nd(:,n) = ( BO_DC(:,i+2) - 2*BO_DC(:,i+1) + BO_DC(:,i) );
            BO_NM_2nd(:,n) = ( BO_NM(:,i+2) - 2*BO_NM(:,i+1) + BO_NM(:,i) );
            BO_WC_2nd(:,n) = ( BO_WC(:,i+2) - 2*BO_WC(:,i+1) + BO_WC(:,i) );
            
            SY_DC_2nd(:,n) = ( SY_DC(:,i+2) - 2*SY_DC(:,i+1) + SY_DC(:,i) );
            SY_NM_2nd(:,n) = ( SY_NM(:,i+2) - 2*SY_NM(:,i+1) + SY_NM(:,i) );
            SY_WC_2nd(:,n) = ( SY_WC(:,i+2) - 2*SY_WC(:,i+1) + SY_WC(:,i) );
            n = n + 1;
        end
        
        threshold = 20;
        LA_DC_temp = sign(LA_DC_2nd) == -1; LA_DC_ds = sum(LA_DC_temp ,2);
        LA_DC_ds_cases = find(LA_DC_ds>threshold);
        LA_NM_temp = sign(LA_NM_2nd) == -1; LA_NM_ds = sum(LA_NM_temp ,2);
        LA_NM_ds_cases = find(LA_NM_ds>threshold);
        LA_WC_temp = sign(LA_WC_2nd) == -1; LA_WC_ds = sum(LA_WC_temp ,2);
        LA_WC_ds_cases = find(LA_WC_ds>threshold);
        
        BO_DC_temp = sign(BO_DC_2nd) == -1; BO_DC_ds = sum(BO_DC_temp ,2);
        BO_DC_ds_cases = find(BO_DC_ds>threshold);
        BO_NM_temp = sign(BO_NM_2nd) == -1; BO_NM_ds = sum(BO_NM_temp ,2);
        BO_NM_ds_cases = find(BO_NM_ds>threshold);
        BO_WC_temp = sign(BO_WC_2nd) == -1; BO_WC_ds = sum(BO_WC_temp ,2);
        BO_WC_ds_cases = find(BO_WC_ds>threshold);
        
        SY_DC_temp = sign(SY_DC_2nd) == -1; SY_DC_ds = sum(SY_DC_temp ,2);
        SY_DC_ds_cases = find(SY_DC_ds>threshold);
        SY_NM_temp = sign(SY_NM_2nd) == -1; SY_NM_ds = sum(SY_NM_temp ,2);
        SY_NM_ds_cases = find(SY_NM_ds>threshold);
        SY_WC_temp = sign(SY_WC_2nd) == -1; SY_WC_ds = sum(SY_WC_temp ,2);
        SY_WC_ds_cases = find(SY_WC_ds>threshold);
        
end % curvature_check

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
    
        on = 2:2:1024;
        off = 1:2:1023;
    
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % Battery Incentive
    clear on off 
    variable = 'Battery Incentive';
    
        n=1;
        j = 4;
        for i = 1:j:1024
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')

    
    % Innovation Scale Factor
    clear on off 
    variable = 'Innovation Scale Factor';

        n=1;
        j = 8;
        for i = 1:j:1024
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % Imitation Scale Factor
    clear on off
    variable = 'Imitation Scale Factor';
    
        n=1;
        j = 16;
        for i = 1:j:1024
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % efficiency_improvement_of_reg_customers_as_%_per_year
    clear on off
    variable = 'efficiency improvement';
    
        n=1;
        j = 32;
        for i = 1:j:1024
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % util_fixed_cost_growth_rate_%_per_year
    clear on off
    variable = 'fixed cost growth rate';
    
        n=1;
        j = 64;
        for i = 1:j:1024
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % wholesale_price_growth_rate_%_per_year
    clear on off
    variable = 'wholesale price growth rate';
    
        n=1;
        j = 128;
        for i = 1:j:1024
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % debt_interest_rate_as_%
    clear on off
    variable = 'debt interest rate';
    
        n=1;
        j = 256;
        for i = 1:j:1024
            on(n:n+(j/2-1)) = i      :i+(j/2-1);  
            off(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % Equity_Fraction
    clear on off
    variable = 'Equity Fraction';
    
        n=1;
        j = 512;
        for i = 1:j:1024
            off(n:n+(j/2-1)) = i      :i+(j/2-1);  
            on(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')


    % Req'd_Rate_of_Return_as_%
    clear on off
    variable = 'Reqd Rate of Return';
    
        n=1;
        j = 1024;
        for i = 1:j:1024
            on(n:n+(j/2-1)) = i      :i+(j/2-1);  
            off(n:n+(j/2-1))  = i+(j/2):i+(j-1)  ;  
            n = n+j/2;
        end
         plot_single_effect,          saveastight(gcf,[variable],'pdf')
         
         save('MEANS', 'MEANS')

end % single_sensi_effect




%% percent change in grid customers

LA_DC_delta = ( (LA_DC_rc(:,end) + LA_DC_pv(:,end)) - (LA_DC_rc(:,1) + LA_DC_pv(:,1)) ) / (LA_DC_rc(:,1) + LA_DC_pv(:,1));
% plot(x,LA_DC_delta)



%% Plot all -------------------------------------------------------------------
if plot_all == 1
    %% LA
    city = 'LA';
    %  DemandCharge
            model = 'Demand Charge';

            ax = subplot(3,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes

            
            hold on

            [ax,Hrc,Hrp] = plotyy(x, LA_DC_rc(:,end) - LA_DC_rc(:,1), x, LA_DC_rp(:,end) - LA_DC_rp(:,1));

            Hpv = plot(ax(1), x, LA_DC_pv(:,end) - LA_DC_pv(:,1),'r');
            Hde = plot(ax(1), x, LA_DC_de(:,end) - LA_DC_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(LA_DC_rc,1)])
            xlim(ax(2),[0, size(LA_DC_rc,1)])
            ylim(ax(1), [min(LA_DC_rc(:,end) - LA_DC_rc(:,1)) max(max( LA_DC_pv(:,end) - LA_DC_pv(:,1), LA_DC_de(:,end) - LA_DC_de(:,1) ))])
            HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            set(HL,'FontName','Times','FontSize',FontSize_legend)
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            set(ax,'pos',P)       % Recover the position.

    % NetMeter
            model = 'Net Meter';
            subplot(3,3,2);
    %         P  = get(ax,'pos');    % Get the position.
    %         delete(ax)              % Delete the subplot axes

            hold on

            [ax,Hrc,Hrp] = plotyy(x, LA_NM_rc(:,end) - LA_NM_rc(:,1), x, LA_NM_rp(:,end) - LA_NM_rp(:,1));

            Hpv = plot(ax(1), x, LA_NM_pv(:,end) - LA_NM_pv(:,1),'r');
            Hde = plot(ax(1), x, LA_NM_de(:,end) - LA_NM_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(LA_NM_rc,1)])
            xlim(ax(2),[0, size(LA_NM_rc,1)])
            ylim(ax(1), [min(LA_NM_rc(:,end) - LA_NM_rc(:,1)) max(max( LA_NM_pv(:,end) - LA_NM_pv(:,1), LA_NM_de(:,end) - LA_NM_de(:,1) ))])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail
    %         price', 'PV cust', 'defectors','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)


    % WholesaleComp
            model = 'WholesaleComp';


            subplot(3,3,3);

            hold on

            [ax,Hrc,Hrp] = plotyy(x, LA_WC_rc(:,end) - LA_WC_rc(:,1), x, LA_WC_rp(:,end) - LA_WC_rp(:,1));

            Hpv = plot(ax(1), x, LA_WC_pv(:,end) - LA_WC_pv(:,1),'r');
            Hde = plot(ax(1), x, LA_WC_de(:,end) - LA_WC_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(LA_WC_rc,1)])
            xlim(ax(2),[0, size(LA_WC_rc,1)])
            ylim(ax(1), [min(LA_WC_rc(:,end) - LA_WC_rc(:,1)) max(max( LA_WC_pv(:,end) - LA_WC_pv(:,1), LA_WC_de(:,end) - LA_WC_de(:,1) ))])
    %         HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)


    %% Boulder
    city = 'Boulder';
        % DemandCharge
            model = 'Demand Charge';


            ax = subplot(3,3,4);

            hold on

            [ax,Hrc,Hrp] = plotyy(x, BO_DC_rc(:,end) - BO_DC_rc(:,1), x, BO_DC_rp(:,end) - BO_DC_rp(:,1));

            Hpv = plot(ax(1), x, BO_DC_pv(:,end) - BO_DC_pv(:,1),'r');
            Hde = plot(ax(1), x, BO_DC_de(:,end) - BO_DC_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(BO_DC_rc,1)])
            xlim(ax(2),[0, size(BO_DC_rc,1)])
            ylim(ax(1), [min(BO_DC_rc(:,end) - BO_DC_rc(:,1)) max(max( BO_DC_pv(:,end) - BO_DC_pv(:,1), BO_DC_de(:,end) - BO_DC_de(:,1) ))])
            ylim(ax(2), [0 3])
    %         HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)


        % NetMeter
            model = 'Net Meter';
            subplot(3,3,5);

            hold on

            [ax,Hrc,Hrp] = plotyy(x, BO_NM_rc(:,end) - BO_NM_rc(:,1), x, BO_NM_rp(:,end) - BO_NM_rp(:,1));

            Hpv = plot(ax(1), x, BO_NM_pv(:,end) - BO_NM_pv(:,1),'r');
            Hde = plot(ax(1), x, BO_NM_de(:,end) - BO_NM_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(BO_NM_rc,1)])
            xlim(ax(2),[0, size(BO_NM_rc,1)])
            ylim(ax(1), [min(BO_NM_rc(:,end) - BO_NM_rc(:,1)) max(max( BO_NM_pv(:,end) - BO_NM_pv(:,1), BO_NM_de(:,end) - BO_NM_de(:,1) ))])
            HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)


        % WholesaleComp
            model = 'WholesaleComp';


            subplot(3,3,6);

            hold on

            [ax,Hrc,Hrp] = plotyy(x, BO_WC_rc(:,end) - BO_WC_rc(:,1), x, BO_WC_rp(:,end) - BO_WC_rp(:,1));

            Hpv = plot(ax(1), x, BO_WC_pv(:,end) - BO_WC_pv(:,1),'r');
            Hde = plot(ax(1), x, BO_WC_de(:,end) - BO_WC_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(BO_WC_rc,1)])
            xlim(ax(2),[0, size(BO_WC_rc,1)])
            ylim(ax(1), [min(BO_WC_rc(:,end) - BO_WC_rc(:,1)) max(max( BO_WC_pv(:,end) - BO_WC_pv(:,1), BO_WC_de(:,end) - BO_WC_de(:,1) ))])
%             HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

    %-------------------------------------------------------------------


    %% Sydney
    city = 'Sydney';
    %-------------------------------------------------------------------
        % DemandCharge
            model = 'Demand Charge';
            ax = subplot(3,3,7);
            hold on

            [ax,Hrc,Hrp] = plotyy(x, SY_DC_rc(:,end) - SY_DC_rc(:,1), x, SY_DC_rp(:,end) - SY_DC_rp(:,1));

            Hpv = plot(ax(1), x, SY_DC_pv(:,end) - SY_DC_pv(:,1),'r');
            Hde = plot(ax(1), x, SY_DC_de(:,end) - SY_DC_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(SY_DC_rc,1)])
            xlim(ax(2),[0, size(SY_DC_rc,1)])
            ylim(ax(1), [min(SY_DC_rc(:,end) - SY_DC_rc(:,1)) max(max( SY_DC_pv(:,end) - SY_DC_pv(:,1), SY_DC_de(:,end) - SY_DC_de(:,1) ))])
%             HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

        % NetMeter
            model = 'Net Meter';


            subplot(3,3,8);

            hold on

            [ax,Hrc,Hrp] = plotyy(x, SY_NM_rc(:,end) - SY_NM_rc(:,1), x, SY_NM_rp(:,end) - SY_NM_rp(:,1));

            Hpv = plot(ax(1), x, SY_NM_pv(:,end) - SY_NM_pv(:,1),'r');
            Hde = plot(ax(1), x, SY_NM_de(:,end) - SY_NM_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(SY_NM_rc,1)])
            xlim(ax(2),[0, size(SY_NM_rc,1)])
            ylim(ax(1), [min(SY_NM_rc(:,end) - SY_NM_rc(:,1)) max(max( SY_NM_pv(:,end) - SY_NM_pv(:,1), SY_NM_de(:,end) - SY_NM_de(:,1) ))])
%             HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

    %         set(ax,'pos',P)       % Recover the position.

        % WholesaleComp
            model = 'WholesaleComp';


            subplot(3,3,9);

            hold on

            [ax,Hrc,Hrp] = plotyy(x, SY_WC_rc(:,end) - SY_WC_rc(:,1), x, SY_WC_rp(:,end) - SY_WC_rp(:,1));

            Hpv = plot(ax(1), x, SY_WC_pv(:,end) - SY_WC_pv(:,1),'r');
            Hde = plot(ax(1), x, SY_WC_de(:,end) - SY_WC_de(:,1),'g--');
            set(Hrp,'color','k'), set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(SY_WC_rc,1)])
            xlim(ax(2),[0, size(SY_WC_rc,1)])
            ylim(ax(1), [min(SY_WC_rc(:,end) - SY_WC_rc(:,1)) max(max( SY_WC_pv(:,end) - SY_WC_pv(:,1), SY_WC_de(:,end) - SY_WC_de(:,1) ))])
%             HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

end % plot all

%% Plot with limit -------------------------------------------------------------------
if plot_with_limit == 1
    %% LA
    city = 'LA';
    %  DemandCharge
            model = 'Demand Charge';
            addpath ./LA/DemandCharge
            
            HF = figure; set(gcf,'Position', [17 19 1384 779])
            set(HF,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            
            HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            set(ax,'pos',P)       % Recover the position.
            rmpath ./LA/DemandCharge% remove path


    %  NetMeter
            model = 'Net Meter';
            addpath ./LA/NetMeter
            subplot(1,3,2);
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors

            plot_cases

            rmpath ./LA/NetMeter  % remove path

    %  WholesaleComp
            model = 'WholesaleComp';
            addpath ./LA/WholesaleComp
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors

            plot_cases

            rmpath ./LA/WholesaleComp  % remove path


    %% Boulder
    city = 'Boulder';
    % DemandCharge
            model = 'Demand Charge';
            addpath ./Boulder/DemandCharge
            
            HF = figure; set(gcf,'Position', [17 19 1384 779])
            set(HF,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases

            rmpath ./Boulder/DemandCharge% remove path

    % NetMeter
            model = 'Net Meter';
            addpath ./Boulder/NetMeter
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors

            plot_cases

            rmpath ./Boulder/NetMeter  % remove path

    % WholesaleComp
            model = 'WholesaleComp';
            addpath ./Boulder/WholesaleComp
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors

            plot_cases

            rmpath ./Boulder/WholesaleComp  % remove path


    %% Sydney
    city = 'Sydney';
    
    % DemandCharge
            model = 'Demand Charge';
            addpath ./Sydney/DemandCharge
            
            HF = figure; set(gcf,'Position', [17 19 1384 779])
            set(HF,'Name','Delta 2050 - 2015 values')
            subplot(1,3,1);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
          
            plot_cases

            rmpath ./Sydney/DemandCharge% remove path
            
    % NetMeter
            model = 'Net Meter';
            addpath ./Sydney/NetMeter
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors

            plot_cases

            rmpath ./Sydney/NetMeter  % remove path
            
            

    % WholesaleComp
            model = 'WholesaleComp';
            addpath ./Sydney/WholesaleComp
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors

            plot_cases

            rmpath ./Sydney/WholesaleComp  % remove path

end % plot_with_limit

if plot_with_limit2 == 1
    
%  DemandCharge
    model = 'Demand Charge';

        city = 'LA';
            addpath ./LA/DemandCharge
            
            HF = figure; set(gcf,'Position', [17 19 1384 779])
            set(HF,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            
            HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            set(ax,'pos',P)       % Recover the position.
            rmpath ./LA/DemandCharge% remove path
            
        city = 'Boulder';
            addpath ./Boulder/DemandCharge
            
            ax = subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Boulder/DemandCharge% remove path

        city = 'Sydney';
            addpath ./Sydney/DemandCharge
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
          
            plot_cases
            rmpath ./Sydney/DemandCharge% remove path
            
%  NetMeter
    model = 'Net Meter';
        city = 'LA';
            addpath ./LA/NetMeter
            HF = figure; set(gcf,'Position', [17 19 1384 779])
            set(HF,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            subplot(1,3,1);
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./LA/NetMeter  % remove path
            
      city = 'Boulder';
            addpath ./Boulder/NetMeter
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Boulder/NetMeter  % remove path
            
       city = 'Sydney'
            addpath ./Sydney/NetMeter
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Sydney/NetMeter  % remove path
            
%  WholesaleComp
    model = 'WholesaleComp';
        city = 'LA';
            addpath ./LA/WholesaleComp
            HF = figure; set(gcf,'Position', [17 19 1384 779])
            set(HF,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            subplot(1,3,1);
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./LA/WholesaleComp % remove path
            
      city = 'Boulder';
            addpath ./Boulder/WholesaleComp
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Boulder/WholesaleComp  % remove path
            
       city = 'Sydney'
            addpath ./Sydney/WholesaleComp
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK1025'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK1025'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK1025'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK1025'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Sydney/WholesaleComp  % remove path
            
end % plot_with_limit2

%% plot_base_case  -----------------------------------------------------------------
if plot_base_case == 1
          i = 641; % run number for base case values
%        i = 1665; % run number for base case without limit on rental homes
       
    if plot_base_bar == 0


    city = 'LA';
        model = 'Net_Meter';
        mod_title = 'Net Meter';
            rc = LA_NM_rc;
            rp = LA_NM_rp;
            pv = LA_NM_pv;
            de = LA_NM_de;

            mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
            n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values

            nested_plot_base_case

        model = 'Demand_Charge';
        mod_title = 'Demand_Charge';
            rc = LA_DC_rc;
            rp = LA_DC_rp;
            pv = LA_DC_pv;
            de = LA_DC_de;

            nested_plot_base_case

        model = 'Wholesale_Comp';
        mod_title = 'Wholesale_Comp';
            rc = LA_WC_rc;
            rp = LA_WC_rp;
            pv = LA_WC_pv;
            de = LA_WC_de;

            nested_plot_base_case


    city = 'Boulder';

        model = 'Net_Meter';
        mod_title = 'Net_Meter';
            rc = BO_NM_rc;
            rp = BO_NM_rp;
            pv = BO_NM_pv;
            de = BO_NM_de;

            mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
            n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values

            nested_plot_base_case


        model = 'Demand_Charge';
        mod_title = 'Demand_Charge';
            rc = BO_DC_rc;
            rp = BO_DC_rp;
            pv = BO_DC_pv;
            de = BO_DC_de;

            nested_plot_base_case


        model = 'Wholesale_Comp';
        mod_title = 'Wholesale_Comp';
            rc = BO_WC_rc;
            rp = BO_WC_rp;
            pv = BO_WC_pv;
            de = BO_WC_de;

            nested_plot_base_case

    city = 'Sydney';

        model = 'Wholesale_Comp';
        mod_title = 'Wholesale_Comp';
            rc = SY_WC_rc;
            rp = SY_WC_rp;
            pv = SY_WC_pv;
            de = SY_WC_de;

            mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
            n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values

            nested_plot_base_case

        model = 'Net_Meter';
        mod_title = 'Net_Meter';
            rc = SY_NM_rc;
            rp = SY_NM_rp;
            pv = SY_NM_pv;
            de = SY_NM_de;

            nested_plot_base_case


        model = 'Demand_Charge';
        mod_title = 'Demand_Charge';
            rc = SY_DC_rc;
            rp = SY_DC_rp;
            pv = SY_DC_pv;
            de = SY_DC_de;

            nested_plot_base_case
            
            
            
            
    else % plot_base_bar
        
            % Demand Charge
                subplot(3,1,1)
                N_sy = SY_DC_rc(i,end) + SY_DC_pv(i,end) + SY_DC_de(i,end);
                N_bo = BO_DC_rc(i,end) + BO_DC_pv(i,end) + BO_DC_de(i,end);
                N_la = LA_DC_rc(i,end) + LA_DC_pv(i,end) + LA_DC_de(i,end);
                clear Y, Y = [SY_DC_rc(i,end)/N_sy SY_DC_pv(i,end)/N_sy SY_DC_de(i,end)/N_sy;...
                              BO_DC_rc(i,end)/N_bo BO_DC_pv(i,end)/N_bo BO_DC_de(i,end)/N_bo;...
                              LA_DC_rc(i,end)/N_la LA_DC_pv(i,end)/N_la LA_DC_de(i,end)/N_la];
                bar_fractions
                title('Demand Charge','FontName','Times','FontSize',FontSize_label)
                set(gca,'XTickLabel', [])
            % Wholesale Comp
                subplot(3,1,2)
                N_sy = SY_WC_rc(i,end) + SY_WC_pv(i,end) + SY_WC_de(i,end);
                N_bo = BO_WC_rc(i,end) + BO_WC_pv(i,end) + BO_WC_de(i,end);
                N_la = LA_WC_rc(i,end) + LA_WC_pv(i,end) + LA_WC_de(i,end);
                clear Y, Y = [SY_WC_rc(i,end)/N_sy SY_WC_pv(i,end)/N_sy SY_WC_de(i,end)/N_sy;...
                              BO_WC_rc(i,end)/N_bo BO_WC_pv(i,end)/N_bo BO_WC_de(i,end)/N_bo;...
                              LA_WC_rc(i,end)/N_la LA_WC_pv(i,end)/N_la LA_WC_de(i,end)/N_la];
                bar_fractions
                title('Wholesale Compensation','FontName','Times','FontSize',FontSize_label)
                set(gca,'XTickLabel', [])
            % Net Meter
                subplot(3,1,3)
                N_sy = SY_NM_rc(i,end) + SY_NM_pv(i,end) + SY_NM_de(i,end);
                N_bo = BO_NM_rc(i,end) + BO_NM_pv(i,end) + BO_NM_de(i,end);
                N_la = LA_NM_rc(i,end) + LA_NM_pv(i,end) + LA_NM_de(i,end);
                clear Y, Y = [SY_NM_rc(i,end)/N_sy SY_NM_pv(i,end)/N_sy SY_NM_de(i,end)/N_sy;...
                              BO_NM_rc(i,end)/N_bo BO_NM_pv(i,end)/N_bo BO_NM_de(i,end)/N_bo;...
                              LA_NM_rc(i,end)/N_la LA_NM_pv(i,end)/N_la LA_NM_de(i,end)/N_la];
                bar_fractions                
                title('Net Meter','FontName','Times','FontSize',FontSize_label)
                set(gca,'XTickLabel',{'Sydney', 'Boulder', 'LA'},'FontName','Times','FontSize',FontSize_axis-5)
                set(gcf,'Position', [440 57 834 741])
                i
                saveastight(gcf,['bar_2050_case',num2str(i)],'pdf')

            

        
        
    end
        
end

%% plot_2050 -----------------------------------------------------------------
if plot_2050 == 1
    %% new 2050 bar plots    

    % LA
        city = 'LA';
        % NetMeter
            model = 'Net Meter';
            HF = figure; grid on, set(HF,'Name','LA 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            subplot(3,1,1)
            clear Y, Y = [LA_NM_rc(:,end) LA_NM_pv(:,end) LA_NM_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)    
        %  DemandCharge
            model = 'Demand Charge';    
            subplot(3,1,2)
            clear Y, Y = [LA_DC_rc(:,end) LA_DC_pv(:,end) LA_DC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
        % WholesaleComp
            model = 'WholesaleComp';        
            subplot(3,1,3)
            clear Y, Y = [LA_WC_rc(:,end) LA_WC_pv(:,end) LA_WC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 

    % BOULDER
        city = 'Boulder';
        % NetMeter
            model = 'Net Meter';
            HF = figure; grid on, set(HF,'Name','Boulder 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            subplot(3,1,1)
            clear Y, Y = [BO_NM_rc(:,end) BO_NM_pv(:,end) BO_NM_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
        %  DemandCharge
            model = 'Demand Charge';  
            subplot(3,1,2)
            clear Y, Y = [BO_DC_rc(:,end) BO_DC_pv(:,end) BO_DC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
        % WholesaleComp
            model = 'WholesaleComp'; 
            subplot(3,1,3)
            clear Y, Y = [BO_WC_rc(:,end) BO_WC_pv(:,end) BO_WC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
        
    % Sydney
        city = 'Sydney';
        % NetMeter
            model = 'Net Meter';
            HF = figure; grid on, set(HF,'Name','Sydney 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            subplot(3,1,1)
            clear Y, Y = [SY_NM_rc(:,end) SY_NM_pv(:,end) SY_NM_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
        %  DemandCharge
            model = 'Demand Charge';  
            subplot(3,1,2)
            clear Y, Y = [SY_DC_rc(:,end) SY_DC_pv(:,end) SY_DC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
        % WholesaleComp
            model = 'WholesaleComp'; 
            subplot(3,1,3)
            clear Y, Y = [SY_WC_rc(:,end) SY_WC_pv(:,end) SY_WC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 

    % Net Meter
    model = 'Net Meter';
            city = 'LA';
            HF = figure; grid on, set(HF,'Name','Net Meter 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            subplot(3,1,1)
            clear Y, Y = [LA_NM_rc(:,end) LA_NM_pv(:,end) LA_NM_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)  
            
            city = 'Boulder';
            subplot(3,1,2)
            clear Y, Y = [BO_NM_rc(:,end) BO_NM_pv(:,end) BO_NM_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            city = 'Sydney';
            subplot(3,1,3)
            clear Y, Y = [SY_NM_rc(:,end) SY_NM_pv(:,end) SY_NM_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
    % Demand Charge
    model = 'Demand Charge'; 
            city = 'LA';
            HF = figure; grid on, set(HF,'Name','Demand Charge 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            subplot(3,1,1)
            clear Y, Y = [LA_DC_rc(:,end) LA_DC_pv(:,end) LA_DC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            city = 'Boulder';
            subplot(3,1,2)
            clear Y, Y = [BO_DC_rc(:,end) BO_DC_pv(:,end) BO_DC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            city = 'Sydney';
            subplot(3,1,3)
            clear Y, Y = [SY_DC_rc(:,end) SY_DC_pv(:,end) SY_DC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
    
    % Wholesale Comp
    model = 'WholesaleComp'; 
            city = 'LA';
            HF = figure; grid on, set(HF,'Name','WholesaleComp 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            subplot(3,1,1)
            clear Y, Y = [LA_WC_rc(:,end) LA_WC_pv(:,end) LA_WC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            city = 'Boulder';
            subplot(3,1,2)
            clear Y, Y = [BO_WC_rc(:,end) BO_WC_pv(:,end) BO_WC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            city = 'Sydney';
            subplot(3,1,3)
            clear Y, Y = [SY_WC_rc(:,end) SY_WC_pv(:,end) SY_WC_de(:,end);];
            bar(x,Y,'stacked')
            xlim([0,length(x)])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label) 
    
    
    %% old 2050 plots
%     HF = figure;
%     set(HF,'Name','2050 values')
%     hold on
% 
%     % LA
%     city = 'LA';
%         ax = subplot(3,4,1);
%             var = 'retail price';
%             plot(x(1:1024), LA_DC_rp(1:1024,end), x(1:1024), LA_NM_rp(1:1024, end),x(1:1024), LA_WC_rp(1:1024, end));
%             mx = max( max( [ LA_DC_rp(1:1024,end), LA_NM_rp(1:1024, end), LA_WC_rp(1:1024, end) ] ) );
%             HL = legend('demand charge','net meter','wholesale comp');
%             set(HL,'FontName','Times','FontSize',FontSize_legend)
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
%             xlim([0 1024])
%             ylim([0 mx ])
% 
%        subplot(3,4,2)
%             var = 'reg cust';
%             plot(x(1:1024), LA_DC_rc(1:1024,end), x(1:1024), LA_NM_rc(1:1024, end),x(1:1024), LA_WC_rc(1:1024, end));
%             mx = max( max( [ LA_DC_rc(1:1024,end), LA_NM_rc(1:1024, end), LA_WC_rc(1:1024, end) ] ) );
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
%             xlim([0 1024])
%             ylim([0 mx ])
% 
%        subplot(3,4,3)
%             var = 'PV cust';
%             plot(x(1:1024), LA_DC_pv(1:1024,end), x(1:1024), LA_NM_pv(1:1024, end),x(1:1024), LA_WC_pv(1:1024, end));
%             mx = max( max( [ LA_DC_pv(1:1024,end), LA_NM_pv(1:1024, end), LA_WC_pv(1:1024, end) ] ) );
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
%             xlim([0 1024])
%             ylim([0 mx ])        
% 
%        subplot(3,4,4)
%             var = 'defectors';
%             plot(x(1:1024), LA_DC_de(1:1024,end), x(1:1024), LA_NM_de(1:1024, end),x(1:1024), LA_WC_de(1:1024, end));
%             mx = max( max( [ LA_DC_de(1:1024,end), LA_NM_de(1:1024, end), LA_WC_de(1:1024, end) ] ) );
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
%             xlim([0 1024])
%             ylim([0 mx ])
% 
%     % Boulder
%     city = 'Boulder';
%         ax = subplot(3,4,5);
%             var = 'retail price';
%             plot(x(1:1024), BO_DC_rp(1:1024,end), x(1:1024), BO_NM_rp(1:1024, end),x(1:1024), BO_WC_rp(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
%             xlim([0 1024])
% 
%        subplot(3,4,6)
%             var = 'reg cust';
%             plot(x(1:1024), BO_DC_rc(1:1024,end), x(1:1024), BO_NM_rc(1:1024, end),x(1:1024), BO_WC_rc(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             xlim([0 1024])
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
% 
%        subplot(3,4,7)
%             var = 'PV cust';
%             plot(x(1:1024), BO_DC_pv(1:1024,end), x(1:1024), BO_NM_pv(1:1024, end),x(1:1024), BO_WC_pv(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             xlim([0 1024])
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)        
% 
%        subplot(3,4,8)
%             var = 'defectors';
%             plot(x(1:1024), BO_DC_de(1:1024,end), x(1:1024), BO_NM_de(1:1024, end),x(1:1024), BO_WC_de(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             xlim([0 1024])
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label) 
% 
%     % Sydney
%     city = 'Sydney';
%         ax = subplot(3,4,9);
%             var = 'retail price';
%             plot(x(1:1024), SY_DC_rp(1:1024,end), x(1:1024), SY_NM_rp(1:1024, end),x(1:1024), SY_WC_rp(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
%             xlim([0 1024])
% 
%        subplot(3,4,10)
%             var = 'reg cust';
%             plot(x(1:1024), SY_DC_rc(1:1024,end), x(1:1024), SY_NM_rc(1:1024, end),x(1:1024), SY_WC_rc(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             xlim([0 1024])
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)
% 
%        subplot(3,4,11)
%             var = 'PV cust';
%             plot(x(1:1024), SY_DC_pv(1:1024,end), x(1:1024), SY_NM_pv(1:1024, end),x(1:1024), SY_WC_pv(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             xlim([0 1024])
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)        
% 
%        subplot(3,4,12)
%             var = 'defectors';
%             plot(x(1:1024), SY_DC_de(1:1024,end), x(1:1024), SY_NM_de(1:1024, end),x(1:1024), SY_WC_de(1:1024, end));
%     %         HL = legend('demand charge','net meter','wholesale comp');
%             xlim([0 1024])
%             name = sprintf('%s %s', city, var);
%             title(name,'FontName','Times','FontSize',FontSize_label)          
end
%-------------------------------------------------------------------

%% plot_multi_year_bar
if plot_multi_year_bar == 1

    %% LA
        city = 'LA';
        % NetMeter
            model = 'Net Meter';
            HF = figure; grid on, set(HF,'Name','LA 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            
            subplot(3,3,1)
            clear Y, Y = [LA_NM_rc(1:1024,12) LA_NM_pv(1:1024,12) LA_NM_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,2)
            clear Y, Y = [LA_NM_rc(1:1024,24) LA_NM_pv(1:1024,24) LA_NM_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label)    
            
            subplot(3,3,3)
            clear Y, Y = [LA_NM_rc(1:1024,end) LA_NM_pv(1:1024,end) LA_NM_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label)    
        %  DemandCharge
            model = 'Demand Charge';
            subplot(3,3,4)
            clear Y, Y = [LA_DC_rc(1:1024,12) LA_DC_pv(1:1024,12) LA_DC_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,5)
            clear Y, Y = [LA_DC_rc(1:1024,24) LA_DC_pv(1:1024,24) LA_DC_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,6)
            clear Y, Y = [LA_DC_rc(1:1024,end) LA_DC_pv(1:1024,end) LA_DC_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label) 
        % WholesaleComp
            model = 'WholesaleComp';  
            subplot(3,3,7)
            clear Y, Y = [LA_WC_rc(1:1024,12) LA_WC_pv(1:1024,12) LA_WC_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,8)
            clear Y, Y = [LA_WC_rc(1:1024,24) LA_WC_pv(1:1024,24) LA_WC_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,9)
            clear Y, Y = [LA_WC_rc(1:1024,end) LA_WC_pv(1:1024,end) LA_WC_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 4e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
        saveastight(gcf,['multi_year_',city],'pdf')

    %% Boulder
        city = 'Boulder';
        % NetMeter
            model = 'Net Meter';
            HF = figure; grid on, set(HF,'Name','Boulder 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            
            subplot(3,3,1)
            clear Y, Y = [BO_NM_rc(1:1024,12) BO_NM_pv(1:1024,12) BO_NM_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,2)
            clear Y, Y = [BO_NM_rc(1:1024,24) BO_NM_pv(1:1024,24) BO_NM_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label)    
            
            subplot(3,3,3)
            clear Y, Y = [BO_NM_rc(1:1024,end) BO_NM_pv(1:1024,end) BO_NM_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label)    
        %  DemandCharge
            model = 'Demand Charge';
            subplot(3,3,4)
            clear Y, Y = [BO_DC_rc(1:1024,12) BO_DC_pv(1:1024,12) BO_DC_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,5)
            clear Y, Y = [BO_DC_rc(1:1024,24) BO_DC_pv(1:1024,24) BO_DC_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,6)
            clear Y, Y = [BO_DC_rc(1:1024,end) BO_DC_pv(1:1024,end) BO_DC_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label) 
        % WholesaleComp
            model = 'WholesaleComp';  
            subplot(3,3,7)
            clear Y, Y = [BO_WC_rc(1:1024,12) BO_WC_pv(1:1024,12) BO_WC_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,8)
            clear Y, Y = [BO_WC_rc(1:1024,24) BO_WC_pv(1:1024,24) BO_WC_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,9)
            clear Y, Y = [BO_WC_rc(1:1024,end) BO_WC_pv(1:1024,end) BO_WC_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 7e4])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label) 
        saveastight(gcf,['multi_year_',city],'pdf')
        
        
    %% Sydney
        city = 'Sydney';
        % NetMeter
            model = 'Net Meter';
            HF = figure; grid on, set(HF,'Name','Sydney 2050 households')
            set(gcf,'Position',[ -1650         396        1440         827])
            
            subplot(3,3,1)
            clear Y, Y = [SY_NM_rc(1:1024,12) SY_NM_pv(1:1024,12) SY_NM_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,2)
            clear Y, Y = [SY_NM_rc(1:1024,24) SY_NM_pv(1:1024,24) SY_NM_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label)    
            
            subplot(3,3,3)
            clear Y, Y = [SY_NM_rc(1:1024,end) SY_NM_pv(1:1024,end) SY_NM_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label)    
        %  DemandCharge
            model = 'Demand Charge';
            subplot(3,3,4)
            clear Y, Y = [SY_DC_rc(1:1024,12) SY_DC_pv(1:1024,12) SY_DC_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,5)
            clear Y, Y = [SY_DC_rc(1:1024,24) SY_DC_pv(1:1024,24) SY_DC_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,6)
            clear Y, Y = [SY_DC_rc(1:1024,end) SY_DC_pv(1:1024,end) SY_DC_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label) 
        % WholesaleComp
            model = 'WholesaleComp';  
            subplot(3,3,7)
            clear Y, Y = [SY_WC_rc(1:1024,12) SY_WC_pv(1:1024,12) SY_WC_de(1:1024,12);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(12));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,8)
            clear Y, Y = [SY_WC_rc(1:1024,24) SY_WC_pv(1:1024,24) SY_WC_de(1:1024,24);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(24));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
            subplot(3,3,9)
            clear Y, Y = [SY_WC_rc(1:1024,end) SY_WC_pv(1:1024,end) SY_WC_de(1:1024,end);];
            bar(x(1:1024),Y,'stacked')
            xlim([0,length(x(1:1024))])
            ylim([0, 3.5e6])
            legend('reg','PV','def','Location','SouthWest')
            name = sprintf('%s %s %d', city, model, yr(36));
            title(name,'FontName','Times','FontSize',FontSize_label) 
            
        saveastight(gcf,['multi_year_',city],'pdf')
    
end % plot_multi_year_bar

%-------------------------------------------------------------------

%% Plot percentage
if plot_percentage == 1
    
     %% LA
    city = 'LA';
    %  DemandCharge
            model = 'Demand Charge';
            addpath ./LA/DemandCharge

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
                                   
            rcy = ( rc(:,end) - rc(:,1) ) ./ rc(:,1);
            rpy = ( rp(:,end) - rp(:,1) ) ./ rp(:,1);
            pvy = ( pv(:,end) - pv(:,1) ) ./ pv(:,1);
            dey = ( de(:,end) - de(:,1) ) ./ de(:,1);
            
%             mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
%             mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));


            HF = figure;
            set(HF,'Name','Delta 2050 - 2015 values')

            ax = subplot(2,3,1);
            P  = get(ax,'pos');    % Get the position.
%             delete(ax)              % Delete the subplot axes

            x = 1:size(rc,1); % plotting vector
            hold on

            Hrc = plot(ax,x, rcy,'b:');

%             Hpv = plot(ax, x, pvy,'r');
            Hrp = plot(ax, x, rpy,'k--');
%             set(Hrc,'linestyle',':')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
%             xlim(ax(1),[0, size(rc,1)])
%             xlim(ax(2),[0, size(rc,1)])
%             ylim(ax(1), [mn mx])
%             ylim(ax(2), [0 0.8])
%             set(ax(1),'YTick', [-1e+06  0 1e+06],'YTickLabel',[-1e6 0 1e6])

%             HL = legend( [Hrc, Hpv, Hrp], 'reg cust', 'PV cust','retail price','Location','southwestoutside');

%             HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            set(ax,'pos',P)       % Recover the position.
            rmpath ./LA/DemandCharge% remove path


end

%% Plot individual cases
  if plot_single == 1
      
%         model = 'Demand Charge'; mod_title = 'Demand_Charge';
        model = 'Net Meter'; mod_title = 'Net_Meter';
%         model = 'WholesaleComp'; mod_title = 'WholesaleComp';


     city = 'LA';
%         addpath ./LA/DemandCharge
        addpath ./LA/NetMeter
%         addpath ./LA/WholesaleComp


%     city = 'Boulder';
%         addpath ./Boulder/NetMeter
%         addpath ./Boulder/DemandCharge
%         addpath ./Boulder/WholesaleComp

%      city = 'Sydney';
%         addpath ./Sydney/DemandCharge
%         addpath ./Sydney/NetMeter
%         addpath ./Sydney/WholesaleComp

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK2049'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK2049'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK2049'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK2049'); % defectors
  
%         for i = 328:(360-328):360
%             close all
            i = 641         
            mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
            n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values
            name = sprintf('%s_%s_case_%d', city, model, i);

            nested_plot_base_case
%             pause
%         end
  end
  

%% Nested functions
    function bar_fractions
                H = bar(Y,'stacked');

                % labeling each section of vert bars with value
                h = get(H, 'Children');
                h = cell2mat(h);
                yData = get(h, 'YData');
                yData = cell2mat(yData);
                barYs = yData(2:4:end,:);
                barValues = diff([zeros(1,size(barYs,2)); barYs]);
                barValues(bsxfun(@minus,barValues,sum(barValues))==0) = 0;  % no sub-total for bars having only a single sub-total
                yPos = yData(1:4:end,:) + barValues/2;
                xPos = [1; 1; 1; 2; 2; 2; 3; 3; 3];
    %             yPos = repmat( [.25 .75 .95], 1, 3);
                Y = round(Y*1000)./1000; 
                labels = num2str( vertcat(Y(1,:)', Y(2,:)', Y(3,:)') );
%                 yPos(yPos > 0.925) = 0.925;
                text( xPos, yPos(:), labels, 'color', [1 1 1],'FontName','Times','FontSize',FontSize_axis-5);
                ylim([0 1.2])
                set(gca,'YTick', [0  .5  1],'YTickLabel', [0  .5  1], 'FontName','Times','FontSize',FontSize_axis-5) 

                ylabel('Fraction of households','FontName','Times','FontSize',FontSize_axis-5)
    end
    

    function plot_cases
        x = 1:size(rc,1); % plotting vector
        hold on
        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1)); % retail cust on left vert axis, price on right
        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g--');
        set(Hrp,'color','k'), set(Hrc,'linestyle',':')
        xlabel('case','FontName','Times','FontSize',FontSize_label)
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [mn mx])
        base_case_stars
        name = sprintf('%s %s', city, model);
        title(name,'FontName','Times','FontSize',FontSize_label)
        
        % print average values to terminal
        city, model
        fprintf('reg cust avg = %.0f \n', mean(rc(:,end) - rc(:,1)) )
        fprintf('pv  cust avg = %.0f \n', mean(pv(:,end) - pv(:,1)) )
        fprintf('defector avg = %.0f \n', mean(de(:,end) - de(:,1)) )
        fprintf('ret pric avg = %.4f \n', mean(rp(:,end) - rp(:,1)) )
        
        if strcmp(city,'LA') == 1
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [-1e+06  0 1e+06],'YTickLabel',[-1e6 0 1e6])
            
        elseif strcmp(city,'Boulder') == 1
            ylim(ax(2), [0 .4])
            set(ax(1),'YTick', [-1e+04  0 1e+04 2e4],'YTickLabel',[-1e4 0 1e4 2e4])
            
        elseif strcmp(city,'Sydney') == 1
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [  0 2e+05 4e5 6e5 8e5],'YTickLabel',[0 2e+05 4e5 6e5 8e5])
        end
    end


    function base_case_stars
        plot(x(129), pv(129,end) - pv(129,1),'r*','linewidth', 2 );
        plot(x(129), de(129,end) - de(129,1),'g*','linewidth', 2 );
        plot(x(129), rp(129,end) - rp(129,1),'k*','linewidth', 2 );
        plot(x(129), rc(129,end) - rc(129,1),'b*','linewidth', 2 );
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
            
            N = rc(i,:) + pv(i,:) + de(i,:); % total households in 2015

            [ax,Hrc,Hrp] = plotyy(yr, rc(i,:)./N, yr, rp(i,:));
            set(Hrc,'Color',Blue,'marker','x','linewidth',2)
            set(Hrp,'Color',DimGray,'linewidth',2)
            Hpv = plot(ax(1), yr, pv(i,:)./N,'s-');
            set(Hpv,'Color',Green,'linewidth',2,'markerfacecolor',Green,'markersize',4)
            Hde = plot(ax(1), yr, de(i,:)./N,'d-','color',DarkMagenta);
            set(Hde,'Color',DarkMagenta,'linewidth',2,'markerfacecolor',DarkMagenta,'markersize',4)
            mx = max([ rc(i,:)./N, de(i,:)./N, pv(i,:)./N ]);
            ylabel(ax(1),'Fraction of households','FontName','Times','FontSize',FontSize_label) % households vert axis

            
            HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg customers', 'PV customers', 'defectors', 'retail price','Location','Best');
            set(HL,'FontSize',16,'FontWeight','bold')
            

            ylim(ax(1), [0 1]) % households vert axis
            set(ax(1), 'YTick', [0 .2 .4 .6 .8 1.0], 'YTickLabel', [0 .2 .4 .6 .8 1.0]) % households vert axis
            
            ylim(ax(2), [0 1]) % retail price vert axis
            set(ax(2),'YTick', [0 .2 .4 .6 .8 1.0 1.2 1.6 2],'YTickLabel', [0 .2 .4 .6 .8 1.0 1.2 1.6 2]) % retail price vert axis

%                 name = sprintf('%s %s case %d', city, mod_title, i);

%             title(name,'FontName','Times','FontSize',FontSize_label)
            xlabel('Year','FontName','Times','FontSize',FontSize_label)
            ylabel(ax(2),'Retail price (2015 nominal $/kWh)' ,'FontName','Times','FontSize',FontSize_label,'Color',DimGray) % retail price vert axis
            set(ax(2),'FontName','Times','FontSize',FontSize_axis,'ycolor',DimGray) % retail price vert axis
            set(ax(1),'FontName','Times','FontSize',FontSize_axis,'ycolor','k') % households vert axis
        
            

        
        
        if save_figures == 1
            if i == 641
                saveastight(gcf,['base_case_',city,'_',mod_title,'_FRACTION'],'pdf')
            elseif i == 1665
                saveastight(gcf,['NO_LIMIT_base_case_',city,'_',model,'_FRACTION'],'pdf')
            else
                saveastight(gcf,[city,'_',mod_title,'_FRACTION_case',num2str(i)],'pdf')
            end
        end
        
    end % nested_plot_base_case


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
    end % plot_single_effect
  
  
end % parent function