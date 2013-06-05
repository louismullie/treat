
#include <math.h>

void sigmoid(int n,double v[n],double out[n]) {
    for(int i=0;i<n;i++) {
        double x = v[i];
        x = x<-100?-100:x>100?100:x;
        out[i] = 1.0/(1.0+exp(-x));
    }
}

void dotplus(int n,int m,double v[n],double a[n][m],double u[m]) {
    for(int i=0;i<n;i++) {
        double total;
        for(int j=0;j<m;j++) total += a[i][j]*u[j];
        v[i] += total;
    }
}

void prodplus(int n,double u[n],double v[n],double out[n]) {
    for(int i=0;i<n;i++) {
        out[i] += u[i]*v[i];
    }
}

void sumouter(int r,int n,int m,double a[n][m],double u[r][n],double v[r][m]) {
    for(int i=0;i<n;i++) {
        for(int j=0;j<m;j++) {
            double total = 0.0;
            for(int k=0;k<r;k++) total += u[k][i]*v[k][j];
            a[i][j] = total;
        }
    }
}

void sumprod(int r,int n,double u[r][n],double v[r][n],double a[n]) {
    for(int i=0;i<n;i++) {
        double total = 0.0;
        for(int k=0;k<r;k++) total += u[k][i]*v[k][i];
        a[i] = total;
    }
}
