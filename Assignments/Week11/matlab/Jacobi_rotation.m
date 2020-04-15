function [ J, Lambda] = Jacobi_rotation( A )
    %Jacobi_rotation Compute the Jacobi rotation J such that
    %   J' * A * J = Lambda, a diagonal matrix.
    
    % Check if A is already diagonal
    if A( 2,1 ) == 0.0 
        J = eye( 2 );
        Lambda = A;
    else
        [ J, Lambda ] = eig( A );
        if sign( J(1,1) ) ~= sign( J(2,2) )
            % scale the second column by -1
            J(:,2) = - J(:,2);
        end
end