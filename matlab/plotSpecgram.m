function plotSpecgram  ()

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
    subplot(221), 
    plot(t,x)
    ylabel(cYLabel1)
    axis([t(1) t(end) -max(abs(x)) max(abs(x))])
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})
    set(gca,'XTick',[0 5 10 15 20 25])

    subplot(223), 
    imagesc(t,f/1000,X)
    axis xy;
    set(gca,'XTick',[0 5 10 15 20 25])
    xlabel(cXLabel)
    ylabel(cYLabel2)

    subplot(122), 
    mesh(tw,f/1000,X)
    view(29,63)
    set(gca,'ZTickLabel',{})
    xlabel(cXLabel)
    ylabel(cYLabel2)

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [t,x,tw,f,X] = getData (cInputFilePath)

    iFFTLength = 4096;
    
    % read audio
    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));

    % compute spectrogram
    [X,f,tw] = spectrogram(x,hanning(iFFTLength),iFFTLength*.5,iFFTLength,fs);
    X       = abs(X);

    X       = 10*log10(abs((X(1:iFFTLength/16,:))));
    f       = f(1:iFFTLength/16,:);
end
