clc;
clear;

%% Read Dataset
Dta=xlsread('D:\TempGrid6m_VARS.xlsx');
%% x, y coordinate definition
[r, c]=size(Dta);
tmp_x=Dta(: , c-3);
tmp_y=Dta(: , c-2);

%% Making Weight Matrix
% w1: a symmetric spatial weight matrix (max(eig)=1)
% w: a row-stochastic spatial weight matrix, where s represents the
% adjacency matrix from delaunay triangles
% w3: diagonal matrix with i, i equal to 1/sqrt(sum of ith row)
[w1, w, w5]=xy2cont(tmp_x, tmp_y);

% finds the n nearest neighbors and constructs a spatial weight matrix
% Wm = make_nnw(tmp_x, tmp_y,8);

%% Dependent/Independent Var.
y=Dta(:,1);

%% percentage basis 
x=[ones(length(Dta),1) Dta(:, 16) Dta(:, 17) Dta(:,18) Dta(:,3) Dta(:,5) Dta(:, 6)...
  Dta(:,7) Dta(:,8)];

[n, k]=size(x);

%% Scale variables

% %% Printing Var
vnames = char('Temp1330', 'Constant', '%ShadeEarlyMorning', '%ShadeMorning', '%ShadeAfternoon', ...
      'TreePer', 'BuildingPer', 'RoadPer', 'PavementPer', 'PoolPer');

% %% OLS
res_ols=ols(y, x);
prt(res_ols, vnames);
 
%% global rmin rmax
info.rmin=-0.96;
info.rmax=0.96;

%% Run Spatial Regression Models
%% SEM : spatial error model
res4=sem(y,x,w,info);
prt(res4,vnames);
aic=(2*(res4.nvar) - 2*(res4.lik));
fprintf('SEM AIC = %9.4f \n',aic); 

%% GSM: general spatial model
res6=sac(y,x,w,w,info);
prt(res6,vnames);
aic=(2*(res6.nvar) - 2*(res6.lik));
fprintf('GSM AIC = %9.4f \n',aic); 
serr=std(res6.resid);