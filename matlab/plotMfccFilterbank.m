function plotMfccFilterbank ()
 
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    hFigureHandle = generateFigure(13.12,3.5);
 
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    [f, H] = getData ();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel = '$f$';
    cYLabel = '$H_\mathrm{MFCC}(f)$';


    semilogx(f,H)
    set(gca,'XTick', [])
    set(gca,'YTickLabels', [])
    xlabel(cXLabel)
    ylabel(cYLabel)
    axis([133 7000 0.001 0.016])
    
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [f,H] = getData ()
    fs          = 16000;
    iLength     = 16384;
    H           = ToolMfccFb(iLength, fs)';
    
    f           = linspace(0, fs/2, iLength);
end
