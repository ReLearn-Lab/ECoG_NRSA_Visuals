function Frames = plot_windows_as_movie(R,C,varargin)
% PLOT_WINDOWS_AS_MOVIE Visualize NRSA solutions over opening time windows.
%
% ECoG data is sampled from inter-cranial grid electrodes implanted on the
% cortical surface in patients perparing for neurosurgery. It has high
% temporal resolution and precise spatial resolution. Each electrode exists
% at a certain point in space on a subject's brain.
%
% Data from each subject were modeled multiple times using network
% representational similarity analysis (NRSA). Each time the data is
% modeled, more time points are included. This is indicated by the
% WindowSize.
%
% NRSA is trying to predict 3-dimensional coordinates in semantic space for
% each item observed during the experiment based on the functional data.
% Each model is fit to data from all electrodes in one subject. This will
% include multiple points in time, and which points is contrained by the
% WindowSize. All windows open at the beginning of the trial and extend
% some distance into the trial.
%
% This function will produce a frame in the movie for each WindowSize. All
% subjects and points in time are aggregated into each datapoint. The size
% of each point corresponds to the number of subjects and points in time
% that a certain electrode was assigned non-zero weights. The color of each
% point indicates the proportion of weights that are positive. Points that
% are always positive are red, and points that are always negative are
% blue.
%
% ARGUMENTS
% ---------
% R: The full table of results (from ECoG_allitems_final.mat)
% C: The full table of all coordiates (loaded with get_all_possible_coords)
% downsample: The resolution of the grid that points should be plotted on.
%   For example, downsample 4 would ensure that there are 4 mm between grid
%   points.
% subjects: The set of subjects that should be aggregated in the figure.
% windowsizes: The set of window sizes generate frames for.
% circlescale: A constant for scaling the size of the points in the figure.
%
% Chris Cox <chriscox@lsu.edu> 04/04/2019

    p = inputParser();
    addRequired(p, 'R', @istable);
    addRequired(p, 'C', @istable);
    addParameter(p, 'downsample', 4, @isscalar);
    addParameter(p, 'subjects', 1:10, @subject_validation);
    addParameter(p, 'windowsizes', 100:100:1000, @window_validation);
    addParameter(p, 'circlescale', 500, @isscalar);
    parse(p, R, C, varargin{:});

    a = [zeros(6,1),linspace(0,1,6)',linspace(1,0,6)'];
    b = [linspace(0,1,6)', linspace(1,0,6)', zeros(6,1)];
    tmp = [a;b(2:end,:)];

    fig = figure;
    clf();

    Z = ismember(R.subject, p.Results.subjects);
    Z = Z & R.cvholdout == 1;
    ax = gobjects(3,1);

    Frames = repmat(struct('cdata',[],'colormap',[]), numel(p.Results.windowsizes), 1);
    for i = 1:numel(p.Results.windowsizes)
        z = R.WindowSize == p.Results.windowsizes(i);
        z = Z & z;
        %z = z & R.cvholdout == 1;
        xyz = cell2mat(R.coords(z));
        Uz = cell2mat(R.Uz(z));

        z = ismember(C.Subject, p.Results.subjects) & C.WindowSize == p.Results.windowsizes(i);
        ref = [C.x(z),C.y(z),C.z(z)];
        for j = 1:3
            if ~size(xyz,1)
                continue
            end
            ax(j,i) = subplot(1,3,j);
            PlotProportionPositive(xyz, ref, Uz(:,j), p.Results.downsample, p.Results.circlescale);
            title(sprintf('Window Size %d\nDim %d', p.Results.windowsizes(i),j));
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

    [h, w, ~] = size(Frames(1).cdata);  % use 1st frame to get dimensions
    hf = figure(2); 
    % resize figure based on frame's w x h, and place at (150, 150)
    set(hf, 'position', [0 0 w h]);
    axis off
%     movie(hf,Frames,1,2);
%     %mplay(Frames)
end


function b = subject_validation(x)
    b = all(ismember(x, 1:10));
end

function b = window_validation(x)
    b = all(ismember(x, [50,100:100:1000]));
end