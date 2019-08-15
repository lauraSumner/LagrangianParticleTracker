%This code reads in the particle's coordinates from the position file which is outputted by OpenFOAM.
%The coordinates are stored and then analysed over time to extract the steady streaming velocity. and
%store the coordinates in an array . 

%change directory to the correct timestep
%once inside follow correct filepath (always the same once in the correct timestep directory)

%open the file and skip to line whihc contains first set of coordinates
clear all 
format long 

dt=1e-5; %timestep between output files

timesteps= 2000; %Add the number of folders you have
T=timesteps*dt;
time=linspace(0,T,timesteps);
%coordinateMatrix=zeros(200,3,199);
i=1;
p=1;
destination1='/PATHNAME/'; %replace pathname with the filepath up until the time-numbering (eg/ home/Documents/simulation/)
destination2= '/lagrangian/defaultCloud/';

%%This loop reads the OpenFOAM output files and imports the coordinates at
%%each timestep. It also removes the header, brackets etc and formats the
%%values into matlab variables for analysis.
for a= 1:timesteps
a
    %completes the filepath in order to read in each timesteps coordinates
    foldername=sprintf('%.12g',0+a*dt);
    filepath= [destination1, foldername,destination2, 'positions'];
    FID = fopen(filepath, 'r+');

for k=1:19
    array1=fgetl(FID);
end

 i=1;
while ischar(array1)
    
    array1=fgets(FID);
    store{i,1}=array1;
    i=i+1;
    
end 

   p=1;
for j=1:length(store)-5
    
   %remove the brackets
   newStore{p}={store{j}(2:end-9)};
   %convert to array of string coordinates and split into different cell
   %array elements 
   str=newStore{p};
   argh= cell2mat(str);
   argh2(p,:)=strsplit(argh);

   p=p+1;
end

[x,y]=size(argh2);
coordinateMatrix(1:x,1:y,a)=str2double(argh2);
fclose(FID);
clear store
end
%%This section loops throught the matrix of coordinates and extracts the
%%coordinates for each particle and conducts analysis over time.

count=1;
numberParticles=5000;

for x=1:numberParticles
    
    for b=1:timesteps-1
        
        xCoords(b)=coordinateMatrix(x,1,b);
        yCoords(b)=coordinateMatrix(x,2,b);
        
    end
    fullCoordsX(:,x)=xCoords;
    fullCoordsY(:,x)=yCoords;
    xCoords2(:,x)=xCoords(1:end);
    yCoords2(:,x)=yCoords(1:end);
    timePlot=time(1:end);
    
%Usually the time series will need some cut-off, probably because of
%transient behaviour at the start of the simulation. Change part11 and
%part12 below to capture the subset of the timeseries you desire.
    part11=1400;
    part12=50;
   
    xCoords1Part(:,x)=xCoords2(part12:part11,x);
    yCoords1Part(:,x)=yCoords2(part12:part11,x);
    shortTimePlot1=timePlot(part12:part11);
    
%Find the mid point of the oscillations of the flow, the gradient of the
%displacement of the centre point will give the steady streaming velocity. 

    filteredX(:,x)=smooth(shortTimePlot1,xCoords1Part(:,x),0.5,'rloess');
    filteredY(:,x)=smooth(shortTimePlot1,yCoords1Part(:,x),0.5,'rloess');
    PX=polyfit(shortTimePlot1',filteredX(1:end,x),1);
    PY=polyfit(shortTimePlot1',filteredY(1:end,x),1);
    filteredFitX(:,x)=PX(1)*shortTimePlot1' + PX(2);
    filteredFitY(:,x)=PY(1)*shortTimePlot1' + PY(2);
    steadyStreamX(x)=PX(1);
    steadyStreamY(x)=PY(1);
    
   
    
    x %just to see progress!
end
 
filenameWorkspace= [destination1, 'workspace.mat']
save(filenameWorkspace)



