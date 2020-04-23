#include "blis.h"

#define alpha( i,j ) A[ (j)*ldA + i ]   // map alpha( i,j ) to array A 
#define beta( i,j )  B[ (j)*ldB + i ]   // map beta( i,j )  to array B
#define gamma( i,j ) C[ (j)*ldC + i ]   // map gamma( i,j ) to array C

void MyGemm( int m, int n, int k, double *A, int ldA,
	     double *B, int ldB, double *C, int ldC )
{
  double d_one = 1.0;
  
  for ( int j=0; j<n; j++ )
    bli_dgemv( BLIS_NO_TRANSPOSE, BLIS_NO_CONJUGATE,
	       m, k, &d_one, A, 1, ldA, &beta( 0, j ), 1,
	       &d_one, &gamma( 0,j ), 1 );
}
  
