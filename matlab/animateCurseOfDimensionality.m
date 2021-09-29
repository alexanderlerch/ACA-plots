function animateCurseOfDimensionality()

    hFigureHandle = generateFigure(13.12,6);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/animation/' strrep(cName, 'animate', '')];
    %mkdir([cPath '/../graph/animation/']);

    plot(0:.1:100,zeros(1,1001))
    hold on;
    plot(0:.1:1, zeros(1,11),'Color', [234/256 170/256 0],'LineWidth',3)
    hold off;
    set(gca,'XTickLabel',[],'YTickLabel',[])
    set(gca,'XTick',-100:10:100,'YTick',-100:10:100)
    axis([ 0 100 -50 50])
    box on;
    printFigure(hFigureHandle, [cOutputPath '-00']); 
    
    %hFigureHandle = generateFigure(13.12,7);
    plot(0:.1:100,zeros(1,1001),'LineWidth', 0.5)
    hold on;
    area(0:.1:10, 10*ones(1,101),'FaceColor', [234/256 170/256 0],'EdgeColor', [1 1 1])
    hold off;
    set(gca,'XTickLabel',[],'YTickLabel',[])
    set(gca,'XTick',-100:10:100,'YTick',-100:10:100)
    axis([ 0 100 0 100])
    box on;
    printFigure(hFigureHandle, [cOutputPath '-01']); 
    
    %hFigureHandle = generateFigure(8,4);
    plot3(0:.1:100,zeros(1,1001),zeros(1,1001),'LineWidth', 0.5)
    hold on;
    ver = [1 1 0;
    0 1 0;
    0 1 1;
    1 1 1;
    0 0 1;
    1 0 1;
    1 0 0;
    0 0 0];
    %  Define the faces of the unit cubic
    fac = [1 2 3 4;
        4 3 5 6;
        6 7 8 5;
        1 2 8 7;
        6 7 1 4;
        2 3 5 8];
    cube = [ver(:,1),ver(:,2),ver(:,3)]*10000^(1/3);
    patch('Faces',fac,'Vertices',cube,'FaceColor',[234/256 170/256 0]);
    hold off;
    set(gca,'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[])
    set(gca,'XTick',0:10:100,'YTick',0:10:100,'ZTick',0:10:100)
    axis([ 0 100 0 100 0 100])
    grid on
    view(19,25)
    box on;
    
    printFigure(hFigureHandle, [cOutputPath '-02']); 
end