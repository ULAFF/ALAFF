function [ rho, ...
           u2, tau ] = Housev( chi1, ...
                               x2 )

  normx = sqrt( chi1 * chi1 + x2' * x2 );

  rho = - sign( chi1 ) * normx;
  nu1 = chi1 - rho;
  u2 = x2 / nu1;

  tau = ( 1 + u2' * u2 ) / 2;

return
 