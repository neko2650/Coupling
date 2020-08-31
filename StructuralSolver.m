clc
clear all;
close all;
%%
[stat, cmdOut] = system('./gen6DoF.sh')
%%
TempDisp=0;
TempVel=0;
TempAcc=0;
kk=0;
%importing displacement file which needs to be edited
DoF=importfile2('6DoF.dat',1,2004);
% time sampling from 0 to 10 sec 
% time = linspace(0.01,20,2000);  
% time=time';
% splitting DoF into seven columns
h1=DoF(:,1);
h2 =DoF(:,2);
h3=DoF(:,3);
h4=DoF(:,4);
h5=DoF(:,5);
h6=DoF(:,6);
h7=DoF(:,7);
% considering displacement column
dspl= DoF(3:2002,3);
a=load('outputData.txt');
Disp=a(:,1);
% converting string to double
dspl=str2double(dspl);
%Displacement at t=0, TempDisp=1.2m
h3(3,1)=0;
h3(4,1)=0.00013499;
% h3(4,1)=;
%figure()
%hold on
% importing displacement file which needs to be edited
% time sampling from 0 to 10 sec 100 samples
for kk=1:200
% Suppplying dispalcement to OpenFoam
 % importing displacement file which needs to be edited
% Suppplying dispalcement to OpenFoam (here the 6DoF.dat file is to be edited and supplied to openfoam)
%displacement_to_openfoam= TempDisp +(dspl(kk,1));
TempDisp=Disp(kk+1,1)
h3(kk+4,1)=TempDisp; %(displacement_to_openfoam); 
fid=fopen('6DoF_1.dat','w');
A =[h1';h2';h3';h4';h5';h6';h7'];
fprintf(fid,'%s %s %s %s %s %s %s\n',A);
fclose(fid);

%     b=load('displacement.txt')
disp 'Displacement supplied'
disp 'step 1: Displacement sipplied to OpenFOAM'
% suppliying signal to OpenFOAM
fid=fopen('signalFromStructSolver.dat','w+');
fprintf(fid,'%d',1);	 
fclose(fid); 

disp 'step 2: Signal provided to OpenFoam' 

disp 'step 3: Waiting for OpenFoam'
waitForOpenFoam = 0;
    while waitForOpenFoam<1
        % Looking for signal file from OpenFoam
        filename='signalFromOpenFoam.dat';
        if exist(filename);
             test = importdata('signalFromOpenFoam.dat');  
             if test(1)==1;
                 waitForOpenFoam=1;
             end
        else
             % File does not exist.
        end     
    end
    delete 'signalFromOpenFoam.dat'
    delete 'forces.txt'
end





