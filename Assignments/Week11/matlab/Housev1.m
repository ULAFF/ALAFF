function [ u, tau ] = Housev1( x )

  n = size( x, 1 );
  if ( n == 0 )
      abort( 'error calling Housev1' );
  end
  
  [ rho, ...
     u2, tau ] = Housev( x(1,1), ...
                         x(2:n, 1) );
                     
  u = [ rho
         u2 ];
end

 