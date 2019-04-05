function M = PlotCoordOverlap(xyz, k)
% All x coordinates are flipped in to the right hemisphere so that
% increasing values of X coorespond to medial --> lateral. This means
% medial coordinates are going to be on the left of the image map.
% All y coordinates are flipped so that increasing values of Y correspond
% to anterior --> posterior. This means that anterior coordinates are going
% to be on the top of the image map.
xyz_flip = xyz;
xyz_flip(xyz(:,1) < 0) = -xyz(xyz(:,1) < 0,1);
xyz_flip(:,2) = -xyz(:,2);

xyz_flipx_shift = bsxfun(@minus, xyz_flip, min(xyz_flip)) + 1;
if k > 0
    xyz_flipx_shift = max(round( xyz_flipx_shift ./ k ), 1);
end

[xyz_flipx_shift_u,~,ind] = unique(xyz_flipx_shift(:,1:2),'rows');

counts = histc(ind,1:max(ind));
idx = sub2ind(max(xyz_flipx_shift_u), xyz_flipx_shift_u(:,1), xyz_flipx_shift_u(:,2));
M = nan(max(xyz_flipx_shift_u));
M(idx) = counts;

pcolor(M);
xlabel('medial --> lateral');
ylabel('posterior <-- anterior');
