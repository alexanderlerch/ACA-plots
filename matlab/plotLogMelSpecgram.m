function plotLogMelSpecgram  ()

    % check for dependency
    if(exist('ComputeMelSpectrogram') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    % generate new figure
    hFigureHandle = generateFigure(13.12,8);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';

    % read audio and get plot data
    [t,x,tw,f,X] = getData ([cAudioPath,'/',cName]);

    % set the strings of the axis labels
    cXLabel = '$t / \mathrm{s}$';
    cYLabel1 = '$x(t)$';
    cYLabel2 = '$f / \mathrm{kHz}$';

    % plot 
    subplot(211), plot(t,x)
    ylabel(cYLabel1)
    axis([t(1) t(end) -max(abs(x)) max(abs(x))])
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})
    set(gca,'XTick',[0 5 10 15 20 25])

    subplot(212), imagesc(t,[],X)
    axis xy;
    set(gca,'YTickLabel', round(f([21 41,61,81,101,121]))/1000);
    set(gca,'XTick',[0 5 10 15 20 25])
    xlabel(cXLabel)
    ylabel(cYLabel2)

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [t,x,tw,fm,M] = getData (cInputFilePath)

    iFFTLength  = 4096;
    [x, fs]     = audioread(cInputFilePath);
    t           = linspace(0,length(x)/fs,length(x));

    iNumMelBands= 128;
    [M, fm, tw] = ComputeMelSpectrogram (x, fs, 'true', hanning(iFFTLength),iFFTLength, iFFTLength*.5, iNumMelBands,10000);
end
