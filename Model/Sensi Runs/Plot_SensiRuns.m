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

%% LA
city = 'LA';
%     DemandCharge
        model = 'Demand Charge';
        addpath ./LA/DemandCharge

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        ax = subplot(3,3,1);
        P  = get(ax,'pos');    % Get the position.
        delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
        legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
        set(ax,'pos',P)       % Recover the position.
        rmpath ./LA/DemandCharge% remove path
       


        
%         for i = 1:10
%             figure
%            [ax,p1,p2] = plotyy(yr, rc(i,:), yr, rp(i,:));
%                set(p1,'color','m','linestyle','-')
%                set(p2,'color','b','linestyle','-')
%            
%            name = sprintf('%s %s Case %d', city, model, i);
%            title(name);
%         end


%     NetMeter
        model = 'Net Meter';
        addpath ./LA/NetMeter

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        subplot(3,3,2);
%         P  = get(ax,'pos');    % Get the position.
%         delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
%         legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
%         set(ax,'pos',P)       % Recover the position.
        rmpath ./LA/NetMeter  % remove path

%     WholesaleComp
        model = 'WholesaleComp';
        addpath ./LA/WholesaleComp

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        subplot(3,3,3);
%         P  = get(ax,'pos');    % Get the position.
%         delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
%         legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
%         set(ax,'pos',P)       % Recover the position.
        rmpath ./LA/WholesaleComp  % remove path

%% Boulder
%     DemandCharge
        model = 'Demand Charge';
        addpath ./Boulder/DemandCharge

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        ax = subplot(3,3,1);
        P  = get(ax,'pos');    % Get the position.
        delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
        legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
        set(ax,'pos',P)       % Recover the position.
        rmpath ./Boulder/DemandCharge% remove path
       


        
%         for i = 1:10
%             figure
%            [ax,p1,p2] = plotyy(yr, rc(i,:), yr, rp(i,:));
%                set(p1,'color','m','linestyle','-')
%                set(p2,'color','b','linestyle','-')
%            
%            name = sprintf('%s %s Case %d', city, model, i);
%            title(name);
%         end


%     NetMeter
        model = 'Net Meter';
        addpath ./Boulder/NetMeter

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        subplot(3,3,2);
%         P  = get(ax,'pos');    % Get the position.
%         delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
%         legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
%         set(ax,'pos',P)       % Recover the position.
        rmpath ./Boulder/NetMeter  % remove path

%     WholesaleComp
        model = 'WholesaleComp';
        addpath ./Boulder/WholesaleComp

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        subplot(3,3,3);
%         P  = get(ax,'pos');    % Get the position.
%         delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
%         legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
%         set(ax,'pos',P)       % Recover the position.
        rmpath ./Boulder/WholesaleComp  % remove path

%% Sydney
%     DemandCharge
        model = 'Demand Charge';
        addpath ./Sydney/DemandCharge

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        ax = subplot(3,3,1);
        P  = get(ax,'pos');    % Get the position.
        delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
        legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
        set(ax,'pos',P)       % Recover the position.
        rmpath ./Sydney/DemandCharge% remove path
       


        
%         for i = 1:10
%             figure
%            [ax,p1,p2] = plotyy(yr, rc(i,:), yr, rp(i,:));
%                set(p1,'color','m','linestyle','-')
%                set(p2,'color','b','linestyle','-')
%            
%            name = sprintf('%s %s Case %d', city, model, i);
%            title(name);
%         end


%     NetMeter
        model = 'Net Meter';
        addpath ./Sydney/NetMeter

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        subplot(3,3,2);
%         P  = get(ax,'pos');    % Get the position.
%         delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
%         legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
%         set(ax,'pos',P)       % Recover the position.
        rmpath ./Sydney/NetMeter  % remove path

%     WholesaleComp
        model = 'WholesaleComp';
        addpath ./Sydney/WholesaleComp

        rp = dlmread('1_RetailPrice.csv' ,',','B2..AK513'); % retail price
        rc = dlmread('2_RegularCust.csv' ,',','B2..AK513'); % reg. customers
        pv = dlmread('3_Cust_With_PV.csv',',','B2..AK513'); % pv customers
        de = dlmread('4_Defector.csv'    ,',','B2..AK513'); % defectors

        
        subplot(3,3,3);
%         P  = get(ax,'pos');    % Get the position.
%         delete(ax)              % Delete the subplot axes

        x = 1:size(rc,1); % plotting vector
        hold on

        [ax,Hrc,Hrp] = plotyy(x, rc(:,end) - rc(:,1), x, rp(:,end) - rp(:,1));

        Hpv = plot(ax(1), x, pv(:,end) - pv(:,1),'r');
        Hde = plot(ax(1), x, de(:,end) - de(:,1),'g');
        
        xlabel('case')
        xlim(ax(1),[0, size(rc,1)])
        xlim(ax(2),[0, size(rc,1)])
        ylim(ax(1), [min(rc(:,end) - rc(:,1)) max(max( pv(:,end) - pv(:,1), de(:,end) - de(:,1) ))])
%         legend( [Hrc, Hrp, Hpv, Hde], 'reg cust', 'retail price', 'PV cust', 'defectors','Location','NorthWest')
        name = sprintf('%s %s', city, model);
        title(name);
        
%         set(ax,'pos',P)       % Recover the position.
        rmpath ./Sydney/WholesaleComp  % remove path