function RMS_data = RMS_data(realu,estimu)
    [nz nx]=size(realu);
    RMS_data=(estimu-realu).^2;
    RMS_data =sqrt(sum(sum(RMS_data))/(nz*nx));

