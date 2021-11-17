function plotDtwFeatures ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,6);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName = 'originals_splanky.mp3';

    [tv1, tv2,Dpc, Drms, Dmfcc,ppc, prms, pmfcc] = getData(cAudioPath, cName);

    ax = subplot(131);
    imagesc(tv2,tv1,nonlinearity(Dpc,2))
    c=colormap(ax,'jet');
    colormap(ax,c);
    xlabel('$t_2 / \mathrm{s}$')
    box on;
    hold on; plot(tv2(ppc(:,2)),tv1(ppc(:,1)),'Color',[0 0 0]); hold off
    ylabel('$t_1 / \mathrm{s}$')

    ax = subplot(132);
    imagesc(tv2,tv1,nonlinearity(Drms,2))
    c=colormap(ax,'jet');
    colormap(ax,c);
    xlabel('$t_2 / \mathrm{s}$')
    box on;
    hold on; plot(tv2(prms(:,2)),tv1(prms(:,1)),'Color',[0 0 0]); hold off
    ylabel('$t_1 / \mathrm{s}$')
    
    ax = subplot(133);
    imagesc(tv2,tv1,nonlinearity(Dmfcc,2))
    c=colormap(ax,'jet');
    colormap(ax,c);
    xlabel('$t_2 / \mathrm{s}$')
    box on;
    hold on; plot(tv2(pmfcc(:,2)),tv1(pmfcc(:,1)),'Color',[0 0 0]); hold off
    ylabel('$t_1 / \mathrm{s}$')

    printFigure(hFigureHandle, cOutputPath)
end

function [tv1, tv2,Dpc, Drms, Dmfcc,ppc, prms, pmfcc] = getData(cAudioPath, cName)

    cFeatureNames = char('SpectralPitchChroma','TimeRms','SpectralMfccs');%char('TimeAcfCoeff');

    iBlockLength = 65536; %65536
    iHopLength = 4096; %4096
    
    % read sample data
    [x,fs]  = audioread([cAudioPath '/' cName]);
    
    % strip zeros
    x1 = ToolStripZeros(x(:,1)/max(abs(x(:,1))));
    x2 = ToolStripZeros(x(:,2)/max(abs(x(:,2))));
    
    [vpc1, tv1] = ComputeFeature (deblank(cFeatureNames(1,:)), x1, fs, [], iBlockLength, iHopLength);
    [vrms1, trms] = ComputeFeature (deblank(cFeatureNames(2,:)), x1, fs, [], iBlockLength, iHopLength);
    vrms1 = 10.^(vrms1*.05);
    vrms1 = vrms1/max(max(vrms1));
    [vmfcc1, tmfcc] = ComputeFeature (deblank(cFeatureNames(3,:)), x1, fs, [], iBlockLength, iHopLength);
    vmfcc1 = 10.^(vmfcc1*.05);
    vmfcc1 = vmfcc1/max(max(vmfcc1));
    
    [vpc2, tv2] = ComputeFeature (deblank(cFeatureNames(1,:)), x2, fs, [], iBlockLength, iHopLength);
    [vrms2, trms] = ComputeFeature (deblank(cFeatureNames(2,:)), x2, fs, [], iBlockLength, iHopLength);
    vrms2 = 10.^(vrms2*.05);
    vrms2 = vrms2/max(max(vrms2));
    [vmfcc2, tmfcc] = ComputeFeature (deblank(cFeatureNames(3,:)), x2, fs, [], iBlockLength, iHopLength);
    vmfcc2 = 10.^(vmfcc2*.05);
    vmfcc2 = vmfcc2/max(max(vmfcc2));

    Dpc = zeros(length(tv1),length(tv2));
    Drms = zeros(length(tv1),length(tv2));
    Dmfcc = zeros(length(tv1),length(tv2));
    for (i=1:length(tv1))
        Dpc(i,:)  = sqrt(sum((repmat(vpc1(:,i),1,length(tv2))-vpc2).^2));
        Drms(i,:)  = sqrt(sum((repmat(vrms1(:,i),1,length(tv2))-vrms2).^2));
        Dmfcc(i,:)  = sqrt(sum((repmat(vmfcc1(:,i),1,length(tv2))-vmfcc2).^2));
    end
  
    Dpc = normalize(Dpc);
    Drms = normalize(Drms);
    Dmfcc = normalize(Dmfcc);
    
    [ppc, C]      = ToolSimpleDtw(Dpc);    
    [prms, C]     = ToolSimpleDtw(Drms);    
    [pmfcc, C]    = ToolSimpleDtw(Dmfcc);    

end

function [D] = nonlinearity(D, scale)
    if nargin < 2
        scale = 1;
    end
    D = normalize(D)*scale;
    D = tanh(D-scale/8);
end
function [D] = normalize(D)
    D = D-min(min(D));
    D = D/max(max(D));
end

function [x] = ToolStripZeros(x)
    xs = cumsum(abs(x));
    x = x(find(xs,1,'first'):end);
    xs = cumsum(flipud(abs(x)));
    x = x(1:end-find(xs,1,'first')+2);
end