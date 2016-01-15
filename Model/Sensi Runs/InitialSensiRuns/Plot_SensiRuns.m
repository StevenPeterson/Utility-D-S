% Script to import Death Spiral sensitivity analysis results and plot


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
function Plot_SensiRuns

close all, clear, clc

[val,TXT,RAW]=xlsread('RunCombos.xlsx');  % val = sensitivity variable values
var = TXT(1,2:10);                        % var = sensitivity variable names

%-------------------------------------------------------------------

plot_all         = 0; % 1 == plot the difference of 2050 value minus 2015 value for all 512  cases for each city and business model
plot_with_limit  = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each CITY with subplots for each
                      %  BUSINESS MODEL
plot_with_limit2 = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each BUSINESS MODEL with subplots for each
                      %  CITY                     
                     
plot_base_case   = 0; % 1 == plot run 1 for 9 models (3 cities X 3 business models)
plot_2050        = 0; % 1 == plot 2050 values
plot_percentage  = 0; % 1 == plot percentage changes in reg cust, PV cust, retail price NOT FINISHED
plot_single      = 0; % 1 == plot indivual case (set below)
save_figures     = 0; % save plots as PDFs

%-------------------------------------------------------------------        

    FontSize_axis  = 18;  
    FontSize_label = 20; 
    FontSize_legend= 18;
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
            LA_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            LA_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            LA_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            LA_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./LA/DemandCharge% remove path
            
            addpath ./LA/NetMeter
            LA_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            LA_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            LA_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            LA_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./LA/NetMeter  % remove path
            
            addpath ./LA/WholesaleComp
            LA_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            LA_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            LA_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            LA_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./LA/WholesaleComp  % remove path
            
            addpath ./Boulder/DemandCharge
            BO_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            BO_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            BO_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            BO_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./Boulder/DemandCharge% remove path
            
            addpath ./Boulder/NetMeter
            BO_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            BO_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            BO_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            BO_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./Boulder/NetMeter  % remove path
            
            addpath ./Boulder/WholesaleComp
            BO_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            BO_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            BO_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            BO_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./Boulder/WholesaleComp  % remove path
            
            addpath ./Sydney/DemandCharge
            SY_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            SY_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            SY_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            SY_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./Sydney/DemandCharge% remove path
            
            addpath ./Sydney/NetMeter
            SY_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            SY_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            SY_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            SY_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./Sydney/NetMeter  % remove path
            
            addpath ./Sydney/WholesaleComp
            SY_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            SY_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            SY_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            SY_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
            rmpath ./Sydney/WholesaleComp  % remove path

            x = 1:size(LA_DC_rc,1); % plotting vector
            
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
            
            Hf = figure; set(gcf,'Position', [17 19 1384 779])
            set(Hf,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            
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
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors

            plot_cases

            rmpath ./LA/NetMeter  % remove path

    %  WholesaleComp
            model = 'WholesaleComp';
            addpath ./LA/WholesaleComp
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors

            plot_cases

            rmpath ./LA/WholesaleComp  % remove path


    %% Boulder
    city = 'Boulder';
    % DemandCharge
            model = 'Demand Charge';
            addpath ./Boulder/DemandCharge
            
            Hf = figure; set(gcf,'Position', [17 19 1384 779])
            set(Hf,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases

            rmpath ./Boulder/DemandCharge% remove path

    % NetMeter
            model = 'Net Meter';
            addpath ./Boulder/NetMeter
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors

            plot_cases

            rmpath ./Boulder/NetMeter  % remove path

    % WholesaleComp
            model = 'WholesaleComp';
            addpath ./Boulder/WholesaleComp
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors

            plot_cases

            rmpath ./Boulder/WholesaleComp  % remove path


    %% Sydney
    city = 'Sydney';
    
    % DemandCharge
            model = 'Demand Charge';
            addpath ./Sydney/DemandCharge
            
            Hf = figure; set(gcf,'Position', [17 19 1384 779])
            set(Hf,'Name','Delta 2050 - 2015 values')
            subplot(1,3,1);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
          
            plot_cases

            rmpath ./Sydney/DemandCharge% remove path
            
    % NetMeter
            model = 'Net Meter';
            addpath ./Sydney/NetMeter
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors

            plot_cases

            rmpath ./Sydney/NetMeter  % remove path
            
            

    % WholesaleComp
            model = 'WholesaleComp';
            addpath ./Sydney/WholesaleComp
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors

            plot_cases

            rmpath ./Sydney/WholesaleComp  % remove path

end % plot_with_limit

if plot_with_limit2 == 1
    
%  DemandCharge
    model = 'Demand Charge';

        city = 'LA';
            addpath ./LA/DemandCharge
            
            Hf = figure; set(gcf,'Position', [17 19 1384 779])
            set(Hf,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            
            HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','southwestoutside');
            set(ax,'pos',P)       % Recover the position.
            rmpath ./LA/DemandCharge% remove path
            
        city = 'Boulder';
            addpath ./Boulder/DemandCharge
            
            ax = subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Boulder/DemandCharge% remove path

        city = 'Sydney';
            addpath ./Sydney/DemandCharge
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
          
            plot_cases
            rmpath ./Sydney/DemandCharge% remove path
            
%  NetMeter
    model = 'Net Meter';
        city = 'LA';
            addpath ./LA/NetMeter
            Hf = figure; set(gcf,'Position', [17 19 1384 779])
            set(Hf,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            subplot(1,3,1);
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./LA/NetMeter  % remove path
            
      city = 'Boulder';
            addpath ./Boulder/NetMeter
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Boulder/NetMeter  % remove path
            
       city = 'Sydney'
            addpath ./Sydney/NetMeter
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Sydney/NetMeter  % remove path
            
%  WholesaleComp
    model = 'WholesaleComp';
        city = 'LA';
            addpath ./LA/WholesaleComp
            Hf = figure; set(gcf,'Position', [17 19 1384 779])
            set(Hf,'Name','Delta 2050 - 2015 values')
            ax = subplot(1,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes
            subplot(1,3,1);
            
            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./LA/WholesaleComp % remove path
            
      city = 'Boulder';
            addpath ./Boulder/WholesaleComp
            
            subplot(1,3,2);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Boulder/WholesaleComp  % remove path
            
       city = 'Sydney'
            addpath ./Sydney/WholesaleComp
            
            subplot(1,3,3);

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
            mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
            mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));

            plot_cases
            rmpath ./Sydney/WholesaleComp  % remove path
            
end % plot_with_limit2

%% plot_base_case  -----------------------------------------------------------------
if plot_base_case == 1
%    i = 129; % run number for base case values
   i = 385; % run number for base case without limit on rental homes
   
city = 'LA';
    model = 'Net Meter';
        rc = LA_NM_rc;
        rp = LA_NM_rp;
        pv = LA_NM_pv;
        de = LA_NM_de;
        
        mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
        n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values
        
        nested_plot_base_case

                        
    model = 'Demand Charge';
        rc = LA_DC_rc;
        rp = LA_DC_rp;
        pv = LA_DC_pv;
        de = LA_DC_de;
        nested_plot_base_case
            
    model = 'Wholesale Comp';
        rc = LA_WC_rc;
        rp = LA_WC_rp;
        pv = LA_WC_pv;
        de = LA_WC_de;

        nested_plot_base_case
        
        
city = 'Boulder';
    
    model = 'Net Meter';
        rc = BO_NM_rc;
        rp = BO_NM_rp;
        pv = BO_NM_pv;
        de = BO_NM_de;
        
        mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
        n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values

        nested_plot_base_case
           
           
    model = 'Demand Charge';
        rc = BO_DC_rc;
        rp = BO_DC_rp;
        pv = BO_DC_pv;
        de = BO_DC_de;

        nested_plot_base_case
    

    model = 'Wholesale Comp';
        rc = BO_WC_rc;
        rp = BO_WC_rp;
        pv = BO_WC_pv;
        de = BO_WC_de;

        nested_plot_base_case

city = 'Sydney';

    model = 'Wholesale Comp';
        rc = SY_WC_rc;
        rp = SY_WC_rp;
        pv = SY_WC_pv;
        de = SY_WC_de;
        
        mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
        n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values
        
        nested_plot_base_case
    
    model = 'Net Meter';
        rc = SY_NM_rc;
        rp = SY_NM_rp;
        pv = SY_NM_pv;
        de = SY_NM_de;

        nested_plot_base_case
           
           
    model = 'Demand Charge';
        rc = SY_DC_rc;
        rp = SY_DC_rp;
        pv = SY_DC_pv;
        de = SY_DC_de;

        nested_plot_base_case
    
end

%% plot_2050 -----------------------------------------------------------------
if plot_2050 == 1
    
    Hf = figure;
    set(Hf,'Name','2050 values')
    hold on

    % LA
    city = 'LA';
        ax = subplot(3,4,1);
            var = 'retail price';
            plot(x(1:256), LA_DC_rp(1:256,end), x(1:256), LA_NM_rp(1:256, end),x(1:256), LA_WC_rp(1:256, end));
            mx = max( max( [ LA_DC_rp(1:256,end), LA_NM_rp(1:256, end), LA_WC_rp(1:256, end) ] ) );
            HL = legend('demand charge','net meter','wholesale comp');
            set(HL,'FontName','Times','FontSize',FontSize_legend)
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])
            ylim([0 mx ])

       subplot(3,4,2)
            var = 'reg cust';
            plot(x(1:256), LA_DC_rc(1:256,end), x(1:256), LA_NM_rc(1:256, end),x(1:256), LA_WC_rc(1:256, end));
            mx = max( max( [ LA_DC_rc(1:256,end), LA_NM_rc(1:256, end), LA_WC_rc(1:256, end) ] ) );
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])
            ylim([0 mx ])

       subplot(3,4,3)
            var = 'PV cust';
            plot(x(1:256), LA_DC_pv(1:256,end), x(1:256), LA_NM_pv(1:256, end),x(1:256), LA_WC_pv(1:256, end));
            mx = max( max( [ LA_DC_pv(1:256,end), LA_NM_pv(1:256, end), LA_WC_pv(1:256, end) ] ) );
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])
            ylim([0 mx ])        

       subplot(3,4,4)
            var = 'defectors';
            plot(x(1:256), LA_DC_de(1:256,end), x(1:256), LA_NM_de(1:256, end),x(1:256), LA_WC_de(1:256, end));
            mx = max( max( [ LA_DC_de(1:256,end), LA_NM_de(1:256, end), LA_WC_de(1:256, end) ] ) );
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])
            ylim([0 mx ])

    % Boulder
    city = 'Boulder';
        ax = subplot(3,4,5);
            var = 'retail price';
            plot(x(1:256), BO_DC_rp(1:256,end), x(1:256), BO_NM_rp(1:256, end),x(1:256), BO_WC_rp(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])

       subplot(3,4,6)
            var = 'reg cust';
            plot(x(1:256), BO_DC_rc(1:256,end), x(1:256), BO_NM_rc(1:256, end),x(1:256), BO_WC_rc(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)

       subplot(3,4,7)
            var = 'PV cust';
            plot(x(1:256), BO_DC_pv(1:256,end), x(1:256), BO_NM_pv(1:256, end),x(1:256), BO_WC_pv(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)        

       subplot(3,4,8)
            var = 'defectors';
            plot(x(1:256), BO_DC_de(1:256,end), x(1:256), BO_NM_de(1:256, end),x(1:256), BO_WC_de(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label) 

    % Sydney
    city = 'Sydney';
        ax = subplot(3,4,9);
            var = 'retail price';
            plot(x(1:256), SY_DC_rp(1:256,end), x(1:256), SY_NM_rp(1:256, end),x(1:256), SY_WC_rp(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])

       subplot(3,4,10)
            var = 'reg cust';
            plot(x(1:256), SY_DC_rc(1:256,end), x(1:256), SY_NM_rc(1:256, end),x(1:256), SY_WC_rc(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)

       subplot(3,4,11)
            var = 'PV cust';
            plot(x(1:256), SY_DC_pv(1:256,end), x(1:256), SY_NM_pv(1:256, end),x(1:256), SY_WC_pv(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)        

       subplot(3,4,12)
            var = 'defectors';
            plot(x(1:256), SY_DC_de(1:256,end), x(1:256), SY_NM_de(1:256, end),x(1:256), SY_WC_de(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp');
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)          
end
        
%-------------------------------------------------------------------

%% Plot percentage
if plot_percentage == 1
    
     %% LA
    city = 'LA';
    %  DemandCharge
            model = 'Demand Charge';
            addpath ./LA/DemandCharge

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors
                                   
            rcy = ( rc(:,end) - rc(:,1) ) ./ rc(:,1);
            rpy = ( rp(:,end) - rp(:,1) ) ./ rp(:,1);
            pvy = ( pv(:,end) - pv(:,1) ) ./ pv(:,1);
            dey = ( de(:,end) - de(:,1) ) ./ de(:,1);
            
%             mx = max(max([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));
%             mn = min(min([ pv(:,end) - pv(:,1), de(:,end) - de(:,1), rc(:,end) - rc(:,1)  ]));


            Hf = figure;
            set(Hf,'Name','Delta 2050 - 2015 values')

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
     city = 'LA';
        model = 'Demand Charge';
        addpath ./LA/DemandCharge

%         model = 'Net Meter';
%         addpath ./LA/NetMeter

%     city = 'Boulder';
%         model = 'Net Meter';
%         addpath ./Boulder/NetMeter

%      city = 'Sydney';
%         model = 'Net Meter';
%         addpath ./Sydney/NetMeter

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
  
        for i = 1:256
            close all
            figure, hold on
            i
    %         i = 33;
            mx = max([ rc(i,:), de(i,:), pv(i,:) ]); % maximum number of households for plotting
            n = floor([ 0 mx/4 mx/2 3*mx/4 mx]); % YTick values
            nested_plot_base_case
            pause
        end
  end
  

%% Nested functions

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
        figure, hold on, box on, grid on
        
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrc,'Color',Blue,'marker','x')
        set(Hrp,'Color',DimGray)
        Hpv = plot(ax(1), yr, pv(i,:),'g--');
        set(Hpv,'Color',Green)
        Hde = plot(ax(1), yr, de(i,:),'m.-');
        set(Hde,'Color',DarkMagenta)
        ylim(ax(1), [0 mx])
        HL = legend( [Hrc, Hpv, Hde, Hrp], 'reg cust', 'PV cust', 'defectors', 'retail price','Location','west');
        
        if strcmp(city,'Boulder')  ==  1
            ylabel(ax(1),'Households (thousands)','FontName','Times','FontSize',FontSize_label)
            set(ax(1), 'YTick', n,'YTickLabel', round(n/1e2)/1e1)
        else
            ylabel(ax(1),'Households (millions)','FontName','Times','FontSize',FontSize_label)
            set(ax(1), 'YTick', n,'YTickLabel', round(n/1e4)/1e2)
        end
        
        if  i < 129
            name = sprintf('%s %s case %d', city, model, i);
            ylim(ax(2), [0 .4])
            set(ax(2),'YTick', [0 .10 .20 .30 .40],'YTickLabel', [0 .10 .20 .30 .40])
        elseif i == 129
            name = sprintf('%s %s Base Case', city, model);
            ylim(ax(2), [0 .4])
            set(ax(2),'YTick', [0 .10 .20 .30 .40],'YTickLabel', [0 .10 .20 .30 .40])
        elseif i == 385
            name = sprintf('%s %s Base Case No Limit on PV customer ratio', city, model);
            ylim(ax(2), [0 .6])
            set(ax(2),'YTick', [0 .10 .20 .30 .40 .50 .60],'YTickLabel', [0 .10 .20 .30 .40 .50 .60])
        end
        title(name,'FontName','Times','FontSize',FontSize_label)
        xlabel('Year','FontName','Times','FontSize',FontSize_label)
        ylabel(ax(2),'Retail price ($/kWh)' ,'FontName','Times','FontSize',FontSize_label,'Color',DimGray)
        set(ax(2),'FontName','Times','FontSize',FontSize_axis,'ycolor',DimGray)
        set(ax(1),'FontName','Times','FontSize',FontSize_axis,'ycolor','k')
        
        
        
        if save_figures == 1
            if i == 129
                saveastight(gcf,[city,' ',model,' base case'],'pdf')
            elseif i == 385
                saveastight(gcf,[city,' ',model,' base case NO LIMIT'],'pdf')
            end
        end
        
    end % nested_plot_base_case
  
  
end % parent function