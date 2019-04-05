%% BUNDLE INTO FUNCTIONS
a = [zeros(6,1),linspace(0,1,6)',linspace(1,0,6)'];
b = [linspace(0,1,6)', linspace(1,0,6)', zeros(6,1)];
tmp = [a;b(2:end,:)];

fig = figure(1);
clf();
Subjects = 1:10;
WindowSizes = 100:100:1000;
Z = ismember(ECoG_allitems_final.subject, Subjects);
Z = Z & ECoG_allitems_final.cvholdout == 1;
ax = gobjects(3,1);
CircleScalingFactor = 1000;
Frames = repmat(struct('cdata',[],'colormap',[]), numel(WindowSizes), 1);
for i = 1:numel(WindowSizes)
    z = ECoG_allitems_final.WindowSize == WindowSizes(i);
    z = Z & z;
    %z = z & ECoG_allitems_final.cvholdout == 1;
    xyz = cell2mat(ECoG_allitems_final.coords(z));
    Uz = cell2mat(ECoG_allitems_final.Uz(z));
    
    z = ismember(coords_tbl.Subject, Subjects) & coords_tbl.WindowSize == WindowSizes(i);
    ref = [coords_tbl.x(z),coords_tbl.y(z),coords_tbl.z(z)];
    for j = 1:3
        if ~size(xyz,1)
            continue
        end
        ax(j,i) = subplot(1,3,j);
        M = PlotProportionPositive(xyz, ref, Uz(:,j), downsample, CircleScalingFactor);
        title(sprintf('Window Size %d\nDim %d', WindowSizes(i),j));
    end
    set(ax(isgraphics(ax)), 'clim', [0 1]);
    set(ax(isgraphics(ax)), 'Colormap', tmp);
    xlim([0,15]);
    ylim([0,25]);
    linkaxes(ax(isgraphics(ax)))
    x = ax(3).Position;
    colorbar('Position', [x(1)+0.24,x(2),x(4)/20,x(4)])
    Frames(i) = getframe(fig);
end

[h, w, p] = size(Frames(1).cdata);  % use 1st frame to get dimensions
hf = figure(2); 
% resize figure based on frame's w x h, and place at (150, 150)
set(hf, 'position', [0 0 w h]);
axis off
movie(hf,Frames,1,2);
%mplay(Frames)

v = VideoWriter('test.avi', 'Motion JPEG AVI');
v.FrameRate = 1;
open(v);
writeVideo(v, [Frames;repmat(Frames(end),5,1)])
close(v);


%%
figure(2);
clf();
maxSize = 1000;
x = 100:100:maxSize;
ax = gobjects(2,5);
for i = 1:numel(x)
    z = ECoG_allitems_final.WindowSize == maxSize;
    xyz = cell2mat(ECoG_allitems_final.coords(z));
    ms = cell2mat(ECoG_allitems_final.ms(z));
    xyz = xyz(ms==x(i),:);
    Uz = cell2mat(ECoG_allitems_final.Uz(z));
    Uz = Uz(ms==x(i),:);
    ax(i) = subplot(2,5,i);
    M = PlotProportionPositive(xyz, Uz(:,1), downsample);
    title(sprintf('Window %d: ms %d', maxSize, x(i)));
end
set(ax, 'clim', [-1 1])

figure(3);
clf();
maxSize = 1000;
x = 100:100:maxSize;
ax = gobjects(2,5);
for i = 1:numel(x)
    z = ECoG_allitems_final.WindowSize == maxSize;
    xyz = cell2mat(ECoG_allitems_final.coords(z));
    ms = cell2mat(ECoG_allitems_final.ms(z));
    xyz = xyz(ms<=x(i),:);
    Uz = cell2mat(ECoG_allitems_final.Uz(z));
    Uz = Uz(ms<=x(i),:);
    ax(i) = subplot(2,5,i);
    M = PlotProportionPositive(xyz, Uz(:,1), downsample);
    title(sprintf('Window %d: ms %d', maxSize, x(i)));
end
set(ax, 'clim', [-1 1])


% Simple Count
% figure(1);
% x = 100:100:1000;
% for i = 1:10
%     z = ECoG_allitems_final.WindowSize == x(i);
%     %z = z & ECoG_allitems_final.cvholdout == 1;
%     xyz = cell2mat(ECoG_allitems_final.coords(z));
%     subplot(2,5,i)
%     M = PlotCoordOverlap(xyz, downsample);
%     title(sprintf('Window Size %d', x(i)));
% end
%
% figure(2);
% clf();
% maxSize = 800;
% x = 100:100:maxSize;
% for i = 1:numel(x)
%     z = ECoG_allitems_final.WindowSize == maxSize;
%     xyz = cell2mat(ECoG_allitems_final.coords(z));
%     ms = cell2mat(ECoG_allitems_final.ms(z));
%     xyz = xyz(ms==x(i),:);
%     subplot(2,5,i)
%     M = PlotCoordOverlap(xyz, downsample);
%     title(sprintf('Window %d: ms %d', maxSize, x(i)));
% end