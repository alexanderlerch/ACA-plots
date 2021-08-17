function plotPca()

    hFigureHandle = generateFigure(13.12,7);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate sample data
    [x, pc] = generateSampleData();

    fig(1) = subplot(121);
    scatter(x(:,1),x(:,2),2,'k');
    set(gca,'XAxisLocation','origin','YAxisLocation','origin');
    set(gca,'XTickLabel',[],'YTickLabel',[]);
    axis square;
    axis([-4 4 -4 4]);
    box('on');
    grid('on');
    xlabel('$x_1$')
    ylabel('$x_2$')
 
    
    fig(2) = subplot(122);
    scatter(x(:,1),x(:,2),2,'k');
    set(gca,'XAxisLocation','origin','YAxisLocation','origin');
    set(gca,'XTickLabel',[],'YTickLabel',[]);
    axis square;
    axis([-4 4 -4 4]);
    box('on');
    grid('on');
    xlabel('$x_1$')
    ylabel('$x_2$')
    hold on;
    p_1 = linspace(-4, 4,100);
    p_2 = -p_1;
    plot(p_1,p_1,'Color',[234/256 170/256 0]);
    plot(p_1,p_2,'Color',[234/256 170/256 0]);
    text (3.3,3,'$p_1$','Color',[234/256 170/256 0]);
    text (-3,3.3,'$p_2$','Color',[234/256 170/256 0]);

    printFigure(hFigureHandle, cOutputFilePath)
end

function [x, pc] = generateSampleData ()

    iNum    = 512;
    rng(12);
    x(1,:)  = randn(1,iNum)-.5;
    x(2,:)  = 3*x(1,:)+(randn(1,iNum));

    for (i = 1:2)
        x(i,:) = (x(i,:)-mean(x(i,:)))./std(x(i,:));
    end
    x = x';
    [pc,a,b] = ToolPca(x);
end