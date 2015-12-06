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

close all
yr = 2015:1:2050; % year vector

[val,TXT,RAW]=xlsread('RunCombos.xlsx');  % val = sensitivity variable values
var = TXT(1,2:10);                        % var = sensitivity variable names

plot_all        = 0; % 1 == plot all 512  cases for each city and business model
plot_with_limit = 0; % 1 == plot runs 1:256, which have Use limit on ratio of PV to total households = 1
plot_base_case  = 1; % run 1 for 9 models (3 cities X 3 business models)

%-------------------------------------------------------------------        

    FontSize_axis  = 18;  
    FontSize_label = 20; 
%     xlabel('time, tU/c'           ,'FontName','Times','FontSize',FontSize_label) 
%     set(gca,'FontName','Times','FontSize',FontSize_axis)
%     set(HL,'FontName','Times','FontSize',FontSize_axis-2,'Location','NorthEast')





if plot_all == 1
    %% LA
    city = 'LA';
    %  DemandCharge
            model = 'Demand Charge';
            addpath ./LA/DemandCharge

            LA_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            LA_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            LA_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            LA_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            ax = subplot(3,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes

            x = 1:size(LA_DC_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, LA_DC_rc(:,end) - LA_DC_rc(:,1), x, LA_DC_rp(:,end) - LA_DC_rp(:,1));

            Hpv = plot(ax(1), x, LA_DC_pv(:,end) - LA_DC_pv(:,1),'r');
            Hde = plot(ax(1), x, LA_DC_de(:,end) - LA_DC_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(LA_DC_rc,1)])
            xlim(ax(2),[0, size(LA_DC_rc,1)])
            ylim(ax(1), [min(LA_DC_rc(:,end) - LA_DC_rc(:,1)) max(max( LA_DC_pv(:,end) - LA_DC_pv(:,1), LA_DC_de(:,end) - LA_DC_de(:,1) ))])
            HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest') ;
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            set(ax,'pos',P)       % Recover the position.
            rmpath ./LA/DemandCharge% remove path

    % NetMeter
            model = 'Net Meter';
            addpath ./LA/NetMeter

            LA_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            LA_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            LA_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            LA_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            subplot(3,3,2);
    %         P  = get(ax,'pos');    % Get the position.
    %         delete(ax)              % Delete the subplot axes

            x = 1:size(LA_NM_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, LA_NM_rc(:,end) - LA_NM_rc(:,1), x, LA_NM_rp(:,end) - LA_NM_rp(:,1));

            Hpv = plot(ax(1), x, LA_NM_pv(:,end) - LA_NM_pv(:,1),'r');
            Hde = plot(ax(1), x, LA_NM_de(:,end) - LA_NM_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(LA_NM_rc,1)])
            xlim(ax(2),[0, size(LA_NM_rc,1)])
            ylim(ax(1), [min(LA_NM_rc(:,end) - LA_NM_rc(:,1)) max(max( LA_NM_pv(:,end) - LA_NM_pv(:,1), LA_NM_de(:,end) - LA_NM_de(:,1) ))])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./LA/NetMeter  % remove path

    % WholesaleComp
            model = 'WholesaleComp';
            addpath ./LA/WholesaleComp

            LA_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            LA_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            LA_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            LA_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            subplot(3,3,3);

            x = 1:size(LA_WC_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, LA_WC_rc(:,end) - LA_WC_rc(:,1), x, LA_WC_rp(:,end) - LA_WC_rp(:,1));

            Hpv = plot(ax(1), x, LA_WC_pv(:,end) - LA_WC_pv(:,1),'r');
            Hde = plot(ax(1), x, LA_WC_de(:,end) - LA_WC_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(LA_WC_rc,1)])
            xlim(ax(2),[0, size(LA_WC_rc,1)])
            ylim(ax(1), [min(LA_WC_rc(:,end) - LA_WC_rc(:,1)) max(max( LA_WC_pv(:,end) - LA_WC_pv(:,1), LA_WC_de(:,end) - LA_WC_de(:,1) ))])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./LA/WholesaleComp  % remove path


    %% Boulder
    city = 'Boulder';
        %     DemandCharge
            model = 'Demand Charge';
            addpath ./Boulder/DemandCharge

            BO_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            BO_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            BO_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            BO_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            ax = subplot(3,3,4);

            x = 1:size(BO_DC_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, BO_DC_rc(:,end) - BO_DC_rc(:,1), x, BO_DC_rp(:,end) - BO_DC_rp(:,1));

            Hpv = plot(ax(1), x, BO_DC_pv(:,end) - BO_DC_pv(:,1),'r');
            Hde = plot(ax(1), x, BO_DC_de(:,end) - BO_DC_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(BO_DC_rc,1)])
            xlim(ax(2),[0, size(BO_DC_rc,1)])
            ylim(ax(1), [min(BO_DC_rc(:,end) - BO_DC_rc(:,1)) max(max( BO_DC_pv(:,end) - BO_DC_pv(:,1), BO_DC_de(:,end) - BO_DC_de(:,1) ))])
            ylim(ax(2), [0 3])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Boulder/DemandCharge% remove path

        %     NetMeter
                model = 'Net Meter';
                addpath ./Boulder/NetMeter

                BO_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
                BO_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
                BO_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
                BO_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


                subplot(3,3,5);

                x = 1:size(BO_NM_rc,1); % plotting vector
                hold on

                [ax,Hrc,Hrp] = plotyy(x, BO_NM_rc(:,end) - BO_NM_rc(:,1), x, BO_NM_rp(:,end) - BO_NM_rp(:,1));

                Hpv = plot(ax(1), x, BO_NM_pv(:,end) - BO_NM_pv(:,1),'r');
                Hde = plot(ax(1), x, BO_NM_de(:,end) - BO_NM_de(:,1),'g');
                set(Hrp,'color','k')
                xlabel('case','FontName','Times','FontSize',FontSize_label)
                xlim(ax(1),[0, size(BO_NM_rc,1)])
                xlim(ax(2),[0, size(BO_NM_rc,1)])
                ylim(ax(1), [min(BO_NM_rc(:,end) - BO_NM_rc(:,1)) max(max( BO_NM_pv(:,end) - BO_NM_pv(:,1), BO_NM_de(:,end) - BO_NM_de(:,1) ))])
        %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
                name = sprintf('%s %s', city, model);
                title(name,'FontName','Times','FontSize',FontSize_label)

                rmpath ./Boulder/NetMeter  % remove path

        %     WholesaleComp
            model = 'WholesaleComp';
            addpath ./Boulder/WholesaleComp

            BO_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            BO_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            BO_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            BO_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            subplot(3,3,6);

            x = 1:size(BO_WC_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, BO_WC_rc(:,end) - BO_WC_rc(:,1), x, BO_WC_rp(:,end) - BO_WC_rp(:,1));

            Hpv = plot(ax(1), x, BO_WC_pv(:,end) - BO_WC_pv(:,1),'r');
            Hde = plot(ax(1), x, BO_WC_de(:,end) - BO_WC_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(BO_WC_rc,1)])
            xlim(ax(2),[0, size(BO_WC_rc,1)])
            ylim(ax(1), [min(BO_WC_rc(:,end) - BO_WC_rc(:,1)) max(max( BO_WC_pv(:,end) - BO_WC_pv(:,1), BO_WC_de(:,end) - BO_WC_de(:,1) ))])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Boulder/WholesaleComp  % remove path


    %-------------------------------------------------------------------


    %% Sydney
    city = 'Sydney';
    %-------------------------------------------------------------------
        %    DemandCharge
            model = 'Demand Charge';
            addpath ./Sydney/DemandCharge

            SY_DC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            SY_DC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            SY_DC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            SY_DC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            ax = subplot(3,3,7);
            x = 1:size(SY_DC_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, SY_DC_rc(:,end) - SY_DC_rc(:,1), x, SY_DC_rp(:,end) - SY_DC_rp(:,1));

            Hpv = plot(ax(1), x, SY_DC_pv(:,end) - SY_DC_pv(:,1),'r');
            Hde = plot(ax(1), x, SY_DC_de(:,end) - SY_DC_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(SY_DC_rc,1)])
            xlim(ax(2),[0, size(SY_DC_rc,1)])
            ylim(ax(1), [min(SY_DC_rc(:,end) - SY_DC_rc(:,1)) max(max( SY_DC_pv(:,end) - SY_DC_pv(:,1), SY_DC_de(:,end) - SY_DC_de(:,1) ))])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Sydney/DemandCharge% remove path

        %     NetMeter
            model = 'Net Meter';
            addpath ./Sydney/NetMeter

            SY_NM_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            SY_NM_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            SY_NM_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            SY_NM_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            subplot(3,3,8);

            x = 1:size(SY_NM_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, SY_NM_rc(:,end) - SY_NM_rc(:,1), x, SY_NM_rp(:,end) - SY_NM_rp(:,1));

            Hpv = plot(ax(1), x, SY_NM_pv(:,end) - SY_NM_pv(:,1),'r');
            Hde = plot(ax(1), x, SY_NM_de(:,end) - SY_NM_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(SY_NM_rc,1)])
            xlim(ax(2),[0, size(SY_NM_rc,1)])
            ylim(ax(1), [min(SY_NM_rc(:,end) - SY_NM_rc(:,1)) max(max( SY_NM_pv(:,end) - SY_NM_pv(:,1), SY_NM_de(:,end) - SY_NM_de(:,1) ))])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

    %         set(ax,'pos',P)       % Recover the position.
            rmpath ./Sydney/NetMeter  % remove path

        %     WholesaleComp
            model = 'WholesaleComp';
            addpath ./Sydney/WholesaleComp

            SY_WC_rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
            SY_WC_rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
            SY_WC_pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
            SY_WC_de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors


            subplot(3,3,9);

            x = 1:size(SY_WC_rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, SY_WC_rc(:,end) - SY_WC_rc(:,1), x, SY_WC_rp(:,end) - SY_WC_rp(:,1));

            Hpv = plot(ax(1), x, SY_WC_pv(:,end) - SY_WC_pv(:,1),'r');
            Hde = plot(ax(1), x, SY_WC_de(:,end) - SY_WC_de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(SY_WC_rc,1)])
            xlim(ax(2),[0, size(SY_WC_rc,1)])
            ylim(ax(1), [min(SY_WC_rc(:,end) - SY_WC_rc(:,1)) max(max( SY_WC_pv(:,end) - SY_WC_pv(:,1), SY_WC_de(:,end) - SY_WC_de(:,1) ))])
    %         HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Sydney/WholesaleComp  % remove path
end % plot all




if plot_with_limit == 1
    %% LA
    city = 'LA';
    %  DemandCharge
            model = 'Demand Charge';
            addpath ./LA/DemandCharge

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors

            figure
            ax = subplot(3,3,1);
            P  = get(ax,'pos');    % Get the position.
            delete(ax)              % Delete the subplot axes

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [-1e+06  0 1e+06],'YTickLabel',[-1e6 0 1e6])

            HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest') ;
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            set(ax,'pos',P)       % Recover the position.
            rmpath ./LA/DemandCharge% remove path


    %  NetMeter
            model = 'Net Meter';
            addpath ./LA/NetMeter

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            subplot(3,3,2);
    %         P  = get(ax,'pos');    % Get the position.
    %         delete(ax)              % Delete the subplot axes

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [-1e+06  0 1e+06],'YTickLabel',[-1e6 0 1e6])

            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./LA/NetMeter  % remove path

    %  WholesaleComp
            model = 'WholesaleComp';
            addpath ./LA/WholesaleComp

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            subplot(3,3,3);

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [-1e+06  0 1e+06],'YTickLabel',[-1e6 0 1e6])
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./LA/WholesaleComp  % remove path


    %% Boulder
    city = 'Boulder';
    % DemandCharge
            model = 'Demand Charge';
            addpath ./Boulder/DemandCharge

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            ax = subplot(3,3,4);

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 .4])
            set(ax(1),'YTick', [-1e+04  0 1e+04 2e4],'YTickLabel',[-1e4 0 1e4 2e4])
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Boulder/DemandCharge% remove path

    % NetMeter
            model = 'Net Meter';
            addpath ./Boulder/NetMeter

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            subplot(3,3,5);

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 .4])
            set(ax(1),'YTick', [-1e+04  0 1e+04 2e4],'YTickLabel',[-1e4 0 1e4 2e4])
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Boulder/NetMeter  % remove path

    % WholesaleComp
            model = 'WholesaleComp';
            addpath ./Boulder/WholesaleComp

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            subplot(3,3,6);

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 .4])
            set(ax(1),'YTick', [-1e+04  0 1e+04 2e4],'YTickLabel',[-1e4 0 1e4 2e4])
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Boulder/WholesaleComp  % remove path


    %% Sydney
    city = 'Sydney';
    % DemandCharge
            model = 'Demand Charge';
            addpath ./Sydney/DemandCharge

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            ax = subplot(3,3,7);
            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [  0 2e+05 4e5 6e5 8e5],'YTickLabel',[0 2e+05 4e5 6e5 8e5])
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Sydney/DemandCharge% remove path

    % NetMeter
            model = 'Net Meter';
            addpath ./Sydney/NetMeter

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            subplot(3,3,8);

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [  0 2e+05 4e5 6e5 8e5],'YTickLabel',[0 2e+05 4e5 6e5 8e5])
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

    %         set(ax,'pos',P)       % Recover the position.
            rmpath ./Sydney/NetMeter  % remove path

    % WholesaleComp
            model = 'WholesaleComp';
            addpath ./Sydney/WholesaleComp

            rp = dlmread('1_RetailPrice.csv' ,',','B2..AK257'); % retail price
            rc = dlmread('2_RegularCust.csv' ,',','B2..AK257'); % reg. customers
            pv = dlmread('3_Cust_With_PV.csv',',','B2..AK257'); % pv customers
            de = dlmread('4_Defector.csv'    ,',','B2..AK257'); % defectors


            subplot(3,3,9);

            x = 1:size(rc,1); % plotting vector
            hold on

            [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

            Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
            Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
            set(Hrp,'color','k')
            xlabel('case','FontName','Times','FontSize',FontSize_label)
            xlim(ax(1),[0, size(rc,1)])
            xlim(ax(2),[0, size(rc,1)])
            ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
            ylim(ax(2), [0 0.8])
            set(ax(1),'YTick', [  0 2e+05 4e5 6e5 8e5],'YTickLabel',[0 2e+05 4e5 6e5 8e5])
            name = sprintf('%s %s', city, model);
            title(name,'FontName','Times','FontSize',FontSize_label)

            rmpath ./Sydney/WholesaleComp  % remove path

end % plot_with_limit


%% Base cases (run 1)
if plot_base_case == 1
   
city = 'LA';
        model = 'Net Meter';
        rc = LA_NM_rc;
        rp = LA_NM_rp;
        pv = LA_NM_pv;
        de = LA_NM_de;

        figure, hold on, box on, grid on
        i = 1;
        yr = 2015:1:2050;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)
           
           
        model = 'Demand Charge';
        rc = LA_DC_rc;
        rp = LA_DC_rp;
        pv = LA_DC_pv;
        de = LA_DC_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)
    

        model = 'Wholesale Comp';
        rc = LA_WC_rc;
        rp = LA_WC_rp;
        pv = LA_WC_pv;
        de = LA_WC_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)    
            
        
        
city = 'Boulder';
    
        model = 'Net Meter';
        rc = BO_NM_rc;
        rp = BO_NM_rp;
        pv = BO_NM_pv;
        de = BO_NM_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)
           
           
        model = 'Demand Charge';
        rc = BO_DC_rc;
        rp = BO_DC_rp;
        pv = BO_DC_pv;
        de = BO_DC_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)
    

        model = 'Wholesale Comp';
        rc = BO_WC_rc;
        rp = BO_WC_rp;
        pv = BO_WC_pv;
        de = BO_WC_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)    

city = 'Sydney';
    
        model = 'Net Meter';
        rc = SY_NM_rc;
        rp = SY_NM_rp;
        pv = SY_NM_pv;
        de = SY_NM_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)
           
           
        model = 'Demand Charge';
        rc = SY_DC_rc;
        rp = SY_DC_rp;
        pv = SY_DC_pv;
        de = SY_DC_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)
    

        model = 'Wholesale Comp';
        rc = SY_WC_rc;
        rp = SY_WC_rp;
        pv = SY_WC_pv;
        de = SY_WC_de;

        figure, hold on, box on, grid on
        i = 1;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'g');
        Hde = plot(ax(1), yr, de(i,:),'m');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)    
    
end

%% plot last values vs. business model
figure, hold on

    %% LA
    city = 'LA';
        ax = subplot(3,4,1);
            var = 'retail price';
            plot(x(1:256), LA_DC_rp(1:256,end), x(1:256), LA_NM_rp(1:256, end),x(1:256), LA_WC_rp(1:256, end));
            HL = legend('demand charge','net meter','wholesale comp')
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])

       subplot(3,4,2)
            var = 'reg cust';
            plot(x(1:256), LA_DC_rc(1:256,end), x(1:256), LA_NM_rc(1:256, end),x(1:256), LA_WC_rc(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)

       subplot(3,4,3)
            var = 'PV cust';
            plot(x(1:256), LA_DC_pv(1:256,end), x(1:256), LA_NM_pv(1:256, end),x(1:256), LA_WC_pv(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)        

       subplot(3,4,4)
            var = 'defectors';
            plot(x(1:256), LA_DC_de(1:256,end), x(1:256), LA_NM_de(1:256, end),x(1:256), LA_WC_de(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label) 

    %% Boulder
    city = 'Boulder';
        ax = subplot(3,4,5);
            var = 'retail price';
            plot(x(1:256), BO_DC_rp(1:256,end), x(1:256), BO_NM_rp(1:256, end),x(1:256), BO_WC_rp(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])

       subplot(3,4,6)
            var = 'reg cust';
            plot(x(1:256), BO_DC_rc(1:256,end), x(1:256), BO_NM_rc(1:256, end),x(1:256), BO_WC_rc(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)

       subplot(3,4,7)
            var = 'PV cust';
            plot(x(1:256), BO_DC_pv(1:256,end), x(1:256), BO_NM_pv(1:256, end),x(1:256), BO_WC_pv(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)        

       subplot(3,4,8)
            var = 'defectors';
            plot(x(1:256), BO_DC_de(1:256,end), x(1:256), BO_NM_de(1:256, end),x(1:256), BO_WC_de(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label) 

    %% Sydney
    city = 'Sydney';
        ax = subplot(3,4,9);
            var = 'retail price';
            plot(x(1:256), SY_DC_rp(1:256,end), x(1:256), SY_NM_rp(1:256, end),x(1:256), SY_WC_rp(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)
            xlim([0 256])

       subplot(3,4,10)
            var = 'reg cust';
            plot(x(1:256), SY_DC_rc(1:256,end), x(1:256), SY_NM_rc(1:256, end),x(1:256), SY_WC_rc(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)

       subplot(3,4,11)
            var = 'PV cust';
            plot(x(1:256), SY_DC_pv(1:256,end), x(1:256), SY_NM_pv(1:256, end),x(1:256), SY_WC_pv(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)        

       subplot(3,4,12)
            var = 'defectors';
            plot(x(1:256), SY_DC_de(1:256,end), x(1:256), SY_NM_de(1:256, end),x(1:256), SY_WC_de(1:256, end));
    %         HL = legend('demand charge','net meter','wholesale comp')
            xlim([0 256])
            name = sprintf('%s %s', city, var);
            title(name,'FontName','Times','FontSize',FontSize_label)          
        
            
%% Plot individual cases
  
%      city = 'LA';
%         model = 'Demand Charge';
%         addpath ./LA/DemandCharge

%         model = 'Net Meter';
%         addpath ./LA/NetMeter

%     city = 'Boulder';
%         model = 'Net Meter';
%         addpath ./Boulder/NetMeter

     city = 'Sydney';
        model = 'Net Meter';
        addpath ./Sydney/NetMeter

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors
  
%         for i = 1:10
        figure, hold on
        i = 100;
        yr = 2015:1:2050;
        [ax,Hrc,Hrp] = plotyy(yr, rc(i,:), yr, rp(i,:));
        set(Hrp,'color','k')
        Hpv = plot(ax(1), yr, pv(i,:),'r');
        Hde = plot(ax(1), yr, de(i,:),'g');
        ylim(ax(1), [0 max(max( rc(i,:), de(i,:) ))])
        HL = legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')


           name = sprintf('%s %s Case %d', city, model, i);
           title(name,'FontName','Times','FontSize',FontSize_label)
%         end
