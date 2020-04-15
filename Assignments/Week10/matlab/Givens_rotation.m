function G = Givens_rotation( x )
    %Givens_rotation Compute Givens rotation G so that G' * x = || x ||_2
    % e_0
    
    [ m, n ] = size( x );

    assert( m==2 && n==1, 'x must be 2 x 1' );
    
    normx = norm( x );
    
    gamma = x(1) / normx;
    sigma = x(2) / normx;
    
    G = [ (gamma) (-sigma)
          (sigma)  (gamma) ];    
end