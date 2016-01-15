
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
            
%% growth from 2015 to 2030
fprintf('SY_DC')
SY_DC_del = (SY_DC_rp(:,15) - SY_DC_rp(:,1))./SY_DC_rp(:,1);
minimum = min(SY_DC_del)
avg = mean(SY_DC_del)
base = SY_DC_del(897) % base case growth

fprintf('SY_NM')
SY_NM_del = (SY_NM_rp(:,15) - SY_NM_rp(:,1))./SY_NM_rp(:,1);
minimum = min(SY_NM_del)
avg = mean(SY_NM_del)
base = SY_NM_del(897) % base case growth

fprintf('SY_WC')
SY_WC_del = (SY_WC_rp(:,15) - SY_WC_rp(:,1))./SY_WC_rp(:,1);
minimum = min(SY_WC_del)
avg = mean(SY_WC_del)
base = SY_WC_del(897) % base case growth


%% growth from 2015 to 2040
fprintf('SY_DC')
SY_DC_del = (SY_DC_rp(:,25) - SY_DC_rp(:,1))./SY_DC_rp(:,1);
minimum = min(SY_DC_del)
avg = mean(SY_DC_del)
base = SY_DC_del(897) % base case growth

fprintf('SY_NM')
SY_NM_del = (SY_NM_rp(:,25) - SY_NM_rp(:,1))./SY_NM_rp(:,1);
minimum = min(SY_NM_del)
avg = mean(SY_NM_del)
base = SY_NM_del(897) % base case growth

fprintf('SY_WC')
SY_WC_del = (SY_WC_rp(:,25) - SY_WC_rp(:,1))./SY_WC_rp(:,1);
minimum = min(SY_WC_del)
avg = mean(SY_WC_del)
base = SY_WC_del(897) % base case growth




% 
% fprintf('BO_DC')
% BO_DC_del = (BO_DC_rp(:,15) - BO_DC_rp(:,1))./BO_DC_rp(:,1);
% minimum = min(BO_DC_del)
% avg = mean(BO_DC_del)
% base = BO_DC_del(897) % base case growth
% 
% fprintf('BO_NM')
% BO_NM_del = (BO_NM_rp(:,15) - BO_NM_rp(:,1))./BO_NM_rp(:,1);
% minimum = min(BO_NM_del)
% avg = mean(BO_NM_del)
% base = BO_NM_del(897) % base case growth
% 
% fprintf('BO_WC')
% BO_WC_del = (BO_WC_rp(:,15) - BO_WC_rp(:,1))./BO_WC_rp(:,1);
% minimum = min(BO_WC_del)
% avg = mean(BO_WC_del)
% base = BO_WC_del(897) % base case growth
% 
% 
% 
% fprintf('LA_DC')
% LA_DC_del = (LA_DC_rp(:,15) - LA_DC_rp(:,1))./LA_DC_rp(:,1);
% minimum = min(LA_DC_del)
% avg = mean(LA_DC_del)
% base = LA_DC_del(897) % base case growth
% 
% fprintf('LA_NM')
% LA_NM_del = (LA_NM_rp(:,15) - LA_NM_rp(:,1))./LA_NM_rp(:,1);
% minimum = min(LA_NM_del)
% avg = mean(LA_NM_del)
% base = LA_NM_del(897) % base case growth
% 
% fprintf('LA_WC')
% LA_WC_del = (LA_WC_rp(:,15) - LA_WC_rp(:,1))./LA_WC_rp(:,1);
% minimum = min(LA_WC_del)
% avg = mean(LA_WC_del)
% base = LA_WC_del(897) % base case growth