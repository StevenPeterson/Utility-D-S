function NO_Limit_Plots

close all, clear, clc

%-------------------------------------------------------------------

single_sensi_effect = 1;    % plot percent change in 2050 output parameters due to single sensitivity variable

plot_all         = 0; % 1 == plot the difference of 2050 value minus 2015 value for all 2048  cases for each city and business model
plot_with_limit  = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each CITY with subplots for each
                      %  BUSINESS MODEL
plot_with_limit2 = 0; % 1 == plot runs 1:256, which have 'Use limit on ratio of PV to total households' = 1
                      %  3 figures, one for each BUSINESS MODEL with subplots for each
                      %  CITY                     
                     
plot_base_case   = 0; % 1 == plot run 1 for 9 models (3 cities X 3 business models)
    y_axis_normalized_2015 = 1; % 1 == normalize y axis to 2015 total households, 0 == y axis is absolute households
plot_2050        = 0; % 1 == plot 2050 values
plot_multi_year_bar = 0;

plot_percentage  = 0; % 1 == plot percentage changes in reg cust, PV cust, retail price NOT FINISHED
plot_single      = 0; % 1 == plot indivual case (set below)
save_figures     = 0; % save plots as PDFs



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

end % parent function