%% step 1
clear all
addpath('rastamat')

frameSize = 1024;
hopSize = 512;
nMels = 40;

dataPath = '../audio/';

fileNames = {'-Hand Clap' '-Pedal HH' '-Kick' '' 'Test' 'Test-Cajon Thump' 'Test-WaterglassHi'};

[a, fs] = audioread([dataPath 'clickTrack'  fileNames{5} '.wav']);
a = a(:, 1);

[~, M] = melfcc(a, fs, 'maxfreq', fs/4);


M = M(:, 1:2^(nextpow2(size(M, 2))-1));

figure(1)
subplot 311
imagesc(M);
axis xy
xlabel('T')
ylabel('F')



%% step 2
nBands = 10;
[c, cLen] = wavedec(M(1, :), nBands, 'db1');
for k=2:nMels
    c(k, :) = wavedec(M(k, :), nBands, 'db1');
end



%%
clear v
for m=1:nMels
    for k=1:nBands
        sig = c(m, cLen(k+1)+1:cLen(k+2));
        tmp = repmat(sig, 2^(nBands-k), 1);
        v(m, k, :) = tmp(:);
    end
end
subplot 312
imagesc(squeeze(v(39, :, :)))
axis xy
xlabel('T')
ylabel('R')


%%
vv = squeeze(mean(abs(v), 3));

subplot 313
imagesc(vv')
axis xy
xlabel('F')
ylabel('R')

