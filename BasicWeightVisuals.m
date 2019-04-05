% GitRoot = fullfile("C:",getenv("HOMEPATH"),"Documents","Github");
% addpath(fullfile(GitRoot,'WISC_MVPA\src'));
% load('ECoG_allitems_final.mat')
% ECoG_allitems_final = add_ms_to_results(ECoG_allitems_final);
% save('ECoG_allitems_final_ms.mat', 'ECoG_allitems_final');
addpath('./lib')
load('./data/ECoG_allitems_final_ms.mat')
% [metadata, coords] = load_all_metadata();
% coords_tbl = get_all_possible_coords(coords);
% save('coords_tbl.mat', 'coords_tbl');
load('./data/coords_tbl.mat', 'coords_tbl');

%% Plot All Weights Within Each Window
% These figures will have a particular "downsample" and "circle scale"
% value, and contain all "samples" within each WindowSize.
%
% Naming conventions should be:
% S01_grid4_scale500_allsamples.png
%  or
% group_grid4_scale500_allsamples.png
plot_windows_as_panels(ECoG_allitems_final, coords_tbl, ...
    'downsample', 4, ...
    'subjects', 1:10, ...
    'windowsizes', 100:100:1000, ...
    'circlescale', 500);

%%
% 
% Frames = plot_windows_as_movie(ECoG_allitems_final, coords_tbl, ...
%     'downsample', 4, ...
%     'subjects', 1:10, ...
%     'windowsizes', 100:100:1000, ...
%     'circlescale', 500);
% 
% v = VideoWriter('test.avi', 'Motion JPEG AVI');
% v.FrameRate = 1;
% open(v);
% writeVideo(v, [Frames;repmat(Frames(end),5,1)])
% close(v);


