function M = PlotProportionPositive(xyz,ref,w,k,CircleScalingFactor)
% PLOTPROPORTIONPOSITIVE Generate 2D image plot showing where weights are
% positive. 
%
% The z-axis is ignored---coordinates are only considered in terms of
% anterior --> posterior and medial --> lateral.
%
% xyz : electrode coordinates
%   w : weights assigned to each coordinate
%   k : size of box kernel for crude spatial smoothing
    
    z = ismember(ref(:,1:2), xyz(:,1:2), 'rows');
    ref = ref(z,:);

    drop_right_hemisphere = false;
    xyz_a = adjust_coordinates(xyz, drop_right_hemisphere);
    ref_a = adjust_coordinates(ref, drop_right_hemisphere);
    xyz_a = xyz_a(:,1:2);
    ref_a = ref_a(:,1:2);
    
    % Spatial smooth using "box kernel" (Treat all coordinates within
    % square as same point).
    if k > 0
        xyz_ar = max(round( xyz_a ./ k ), 1);
        ref_ar = max(round( ref_a ./ k ), 1);
    end
    
    % Identify unique coords and aggregate weights as each.
    [xyz_aru,~,g] = unique(xyz_ar,'rows');
    props = splitapply(@mean, w>0, g);
    nnz = splitapply(@numel, w, g);
    
    [~,~,g] = unique(ref_ar,'rows');
    nnz_ref = splitapply(@numel, g, g);
    sz = (nnz ./ nnz_ref) .* CircleScalingFactor;
    idx = sub2ind(max(xyz_aru), xyz_aru(:,1), xyz_aru(:,2));
    M = nan(max(xyz_aru));
    M(idx) = props;

    % Plot
%     pcolor(M);
    scatter(xyz_aru(:,1), xyz_aru(:,2), sz, props, 'filled')
    xlabel('medial --> lateral');
    ylabel('posterior <-- anterior');
end