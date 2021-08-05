function displayBlocking()

    hFigureHandle = generateFigure(11,3.8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];

    % file path
    cName = 'sax_example.wav';
 
    [t,x,xb,wb] = getData([cAudioPath cName]);
    

    subplot(211),
    plot(t,x)
    hold on;
    for (n = 1:size(wb,1))
        plot(t(wb(n,:)~=0),wb(n,wb(n,:)~=0),'Color',[234/256 170/256 0])
    end
    hold off;
    axis([t(1) t(end) -1.05 1.05])
    ylabel('$x(t)$')
    set(gca,'XTickLabel',[]);
    
    for (n = 1:size(wb,1))
        subplot(8,1,4+n)
        plot(t,xb(n,:))
        axis([t(1) t(end) -1 1])
        set(gca,'XTickLabel',[]);
        set(gca,'YTickLabel',[]);
    end
        
    xlabel('$t / \mathrm{s}$')

    printFigure(hFigureHandle, cOutputFilePath)
end

function [t,x,xb,wb] = getData(cAudioPath)
    % read sample data
    [x,fs]  = audioread(cAudioPath, [4501 4500+5*2048]);
    t       = linspace(0,(length(x)-1)/fs,length(x));

    % blocking
    K = 4096;
    H = 2048;
    numBlocks = length(x)/H-1; %this is only for integer division
    xb = zeros (numBlocks, length(x));
    
    w = hann(K);
    wb = zeros(size(xb));

    for (n = 1:numBlocks)
        i_s = (n-1)*H+1;
        i_e = i_s + K-1;
        xb(n,i_s:i_e) = x(i_s:i_e);
        wb(n,i_s:i_e) = w;
    end
end