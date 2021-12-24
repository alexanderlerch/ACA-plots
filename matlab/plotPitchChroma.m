function plotPitchChroma  ()

    % check for dependency
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    % generate new figure
    hFigureHandle = generateFigure(12,6);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';

    % read audio and generate plot data
    [t,f,X,pclabel,pc,pcm] = getData ([cAudioPath,'/',cName]);

    % set the strings of the axis labels
    cXLabel = '$t / \mathrm{s}$';
    cYLabel1 = '$f / \mathrm{kHz}$';
    cYLabel2 = 'pitch class';
    
    % plot data
    subplot(2,10,1:9), imagesc(t,f/1000,X)
    axis xy;
    ylabel(cYLabel1)
    set(gca,'XTickLabel',[])

    subplot(2,10,11:19), imagesc(t,pclabel,pc)
    axis xy;
    set(gca,'YDir','normal','YTick',[0 2 4 6 8 10],'YTickLabel',{'C', 'D', 'E', 'F\#', 'G\#', 'A\#'})
    xlabel(cXLabel)
    ylabel(cYLabel2)

    % fix label that is weirdly outside of plot
    p = get(gca,'Position');
    set(gca,'Position',[p(1) p(2)+0.05 p(3) p(4)]);
    
    subplot(2,10,20)
    bar(pclabel,pcm,'k')
    view(90,-90)
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})
    axis([ -.5 11.5 0 1.1*max(pcm)])

    % fix label that is weirdly outside of plot
    p = get(gca,'Position');
    set(gca,'Position',[p(1) p(2)+0.05 p(3) p(4)]);

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [tw,f,X, pclabel, vpc,vpcm] = getData (cInputFilePath)

    iFFTLength = 4096;
    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));
    x       = x/max(abs(x));

    % fft
    [X,f,tw] = spectrogram(x,hanning(iFFTLength),iFFTLength*.5,iFFTLength,fs);
    X       = abs(X);

    % extract pitch chroma
    [vpc, tv] = ComputeFeature (deblank('SpectralPitchChroma'), x, fs);

    % avg pitch chroma
    vpcm = mean(vpc,2);

    X       = 10*log10(abs((X(1:iFFTLength/16,:))));
    f       = f(1:iFFTLength/16,:);

    pclabel = 0:11;
end
