#define _XOPEN_SOURCE
#include <stdlib.h>

#define A( i,j ) *( ap + (j)*lda + (i) )          // map A( i,j )    to array ap    in column-major order

void RandomMatrix( int m, int n, double *ap, int lda )
/* 
   RandomMatrix overwrite A with random values.
*/
{
  int  i, j;

  for ( i=0; i<m; i++ )
    for ( j=0; j<n; j++ )
      A( i,j ) = drand48();
}
