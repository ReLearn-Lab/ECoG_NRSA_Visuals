function xyz_flipx_shift = adjust_coordinates(xyz, drop_right_hemisphere)
    isRight = xyz(:,1) > 0;
    
    % Make left hemisphere positive (medial --> lateral as x++)
    xyz_flip = [-xyz(:,1),xyz(:,2:3)];
    
    % Make all x coordinates positive (project to right hemisphere)
    if drop_right_hemisphere
        xyz_flip(isRight,:) = [];
    else
        % Project RH coords into LH
        xyz_flip(isRight,1) = -xyz_flip(isRight,1);
    end
    
    % Make posterior positive (anterior --> posterior as y++)
    xyz_flip(:,2) = -xyz_flip(:,2);
    
    % Set the minimum value on all axes to zero:
    % x = 0 ==> most medial
    % y = 0 ==> most anterior
    % z = 0 ==> most inferior
    xyz_flipx_shift = bsxfun(@minus, xyz_flip, min(xyz_flip)) + 1;
end

