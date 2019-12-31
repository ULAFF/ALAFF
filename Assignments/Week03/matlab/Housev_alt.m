function [ rho, ...
           u2, tau ] = Housev_alt( chi1, ...
                                    x2 )

  chi2 = norm( x2 );
  alpha = norm( [ chi1 ...
                  chi2 ] );
  rho = - sign( chi1 ) * alpha;
  nu1 = chi1 - rho;
  u2 = x2 / nu1;
  chi2 = chi2 / abs( nu1 );  

  tau = ( 1 + chi2*chi2 ) / 2;

return
 