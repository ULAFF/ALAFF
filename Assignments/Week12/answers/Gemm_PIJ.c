#define alpha( i,j ) A[ (j)*ldA + i ]   // map alpha( i,j ) to array A 
#define beta( i,j )  B[ (j)*ldB + i ]   // map beta( i,j )  to array B
#define gamma( i,j ) C[ (j)*ldC + i ]   // map gamma( i,j ) to array C

void MyGemm( int m, int n, int k, double *A, int ldA,
	     double *B, int ldB, double *C, int ldC )
{
  for ( int p=0; p<k; p++ )
    for ( int i=0; i<m; i++ )
      for ( int j=0; j<n; j++ )
        gamma( i,j ) += alpha( i,p ) * beta( p,j );
}
  
