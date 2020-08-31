clc
clear all;
close all;
%%
TempDisp=0.099851;
TempVel=0;
TempAcc=0;
kk=0;
DoF=importfile2('6DoF_1.dat',1,2004);
time = linspace(0.01,20,2000);  
time=time';
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
% converting string to double
dspl=str2double(dspl);
for kk=199:length(time)
h3(kk+4,1)=TempDisp; %(displacement_to_openfoam); 
fid=fopen('6DoF_2.dat','w');
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
     
disp 'step 4: Reading force for structural solution of next time step and calculating displacement'
 %% Read the force from openfoam
%Time integration scheme
 TempDisp_previous=TempDisp;
TempVel_previous=TempVel;
TempAcc_previous=TempAcc;
a=load('forces.txt');
force=a(:,2);
force_sloshing=(force(end,:));
[TempDisp,TempVel,TempAcc,kk]=StrModel(force_sloshing,TempDisp_previous,TempVel_previous,TempAcc_previous,kk)
delete 'forces.txt'
end





