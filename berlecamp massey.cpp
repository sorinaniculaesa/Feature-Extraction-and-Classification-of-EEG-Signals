#include <stdio.h>
#include <stdlib.h>

void berlekamp_massey(int sequence[], int n, int* C, int* L) {
    int* B = (int*)malloc(n * sizeof(int));
    int* T = (int*)malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        C[i] = 0;
        B[i] = 0;
    }
    C[0] = 1;
    B[0] = 1;
    *L = 0;
    int m = -1, b = 1;

    for (int i = 0; i < n; i++) {
        int d = sequence[i];
        for (int j = 1; j <= *L; j++) {
            d ^= C[j] * sequence[i - j];
        }

        if (d == 1) {
            for (int k = 0; k < n; k++) T[k] = C[k];

            for (int j = 0; (i - m + j) < n; j++) {
                if (B[j]) {
                    C[i - m + j] ^= 1;
                }
            }

            if (2 * (*L) <= i) {
                *L = i + 1 - *L;
                m = i;
                for (int k = 0; k < n; k++) B[k] = T[k];
            }
        }
    }

    free(B);
    free(T);
}

int main() {
    int sequence[] = { 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0,
                      1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1,
                      1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1,
                      0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0 };
    int n = sizeof(sequence) / sizeof(sequence[0]);
    int* C = (int*)malloc(n*sizeof(int));
    int L;

    berlekamp_massey(sequence, n, C, &L);

    printf("Polinom de feedback: ");
    for (int i = 0; i <= L; i++) {
        printf("%d ", C[i]);
    }
    printf("\nLungimea LFSR: %d\n", L);

    return 0;
}


