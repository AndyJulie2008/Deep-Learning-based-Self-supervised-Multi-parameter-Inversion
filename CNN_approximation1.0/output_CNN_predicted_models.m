% clear all
% close all
% clc
% format short
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
cvalue = 0.6;
%---------------------------------------------------------------

nz = 256;
nx = 256;
max_reflectivity = 10000;
max_image = 0.5;
max_vp = 5;
min_vp = 1.5;
max_vs = 2.8;
min_vs = 0.0;
max_rho = 1.2;
min_rho = 2.6;

input_vp_filename = sh_input_vp_filename;
input_vs_filename = sh_input_vs_filename;
input_rho_filename = sh_input_rho_filename;
input_vp_hor_filename = sh_input_vp_hor_filename;
input_vp_nmo_filename = sh_input_vp_nmo_filename;
output_vp_filename = sh_output_vp_filename;
output_vs_filename = sh_output_vs_filename;
output_rho_filename = sh_output_rho_filename;
output_vp_hor_filename = sh_output_vp_hor_filename;
output_vp_nmo_filename = sh_output_vp_nmo_filename;

vp_data = dlmread(input_vp_filename);
vs_data = dlmread(input_vs_filename);
rho_data = dlmread(input_rho_filename);
vp_hor_data = dlmread(input_vp_hor_filename);
vp_nmo_data = dlmread(input_vp_nmo_filename);

CNN_output_vp= vp_data(1+nz*nx*3:nz*nx*4)/1000;
CNN_output_vs= vs_data(1+nz*nx*3:nz*nx*4)/1000;
CNN_output_rho= rho_data(1+nz*nx*3:nz*nx*4)/1000;
CNN_output_vp_hor= vp_hor_data(1+nz*nx*3:nz*nx*4)/1000;
CNN_output_vp_nmo= vp_nmo_data(1+nz*nx*3:nz*nx*4)/1000;

CNN_output_vp = reshape(CNN_output_vp,nz,nx);
CNN_output_vs = reshape(CNN_output_vs,nz,nx);
CNN_output_rho = reshape(CNN_output_rho,nz,nx);
CNN_output_vp_hor = reshape(CNN_output_vp_hor,nz,nx);
CNN_output_vp_nmo = reshape(CNN_output_vp_nmo,nz,nx);

vp = reshape(CNN_output_vp,1,nz*nx);
fid=fopen([output_vp_filename '.dat'],'wt');
fprintf(fid,'%17.8f',vp);
fclose(fid);

vs = reshape(CNN_output_vs,1,nz*nx);
fid=fopen([output_vs_filename '.dat'],'wt');
fprintf(fid,'%17.8f',vs);
fclose(fid);

rho = reshape(CNN_output_rho,1,nz*nx);
fid=fopen([output_rho_filename '.dat'],'wt');
fprintf(fid,'%17.8f',rho);
fclose(fid);

vp_hor = reshape(CNN_output_vp_hor,1,nz*nx);
fid=fopen([output_vp_hor_filename '.dat'],'wt');
fprintf(fid,'%17.8f',vp_hor);
fclose(fid);

vp_nmo = reshape(CNN_output_vp_nmo,1,nz*nx);
fid=fopen([output_vp_nmo_filename '.dat'],'wt');
fprintf(fid,'%17.8f',vp_nmo);
fclose(fid);