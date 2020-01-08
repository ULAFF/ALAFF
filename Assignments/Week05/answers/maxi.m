function i = maxi( x )
% maxi Return index of element with maximal magnitude.  (indexing starts at
% 0 )
%   Input
%      x - input vector
%      i - desired index
  [ t, i ] = max( abs( x ) );
  % adjust i so that indexing starts at 0
  i = i - 1;
end