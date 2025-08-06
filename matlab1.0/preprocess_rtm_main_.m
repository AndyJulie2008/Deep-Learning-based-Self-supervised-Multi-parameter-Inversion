clear all
close all
clc
format short
%------------------ colorbar setting----------------------------
Ncolor=64;
lenwhite=0;
indexcolor=zeros(Ncolor*3/2-lenwhite/2,1);
for i=1:Ncolor*1.5-lenwhite/2
    indexcolor(i)=i/(Ncolor*1.5-lenwhite/2);
end
mycolor=zeros(Ncolor*3,3);
mycolor(1:Ncolor*2,1)=1;
mycolor(1+Ncolor:Ncolor*3,3)=1;
mycolor(Ncolor*1.5-lenwhite/2:Ncolor*1.5+lenwhite/2,2)=1;
mycolor(1:Ncolor*1.5-lenwhite/2,2)=indexcolor;
mycolor(1:Ncolor*1.5-lenwhite/2,3)=indexcolor;
mycolor(1+Ncolor*1.5+lenwhite/2:Ncolor*3,1)=flipud(indexcolor);
mycolor(1+Ncolor*1.5+lenwhite/2:Ncolor*3,2)=flipud(indexcolor);
mycolor=flipud(mycolor);
cvalue = 0.005;
%------------------ colorbar setting----------------------------

%---------------------------------------------------------
%  0 parameter setup
%---------------------------------------------------------
%input data info
nx = 192*3;
nz = 192;

%shuffle the list of files
input_directory = 'LSRTM';%pysit result is here
output_directory = 'train_dataset';
system(['mkdir ' output_directory]);
Files=dir([input_directory '/' 'CNN_train*.dat']); %file name

for k=1:length(Files)
    FileNames=Files(k).name;
    
    len = length(FileNames);
    name = ['CNN_train_dataset' FileNames(10:length(FileNames))];
    
    
    if exist([output_directory '/' name], 'file') ~= 0 %if file exists do not repeatedly create
        disp([num2str(k) ' EXISTS===' FileNames])
        continue;
    else
        disp([num2str(k) ' ' FileNames])
        disp(name)
    end
    
    
    %One purpose: replace rtm image (calculated by pysit) by preprocessed
    %             image
    v = dlmread([input_directory '/' FileNames]);
    v1 = v(1:nz*nx);
    v1 = reshape(v1,nz,nx);
    v1 = preprocess_rtm(v1);
    v1 = reshape(v1,nz*nx,1);
    v(1:nz*nx) = v1;
    
    % decimal output
    disp(name)
    disp(size(v)) 
    fid=fopen([output_directory '/' name],'wt');
    fprintf(fid,'%17.8f',v);
    fclose(fid);

    % binary output
%     fid = fopen(name,'w');
%     fwrite(fid,train_data,'float32');
%     fclose(fid);
end



%---------------------------------------------------------
%           figure 2   plot Pdata
%---------------------------------------------------------
Files=dir([output_directory '/' 'CNN_train_dataset*.dat']); %file name
figure(1)
for k=1:length(Files)
    name = [output_directory '/' Files(k).name];
    v = dlmread(name);
    disp(name);
    v1 = v(1:nz*nx);
    v2 = v(1+nz*nx:nz*nx*2);
    v3 = v(1+nz*nx*2:nz*nx*3);
    v4 = v(1+nz*nx*3:nz*nx*4);%This should be true model!!!

    v1 = reshape(v1,nz,nx);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For plot only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    v2 = reshape(v2,nz,nx);
    v3 = reshape(v3,nz,nx);
    v4 = reshape(v4,nz,nx);

    
    subplot(2,2,1)
    cvalue = max(max(v1));
    imagesc(v1);caxis([-cvalue cvalue]);colormap('gray');
    title('RTM')
    subplot(2,2,2) 
    cvalue = max(max(v2));
    imagesc(v2);caxis([-cvalue cvalue]);colormap('gray');
    title('Reflectivity')

    subplot(2,2,3)
    cvalue = max(max(v3));
    imagesc(v3);colormap(mycolor);caxis([-cvalue cvalue]);colormap('gray');
    title('Smooth model')

    subplot(2,2,4)
    cvalue = max(max(v4));
    imagesc(v4);caxis([-cvalue cvalue]);
    title('True model')
    drawnow;
    pause(0.1);
end

